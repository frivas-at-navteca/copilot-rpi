# oc-rpi — OpenCode Reference & Project Intelligence

<!-- AGENTS.md for the oc-rpi subdirectory.
Read by every agent working inside oc-rpi/.
Inherits all rules from the root AGENTS.md — only oc-rpi-specific additions here. -->

## What This Is

The OpenCode counterpart to `copilot-rpi`. Contains templates, commands, agents,
instructions, and scripts adapted for OpenCode projects using the RPI methodology.

## oc-rpi File Locations

Go directly to these paths — never search for them.

| Topic | Path |
|-------|------|
| Command templates | `oc-rpi/templates/commands/` (17 files) |
| Agent templates | `oc-rpi/templates/agents/` (3 files) |
| Instruction templates | `oc-rpi/templates/instructions/` (3 files) |
| Skill templates | `oc-rpi/templates/skills/` |
| AGENTS.md template | `oc-rpi/templates/AGENTS.md.template` |
| opencode.json template | `oc-rpi/templates/opencode.json.template` |
| Setup checklist | `oc-rpi/templates/setup-checklist.md` |
| Script templates | `oc-rpi/templates/scripts/` (2 files) |

## OpenCode Concept Mapping

| Copilot concept | OpenCode equivalent |
|---|---|
| `.github/prompts/*.prompt.md` | `.opencode/commands/*.md` |
| `${input:variableName}` | `$ARGUMENTS` / `$1`, `$2`... |
| `.github/chatmodes/*.chatmode.md` | `.opencode/agents/*.md` |
| `.github/instructions/*.instructions.md` with `applyTo:` | `opencode.json` `instructions` array |
| `.github/copilot-instructions.md` | `AGENTS.md` + `opencode.json` |
| `.vscode/settings.json` Copilot flags | `opencode.json` project config |
| `copilot -p` headless | `opencode run` headless |
| Blueprint sync JSON | `.opencode/oc-rpi-sync.json` |

## Key Differences from copilot-rpi Templates

- Command files use `$ARGUMENTS` (not `${input:variableName}`)
- No `mode:` frontmatter field in commands — OpenCode commands run in the active agent
- Agent files use `mode: subagent` (not `tools: [...]` chatmode array syntax)
- Instructions are loaded via `opencode.json` `instructions` array (not `applyTo:` frontmatter)
- Sync state stored at `.opencode/oc-rpi-sync.json` (not `.github/copilot-rpi-sync.json`)
- Shell scripts use `opencode run` (not `copilot -p` or `claude -p`)

## Lint Rules

Same as the repo root — run `npx markdownlint-cli2 "oc-rpi/**/*.md"` before committing.
