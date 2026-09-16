import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { StringEnum } from "@earendil-works/pi-ai";
import { Type } from "typebox";
import { execFile } from "node:child_process";
import { promisify } from "node:util";

const execFileAsync = promisify(execFile);

const DEFAULT_TIMEOUT_MS = 30_000;
const DEFAULT_OUTPUT_LIMIT_CHARS = 50_000;
const MAX_OUTPUT_CHARS = 200_000;

const actions = [
  "status",
  "log",
  "file_history",
  "reflog",
  "show_commit",
  "show_file",
  "diff",
  "diff_names",
  "ls_tree",
  "cat_file",
  "rev_parse",
  "merge_base",
  "branch_list",
  "tag_list",
  "blame",
] as const;

function validateOutputLimit(limit: unknown): number {
  if (typeof limit !== "number" || !Number.isFinite(limit)) {
    return DEFAULT_OUTPUT_LIMIT_CHARS;
  }

  return Math.min(Math.max(Math.floor(limit), 1), MAX_OUTPUT_CHARS);
}

function validateCount(count: unknown, fallback: number): number {
  if (typeof count !== "number" || !Number.isFinite(count)) {
    return fallback;
  }

  // FIXME: do not hardcode 500 here...
  return Math.min(Math.max(Math.floor(count), 1), 500);
}

function isSafeRev(rev: string): boolean {
  if (rev.length <= 0 || rev.length > 300) {
    return false;
  }

  if (rev.startsWith("-") || rev.includes(":")) {
    return false;
  }

  for (const char of rev) {
    if (char === " " || char === "\t" || char === "\n" || char === "\r") {
      return false;
    }

    const code = char.charCodeAt(0);

    if (code < 32 || code === 127) {
      return false;
    }
  }

  return true;
}

function isSafePath(path: string): boolean {
  if (path.length <= 0 || path.length > 1000) {
    return false;
  }

  if (
    path.startsWith("/") ||
    path.includes(":") ||
    path.split("/").includes("..")
  ) {
    return false;
  }

  for (const char of path) {
    const code = char.charCodeAt(0);
    if (code < 32 || code === 127) {
      return false;
    }
  }

  return true;
}

function requireRev(value: unknown, name: string): string {
  if (typeof value !== "string" || !isSafeRev(value.trim())) {
    throw new Error(`Invalid ${name}`);
  }

  return value.trim();
}

function optionalRev(value: unknown, name: string): string | undefined {
  if (value === undefined) {
    return undefined;
  }

  return requireRev(value, name);
}

function requirePath(value: unknown): string {
  if (typeof value !== "string" || !isSafePath(value.trim())) {
    throw new Error("Invalid path");
  }

  return value.trim();
}

function optionalPath(value: unknown): string | undefined {
  if (value === undefined) {
    return undefined;
  }

  return requirePath(value);
}

export default function (pi: ExtensionAPI): void {
  pi.registerTool({
    name: "git_read",
    label: "Git Read",
    description:
      "Read-only Git inspection tool for status, log, reflog, commits, historical file contents, diffs, trees, refs, branches, tags, merge-base, and blame.",
    promptGuidelines: [
      "Use git_read instead of bash for read-only Git inspection.",
      "Use git_read status before reasoning about the current repository state.",
      "Use git_read log or file_history to inspect recent history.",
      "Use git_read show_commit to inspect what a commit changed.",
      "Use git_read show_file to inspect a file at a specific revision.",
      "Use git_read diff or diff_names to compare revisions or inspect working-tree changes.",
      "Use git_read reflog when the user asks about previous HEAD positions or lost commits.",
    ],
    parameters: Type.Object({
      action: StringEnum(actions),
      rev: Type.Optional(
        Type.String({
          description:
            "Git revision or range, e.g. HEAD, main, HEAD~2, abc123, main..HEAD",
        }),
      ),
      revA: Type.Optional(
        Type.String({
          description: "First revision for comparisons, e.g. main",
        }),
      ),
      revB: Type.Optional(
        Type.String({
          description: "Second revision for comparisons, e.g. HEAD",
        }),
      ),
      path: Type.Optional(
        Type.String({
          description:
            "Repository-relative path, used for file-specific actions",
        }),
      ),
      maxCount: Type.Optional(
        Type.Number({
          description:
            "Maximum commits/reflog entries. Default depends on action.",
        }),
      ),
      maxChars: Type.Optional(
        Type.Number({
          description: `Maximum returned output characters. Default: ${DEFAULT_OUTPUT_LIMIT_CHARS}`,
        }),
      ),
    }),

    async execute(_toolCallId, params, signal, _onUpdate, ctx) {
      const maxChars = validateOutputLimit(params.maxChars);
      const args: string[] = ["--no-pager"];

      switch (params.action) {
        case "status": {
          args.push("status", "--short", "--branch");
          break;
        }

        case "log": {
          const count = validateCount(params.maxCount, 30);
          const rev = optionalRev(params.rev, "rev");
          const path = optionalPath(params.path);

          args.push(
            "log",
            "--graph",
            "--decorate",
            "--oneline",
            "--date=short",
            `-${count}`,
          );

          if (rev) {
            args.push(rev);
          }

          if (path) {
            args.push("--", path);
          }

          break;
        }

        case "file_history": {
          const count = validateCount(params.maxCount, 50);
          const path = requirePath(params.path);

          args.push(
            "log",
            "--follow",
            "--decorate",
            "--oneline",
            "--date=short",
            `-${count}`,
            "--",
            path,
          );

          break;
        }

        case "reflog": {
          const count = validateCount(params.maxCount, 50);
          args.push("reflog", "--date=iso", `-${count}`);
          break;
        }

        case "show_commit": {
          const rev = requireRev(params.rev ?? "HEAD", "rev");

          args.push(
            "show",
            "--no-ext-diff",
            "--no-textconv",
            "--stat",
            "--patch",
            "--decorate",
            rev,
          );
          break;
        }

        case "show_file": {
          const rev = requireRev(params.rev ?? "HEAD", "rev");
          const path = requirePath(params.path);

          args.push("show", "--no-ext-diff", "--no-textconv", `${rev}:${path}`);
          break;
        }

        case "diff": {
          const revA = optionalRev(params.revA, "revA");
          const revB = optionalRev(params.revB, "revB");
          const path = optionalPath(params.path);

          args.push("diff", "--no-ext-diff", "--no-textconv");

          if (revA && revB) {
            args.push(revA, revB);
          } else if (revA) {
            args.push(revA);
          }

          if (path) {
            args.push("--", path);
          }

          break;
        }

        case "diff_names": {
          const revA = optionalRev(params.revA, "revA");
          const revB = optionalRev(params.revB, "revB");
          const path = optionalPath(params.path);

          args.push("diff", "--name-status");

          if (revA && revB) {
            args.push(revA, revB);
          } else if (revA) {
            args.push(revA);
          }

          if (path) {
            args.push("--", path);
          }

          break;
        }

        case "ls_tree": {
          const rev = requireRev(params.rev ?? "HEAD", "rev");
          const path = optionalPath(params.path);

          args.push("ls-tree", "-r", "--name-only", rev);

          if (path) {
            args.push("--", path);
          }

          break;
        }

        case "cat_file": {
          const rev = requireRev(params.rev ?? "HEAD", "rev");
          args.push("cat-file", "-p", rev);
          break;
        }

        case "rev_parse": {
          const rev = requireRev(params.rev ?? "HEAD", "rev");
          args.push("rev-parse", "--verify", rev);
          break;
        }

        case "merge_base": {
          const revA = requireRev(params.revA, "revA");
          const revB = requireRev(params.revB, "revB");
          args.push("merge-base", revA, revB);
          break;
        }

        case "branch_list": {
          args.push("branch", "--all", "--verbose", "--no-abbrev");
          break;
        }

        case "tag_list": {
          args.push("tag", "--list", "--sort=-creatordate");
          break;
        }

        case "blame": {
          const path = requirePath(params.path);
          const rev = optionalRev(params.rev, "rev");
          args.push("blame", "--date=short");
          if (rev) {
            args.push(rev);
          }
          args.push("--", path);
          break;
        }

        default: {
          throw new Error(`Unsupported git_read action: ${params.action}`);
        }
      }

      const { stdout, stderr } = await execFileAsync("git", args, {
        cwd: ctx.cwd,
        timeout: DEFAULT_TIMEOUT_MS,
        maxBuffer: Math.max(maxChars * 4, 1024 * 1024),
        signal,
        env: {
          ...process.env,
          GIT_PAGER: "cat",
          GIT_TERMINAL_PROMPT: "0",
        },
      });

      const output = stdout.trim() || stderr.trim() || "(no output)";
      const truncated = output.length > maxChars;
      const returned = truncated
        ? `${output.slice(0, maxChars)}\n\n[truncated]`
        : output;

      return {
        content: [
          {
            type: "text",
            text: [
              `Command git ${args.join(" ")}`,
              `Truncated: ${truncated}`,
              "",
              returned,
            ].join("\n"),
          },
        ],
        details: {
          action: params.action,
          args,
          truncated,
        },
      };
    },
  });
}
