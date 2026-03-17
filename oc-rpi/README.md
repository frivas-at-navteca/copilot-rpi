# oc-rpi — OpenCode Reference & Project Intelligence

Blueprint repository for projects that use OpenCode.
The OpenCode counterpart to `copilot-rpi`.

Contains the RPI (Research-Plan-Implement) methodology adapted for OpenCode,
with commands, agents, instruction files, skills, and scheduled-agent scripts.

---

## What's Inside

```text
oc-rpi/
├── AGENTS.md                          # Agent instructions for this subdirectory
├── README.md                          # This file
└── templates/
    ├── AGENTS.md.template             # Project AGENTS.md starting point
    ├── opencode.json.template         # Project opencode.json starting point
    ├── setup-checklist.md             # Step-by-step new project setup guide
    ├── commands/                      # 17 OpenCode command files (.opencode/commands/)
    │   ├── research.md
    │   ├── plan.md
    │   ├── implement.md
    │   ├── validate.md
    │   ├── bootstrap.md
    │   ├── adopt.md
    │   ├── update.md
    │   ├── detach.md
    │   ├── quality-review.md
    │   ├── pre-launch.md
    │   ├── remediate.md
    │   ├── triage.md
    │   ├── status.md
    │   ├── fix-ci.md
    │   ├── describe-pr.md
    │   ├── release.md
    │   └── update-docs.md
    ├── agents/                        # 3 OpenCode agent files (.opencode/agents/)
    │   ├── rpi-research.md            # Read-only documentarian subagent
    │   ├── rpi-planner.md             # Read-only planning subagent
    │   └── rpi-auditor.md             # Read-only validation subagent
    ├── instructions/                  # Domain instruction files (opencode.json instructions array)
    │   ├── tests.md
    │   ├── api.md
    │   └── migrations.md
    ├── skills/
    │   └── process-errors/
    │       └── SKILL.md               # Skill for processing error screenshots
    └── scripts/
        ├── oc-rpi-update-agent.sh     # Nightly blueprint sync agent
        └── morning-triage.sh          # Multi-project morning triage orchestrator
```

## OpenCode Concept Mapping

| Copilot / VS Code concept | OpenCode equivalent |
|---------------------------|---------------------|
| `.github/prompts/*.prompt.md` | `.opencode/commands/*.md` |
| `${input:variableName}` | `$ARGUMENTS` / `$1`, `$2`... |
| `.github/chatmodes/*.chatmode.md` | `.opencode/agents/*.md` |
| `applyTo:` glob in instructions | `opencode.json` `instructions` array |
| `.github/copilot-instructions.md` | `AGENTS.md` + `opencode.json` |
| `.vscode/settings.json` | `opencode.json` |
| `copilot -p` headless | `opencode run` headless |
| `.github/copilot-rpi-sync.json` | `.opencode/oc-rpi-sync.json` |

## How to Use

### Set up a new project

1. Run `/bootstrap` with the path to this repo as the argument.
2. The agent reads `templates/setup-checklist.md` and walks you through setup.

### Adopt an existing project

1. Run `/adopt` with the path to this repo as the argument.
2. The agent audits the project, presents a gap report, and migrates with your approval.

### Keep a project in sync

1. Copy `templates/scripts/oc-rpi-update-agent.sh` to your project.
2. Configure `OC_RPI_PATH` and schedule it nightly.
3. It reads the `/update` command from oc-rpi at runtime — always uses the latest logic.

## RPI Workflow

All significant changes go through four phases:

1. `/research` — Understand the codebase as-is (documentarian mode)
2. `/plan` — Create a phased implementation spec with pseudocode
3. `/implement` — Execute one phase at a time with review gates
4. `/validate` — Verify implementation against the plan

Each phase is its own conversation. Don't run multiple phases in one session.

## Relationship to copilot-rpi

OpenCode counterpart to `copilot-rpi`.
~60% shared methodology content; differs in tool-specific mechanics.
When updating shared methodology content, check whether `copilot-rpi` needs a parallel update.
