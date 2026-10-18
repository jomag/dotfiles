// Disclaimer: This file was generated with AI assistance.

import { execFile } from "node:child_process";
import { watch, type FSWatcher } from "node:fs";
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";

type Span = {
	file_name?: string;
	line_start?: number;
	column_start?: number;
	is_primary?: boolean;
};

type Diag = {
	level: string;
	code?: string;
	message: string;
	spans?: Span[];
	children?: Diag[];
};

type Report = {
	ok: boolean;
	diags: Diag[];
	ms: number;
	raw: string;
};

const MAX_REPORT_CHARS = 10000;

function runCargo(cwd: string, args: string[], signal?: AbortSignal): Promise<Report> {
	return new Promise((resolve) => {
		const started = Date.now();
		let stdout = "";
		let stderr = "";
		let done = false;

		const child = execFile("cargo", [...args, "--message-format=json", "--quiet"], {
			cwd,
			signal,
			maxBuffer: 32 * 1024 * 1024,
		});

		child.stdout?.on("data", (d) => (stdout += d));
		child.stderr?.on("data", (d) => (stderr += d));

		const settle = (r: Report) => {
			if (!done) {
				done = true;
				resolve(r);
			}
		};

		child.on("error", (err) =>
			settle({ ok: false, diags: [], ms: Date.now() - started, raw: err.message }),
		);

		child.on("close", (code, kill) => {
			const diags: Diag[] = [];
			for (const line of stdout.split("\n")) {
				if (!line.trim().startsWith("{")) {
					continue;
				}
				try {
					const msg = (JSON.parse(line) as { message?: Diag }).message;
					if (msg?.level === "error" || msg?.level === "warning") {
						diags.push(msg);
					}
				} catch {
					/* not json */
				}
			}

			const raw = code === null ? `aborted${kill ? ` (${kill})` : ""}` : stderr.trim().slice(-2000);

			settle({ ok: code === 0, diags, ms: Date.now() - started, raw });
		});
	});
}

function counts(r: Report) {
	const count = (level: string) =>
		r.diags.filter((d) => d.level === level && (d.code !== undefined || (d.spans?.length ?? 0) > 0))
			.length;

	return {
		errors: count("error"),
		warnings: count("warning"),
	};
}

function report(cmd: string, r: Report): string {
	const { errors, warnings } = counts(r);
	const lines: string[] = [];

	for (const d of r.diags) {
		const span = d.spans?.find((s) => s.is_primary) ?? d.spans?.[0];
		const loc = span?.file_name
			? ` — ${span.file_name}:${span.line_start}:${span.column_start}`
			: "";
		lines.push(`${d.code ? d.code + " " : ""}${d.message}${loc}`);
		const detail = d.children?.find((c) => c.message)?.message;
		if (detail) {
			lines.push(`    ${detail}`);
		}
	}

	const body = lines.length > 0 ? lines.join("\n") : r.raw;
	const status = r.ok && errors === 0 ? "clean" : `${errors} error(s), ${warnings} warning(s)`;
	const text = `${cmd}\nstatus: ${status} · ${(r.ms / 1000).toFixed(1)}s\n\n${body}`;

	return text.length > MAX_REPORT_CHARS ? `${text.slice(0, MAX_REPORT_CHARS)}\n[truncated]` : text;
}

export default function (pi: ExtensionAPI): void {
	let ctx: ExtensionContext | undefined;
	let watcher: FSWatcher | undefined;
	let timer: NodeJS.Timeout | undefined;
	let busy = false;
	let last: "clean" | "errors" | undefined;

	const cargoTool = (name: string, label: string, cmd: string, description: string) =>
		pi.registerTool({
			name,
			label,
			description,
			parameters: Type.Object({}),
			async execute(_id, _params, signal) {
				const r = await runCargo(ctx?.cwd ?? process.cwd(), [cmd], signal);
				const { errors, warnings } = counts(r);
				return {
					content: [{ type: "text", text: report(cmd, r) }],
					details: { ok: r.ok, errors, warnings, durationMs: r.ms },
				};
			},
		});

	cargoTool(
		"rust_check",
		"Rust Check",
		"check",
		"Run cargo check and return a compact report of compiler errors and warnings.",
	);
	cargoTool(
		"rust_clippy",
		"Rust Clippy",
		"clippy",
		"Run cargo clippy and return a compact report of lints.",
	);

	pi.on("session_start", (_e, c) => {
		ctx = c;
		try {
			watcher = watch(c.cwd, { recursive: true }, (_ev, name) => {
				if (!name || (!name.endsWith(".rs") && name !== "Cargo.toml")) {
					return;
				}
				clearTimeout(timer);
				timer = setTimeout(() => void backgroundCheck(), 1000);
			});
		} catch {
			/* recursive watch unsupported; background check disabled */
		}
	});

	async function backgroundCheck() {
		if (!ctx || busy) {
			return;
		}
		busy = true;
		const t = ctx.ui.theme;
		ctx.ui.setStatus("rust", t.fg("muted", "cargo check: running…"));
		const r = await runCargo(ctx.cwd, ["check"]).catch(() => undefined);
		if (r) {
			const { errors } = counts(r);
			const clean = r.ok && errors === 0;
			ctx.ui.setStatus(
				"rust",
				clean
					? t.fg("success", `✓ cargo check clean · ${(r.ms / 1000).toFixed(1)}s`)
					: t.fg("error", `✗ cargo check: ${errors} error(s)`),
			);
			if (last !== (clean ? "clean" : "errors")) {
				ctx.ui.notify(
					clean ? "cargo check: clean" : `cargo check: ${errors} error(s)`,
					clean ? "info" : "error",
				);
			}
			last = clean ? "clean" : "errors";
		}
		busy = false;
	}

	pi.on("session_shutdown", () => {
		watcher?.close();
		clearTimeout(timer);
		ctx = undefined;
	});
}
