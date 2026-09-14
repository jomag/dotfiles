import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";
import { execFile } from "node:child_process";
import { promisify } from "node:util";

const execFileAsync = promisify(execFile);

const DEFAULT_TIMEOUT_MS = 30_000;
const DEFAULT_OUTPUT_LIMIT_CHARS = 50_000;
const MAX_OUTPUT_CHARS = 200_000;

const SAFE_OPERATION_PREFIXES = ["describe-", "list-", "get-", "search-"];
const SAFE_EXACT_OPERATIONS = new Set(["sts:get-caller-identity"]);

const BLOCKED_OPERATIONS = new Set([
  "secretsmanager:get-secret-value",
  "ssm:get-parameter",
  "ssm:get-parameter-history",
  "ssm:get-parameters",
  "ssm:get-parameters-by-path",
  "ecr:get-login-password",
  "s3api:get-object",
]);

const BLOCKED_ARG_FLAGS = new Set([
  "--profile",
  "--region",
  "--output",
  "--endpoint-url",
]);

function validateOutputLimit(limit: unknown): number {
  if (typeof limit !== "number" || !Number.isFinite(limit)) {
    return DEFAULT_OUTPUT_LIMIT_CHARS;
  }

  return Math.min(Math.max(Math.floor(limit), 1), MAX_OUTPUT_CHARS);
}

function isSafeName(name: string): boolean {
  return /^[a-zA-Z0-9_.:@+=,-]+$/.test(name);
}

function isSafeOperation(service: string, operation: string): boolean {
  const key = `${service}:${operation}`;

  if (BLOCKED_OPERATIONS.has(key)) {
    return false;
  }

  if (SAFE_EXACT_OPERATIONS.has(key)) {
    return true;
  }

  return SAFE_OPERATION_PREFIXES.some((pfx) => operation.startsWith(pfx));
}

function validateExtraArgs(args: string[]): string | undefined {
  for (const arg of args) {
    if (arg.includes("\0")) {
      return "Arguments may not contain null bytes";
    }

    if (BLOCKED_ARG_FLAGS.has(arg)) {
      return `Do not pass ${arg} in args; use the dedicated tool parameter instead`;
    }
  }
}

export default function (pi: ExtensionAPI): void {
  pi.registerTool({
    name: "aws_read",
    label: "AWS Read",
    description:
      "Run safe read-only AWS CLI operations such as describe, list and get. Supports AWS profiles and regions.",
    parameters: Type.Object({
      service: Type.String({
        description:
          "AWS service name, e.g. ec2, s3api, iam, sts, cloudformation",
      }),
      operation: Type.String({
        description:
          "AWS CLI operation, e.g. describe-instances, list-buckets, get-caller-identity",
      }),
      profile: Type.Optional(
        Type.String({
          description: "AWS CLI profile to use",
        }),
      ),
      region: Type.Optional(
        Type.String({
          description: "AWS region, e.g. eu-west-1",
        }),
      ),
      query: Type.Optional(
        Type.String({
          description: "Optional JMESPath --query expression to reduce output",
        }),
      ),
      args: Type.Optional(
        Type.Array(Type.String(), {
          description: "Additional AWS CLI arguments for this read operation",
        }),
      ),
      maxChars: Type.Optional(
        Type.Number({
          description: `Maximum returned output characters. Default limit ${DEFAULT_OUTPUT_LIMIT_CHARS}`,
        }),
      ),
    }),

    async execute(_toolCallId, params) {
      const service = params.service.trim();
      const operation = params.operation.trim();
      const profile = params.profile?.trim();
      const region = params.region?.trim();
      const query = params.query;
      const extraArgs = params.args ?? [];
      const maxChars = validateOutputLimit(params.maxChars);

      if (!isSafeName(service) || !isSafeName(operation)) {
        return {
          isError: true,
          content: [
            { type: "text", text: "Invalid service or operation name." },
          ],
          details: {},
        };
      }

      if (profile && !isSafeName(profile)) {
        return {
          isError: true,
          content: [{ type: "text", text: "Invalid AWS profile name" }],
          details: {},
        };
      }

      if (region && !isSafeName(region)) {
        return {
          isError: true,
          content: [{ type: "text", text: "Invalid AWS region name" }],
          details: {},
        };
      }

      if (!isSafeOperation(service, operation)) {
        return {
          isError: true,
          content: [
            {
              type: "text",
              text: `Blocked AWS operation: ${service} ${operation}. Only safe read-only operations are allowed`,
            },
          ],
          details: { service, operation },
        };
      }

      const argError = validateExtraArgs(extraArgs);
      if (argError) {
        return {
          isError: true,
          content: [{ type: "text", text: argError }],
          details: { service, operation },
        };
      }

      const awsArgs: string[] = [];

      if (profile) {
        awsArgs.push("--profile", profile);
      }

      if (region) {
        awsArgs.push("--region", region);
      }

      if (query) {
        awsArgs.push("--query", query);
      }

      awsArgs.push("--output", "json");
      awsArgs.push(service, operation, ...extraArgs);

      try {
        const { stdout, stderr } = await execFileAsync("aws", awsArgs, {
          timeout: DEFAULT_TIMEOUT_MS,
          maxBuffer: Math.max(maxChars * 4, 1024 * 1024),
        });

        // FIXME: what if there's both stdout and stderr output?
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
                `Command aws ${awsArgs.join(" ")}`,
                profile ? `Profile: ${profile}` : undefined,
                region ? `Region: ${region}` : undefined,
                `Truncated: ${truncated}`,
                "",
                returned,
              ]
                .filter(Boolean)
                .join("\n"),
            },
          ],
          details: {
            service,
            operation,
            profile,
            region,
            truncated,
          },
        };
      } catch (err) {
        const message = err instanceof Error ? err.message : String(err);
        return {
          isError: true,
          content: [{ type: "text", text: message }],
          details: {
            service,
            operation,
            profile,
            region,
          },
        };
      }
    },
  });
}
