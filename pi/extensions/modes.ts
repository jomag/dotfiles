import { isToolCallEventType, type ExtensionAPI, type ExtensionContext } from "@earendil-works/pi-coding-agent";

const planModeInstruction = `
You are in Plan mode.
Inspect the project only when useful.
Do not attempt changes.
Explain findings, alternatives, best-practices and proposed steps.
The user will implement changes manually unless they explicitly switch mode.
`;

const askModeInstruction = `
You are in Ask mode.
Do not use local-project tools.
Treat this as a context-free discussion unless the user supplies context directly.
`;

const buildModeInstruction = `
You are in Build mode.
The user has authorized file changes by explicitly entering this mode.
Make only the requested changes and explain what you changed.
Do not commit, push, install packages or alter configuration unless explicitly asked.
Shell commands outside the read-only allowlist require user approval.
Do not try to work around a denied command.
`;

type Mode = {
  commands?: string[],
  description?: string,
  instruction?: string,
  modeline?: string,
  tools?: string[],
  safeCommands?: Set<string>
}

const modes: Record<string, Mode> = {
  ask: {
    commands: ["ask", "a"],
    description: "Strict rubber-ducking with no read access",
    instruction: askModeInstruction,
    tools: []
  },
  plan: {
    commands: ["plan", "p"],
    tools: ["read", "ls", "find", "grep"],
    instruction: planModeInstruction
  },
  build: {
    commands: ["build", "b"],
    description: "Allow file changes. Confirm all potentially mutating shell commands.",
    instruction: buildModeInstruction,
    tools: ["read", "ls", "find", "grep", "bash", "edit", "write"],
    safeCommands: new Set(["git status", "git status --short", "git diff", "git diff --stat", "git log --oneline"])
  }

}

export default function (pi: ExtensionAPI): void {
  let activeMode: string | undefined;

  function enableMode(ctx: ExtensionContext, mode: string, announce = true) {
    if (mode === activeMode) {
      return;
    }

    const prev = activeMode;
    activeMode = mode;
    pi.setActiveTools(modes[mode]?.tools ?? []);
    ctx.ui.setStatus("modes", ctx.ui.theme.fg("accent", modes[mode]?.modeline ?? mode));

    if (announce && prev) {
      pi.sendMessage({
        customType: "mode-change",
        content: `Mode changed from '${prev}' to '${mode}'`,
        display: true
      }, { triggerTurn: false });
    }
  }

  for (const mode of Object.keys(modes)) {
    for (const cmd of modes[mode]?.commands ?? [mode]) {
      pi.registerCommand(cmd, {
        description: modes[mode]?.description,
        handler: async (_, ctx) => enableMode(ctx, mode),
      });
    }
  }

  pi.on("before_agent_start", (event) => {
    if (!activeMode) {
      return;
    }

    const instruction = modes[activeMode]?.instruction?.trim();
    if (!instruction) {
      return;
    }

    return {
      systemPrompt: `${event.systemPrompt}\n\n${instruction}`,
    }
  });

  pi.on("session_start", async (_event, ctx) => {
    enableMode(ctx, "plan", false);
  });

  pi.on("tool_call", async (event, ctx) => {
    if (activeMode !== "build") {
      return;
    }

    if (!isToolCallEventType("bash", event)) {
      return;
    }

    const command = event.input.command.trim();
    if (modes[activeMode]?.safeCommands?.has(command)) {
      return;
    }

    const allowed = await ctx.ui.confirm("Allow this command?", command);

    if (!allowed) {
      return {
        block: true,
        reason: "The user declined this shell command"
      }
    }
  });
}
