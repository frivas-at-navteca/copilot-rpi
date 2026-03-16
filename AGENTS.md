# copilot-rpi — GitHub Copilot Reference & Project Intelligence

<!-- AGENTS.md — cross-tool instruction file for GitHub Copilot, Claude Code, Cursor, and Gemini CLI.
Read by every agent every session. Keep it lean.
Test each line: "Would removing this cause the agent to make a mistake?" If not, cut it. -->

## What This Is

This is the blueprint repository for projects that use GitHub Copilot. It contains:

- The RPI (Research-Plan-Implement) methodology adapted for GitHub Copilot
- A catalog of known agent errors with proven solutions
- Operational rules that prevent recurring mistakes
- Templates for AGENTS.md, prompt files, path-specific instructions, and project setup

## Stack

Pure Markdown — no code, no build toolchain, no package manager.
The only automated check is `markdownlint` via CI.

## How This Repo Is Used

When starting a new project, the agent is told: "Go check my copilot-rpi repository and set up the environment to follow all the best practices."

The agent should:

1. Read `patterns/quick-reference.md` — internalize all operational rules
2. Read `patterns/agent-errors.md` — know every known error pattern
3. Read `methodology/README.md` — understand the RPI approach (follow reading order for depth)
4. Use `templates/setup-checklist.md` to set up the new project
5. Adapt `templates/AGENTS.md.template` for the new project's AGENTS.md
6. Copy `templates/prompts/` into the new project's `.github/prompts/`
7. Copy `templates/github/instructions/` into `.github/instructions/`
8. Copy `templates/github/chatmodes/` into `.github/chatmodes/`

## RPI Workflow

This repo IS the RPI source — changes to it are themselves subject to RPI discipline.

All significant changes (new methodology sections, new error patterns, template refactors) go through:

1. `/research` — Understand what exists and where it lives
2. `/plan` — Draft the change with a clear rationale
3. `/implement` — Make the change; verify with markdownlint
4. `/validate` — Confirm CI passes and content is consistent

Minor fixes (typos, formatting, broken links) can skip planning.

### Context Management

- Each RPI phase should be its own conversation.
- Start a new Chat window between unrelated tasks.
- Use `#file:path` for targeted reads; use `#codebase` for broad searches.
- Research and planning happen on `main` (this is a single-branch docs repo).

### Rules for All Phases

- Read all mentioned files COMPLETELY before doing anything else.
- Never suggest improvements during research — only document what exists.
- Never write documents with placeholder values.
- Keep all content generic — no project-specific references anywhere in this repo.

## Key Commands

```bash
# Verify markdown before committing — mirrors CI exactly
npx markdownlint-cli2 "**/*.md" "!node_modules/**"
```

**Run this before every commit.** There is no pre-commit hook — CI is the enforcer.
Fix all lint errors before pushing.

## Git Workflow

**`main` is the only branch.**
This is a documentation-only repo — all changes go directly to `main`.

1. All work happens on `main`
2. Always run markdownlint before committing
3. Always commit before pulling — `git pull --rebase` requires a clean working tree
4. Always verify the current branch before committing — run `git branch --show-current`
5. After any structural change (new files, renamed sections), check cross-references for breakage

### Commit Messages

Use conventional commits:

```text
docs: description
feat: description
fix: description
chore: description
pattern: add Error #N — title
```

Use `pattern:` for new error catalog entries.

### Push Sequence

```bash
# Standard push — ALWAYS commit before pulling (Error #19)
git add <files> && git commit -m "msg" && git pull --rebase && git push
```

## Agent Operational Rules

### Git Operations

- Remove worktrees BEFORE merging PRs with `--delete-branch`
- Use `git worktree remove --force` — always force; use `;` not `&&` for chains
- Use `git branch -D` (uppercase) for worktree branches
- Don't fabricate filesystem paths — use the working directory or discover with `ls`

### GitHub CLI

- Don't guess `gh --json` field names — query available fields first
- `review: fail` means "needs approval", NOT a CI failure — always filter it out
- Check for existing PRs before `gh pr create` — use `gh pr list --head <branch>` first

### Parallel Agent Rules

- Designate one agent as the git committer when running parallel agents
- Parallel agents commit locally; the lead agent batch-pushes all branches

## Push Accountability

After every push to `main`:

1. Verify CI: `gh run list --branch main --limit 1`
2. If CI passes — done
3. If CI fails — run `gh run view <id> --log-failed`, fix the lint error, re-push
4. The push is not done until CI is green

CI runs markdownlint only — failures are always lint errors in `.md` files.

## Agent Autonomy

Before asking the user to do anything manually:

1. Exhaust CLI tools (`gh`, `git`)
2. Exhaust terminal commands (markdownlint, file operations)
3. Only then escalate — with a clear explanation of what you tried

Commit and push when changes are complete.
Do not wait to be asked unless the change is risky or destructive.

## Contributing to This Repo

### Adding Error Patterns

When new agent error patterns are discovered during work on ANY project:

1. Add a full entry to `patterns/agent-errors.md` — format: Error #N — Title, Symptom, Root Cause, Correct Approach, What NOT to Do
2. Add a one-liner to `patterns/quick-reference.md` under the appropriate section
3. Keep entries generic — no project-specific references
4. Use commit type `pattern:` — e.g., `pattern: add Error #30 — foo`

### Adding Methodology Content

When new best practices or methodology refinements are confirmed:

1. Add them to the appropriate file under `methodology/`
2. Or create a new file under `patterns/` if it's a distinct topic
3. Update `methodology/README.md` reading order if adding a new file

### Writing Style

- ATX-style headings (`#`, `##`, `###`)
- One sentence per line where practical (aids diffs)
- Fenced code blocks with language identifiers
- Lines under 120 characters where possible
- Plain, direct language — no filler words
- Keep all content generic — no project-specific references

## Error Screenshot Workflow

The user drops agent error screenshots into `~/Desktop/agent-errors/`.
Run `/process-errors` or follow the flow in `.github/copilot-instructions.md`.

The full workflow: read images → cross-reference `patterns/agent-errors.md` → skip duplicates →
add new entries → add one-liners to `quick-reference.md` → commit and push → delete processed images.

## Copilot-Specific Rules

- Always include YAML frontmatter in `.prompt.md` files — files without it won't appear in `/` menu
- Use `${input:variableName}` for prompt parameters, NOT `$ARGUMENTS` (that's Claude Code syntax)
- Path-specific instruction files need `applyTo` in frontmatter — without it they are never loaded
- Chat mode files must be in `.github/chatmodes/` — not `.github/prompts/` or project root
- Authenticate `copilot` CLI before using in cron/launchd — run `copilot auth` interactively first

## Project File Locations

Go directly to these paths — never search the codebase for them.

| Topic | Path | Notes |
|-------|------|-------|
| Operational rules | `patterns/quick-reference.md` | Read before any work |
| Error catalog | `patterns/agent-errors.md` | 29+ entries with root causes |
| Methodology overview | `methodology/README.md` | Reading order for all 10 files |
| New project setup | `templates/setup-checklist.md` | Step-by-step checklist |
| AGENTS.md template | `templates/AGENTS.md.template` | Canonical starting point |
| Prompt templates | `templates/prompts/` | 17 prompt files |
| Instruction templates | `templates/github/instructions/` | Path-specific rule templates |
| Chat mode templates | `templates/github/chatmodes/` | 3 specialized personas |
| This repo's prompts | `.github/prompts/` | process-errors, triage, remediate |
| Copilot instructions | `.github/copilot-instructions.md` | Runtime behavior addenda |

## Relationship to cc-rpi

This repo is the GitHub Copilot counterpart to `cc-rpi` (Claude Code Reference & Project Intelligence).
They share ~60% of content (philosophy, phases, testing, logging) but differ in tool-specific mechanics.
Keep them conceptually aligned but tool-appropriate.
When updating shared methodology content, check whether `cc-rpi` needs a parallel update.

## Repo Structure

```text
copilot-rpi/
├── .github/
│   ├── copilot-instructions.md       # Copilot auto-loaded project instructions
│   └── prompts/                      # Prompt files for maintaining THIS repo
│       ├── process-errors.prompt.md  # /process-errors — error screenshot pipeline
│       ├── triage.prompt.md          # /triage — morning report processing
│       └── remediate.prompt.md       # /remediate — fix all findings
├── AGENTS.md                         # This file — agent instructions + repo self-description
├── GUIDE.md                          # Human-readable quick-start guide
├── README.md                         # Public documentation
├── methodology/                      # The RPI approach
│   ├── README.md                     # Overview and reading order
│   ├── philosophy.md                 # Core tenets, error amplification
│   ├── context-engineering.md        # Context management, compaction, settings
│   ├── four-phases.md                # Research → Plan → Implement → Validate
│   ├── agent-design.md               # Documentarian rule, research catalog, autonomy
│   ├── pseudocode-notation.md        # Plan notation format
│   ├── testing.md                    # Automated-first verification, TDD protocol
│   ├── push-accountability.md        # Post-push CI ownership, background verification
│   ├── ci-and-guardrails.md          # Pre-commit hooks, CI workflows, enforcement
│   ├── scheduled-agents.md           # Recurring quality agents, cron/launchd
│   └── error-success-logging.md      # Systematic improvement framework
├── examples/                         # Sample documents and workflow walkthroughs
│   ├── README.md                     # Index of all examples
│   ├── research-document.md          # Sample research phase output
│   ├── implementation-plan.md        # Sample plan with phases and pseudocode
│   ├── implementation-plan-phases/   # Per-phase detail files
│   │   └── phase-1.md
│   ├── error-log.md                  # Sample error log entry
│   ├── success-log.md                # Sample success log entry
│   ├── pseudocode-examples.md        # Additional pseudocode notation examples
│   └── workflows/                    # End-to-end developer interaction walkthroughs
│       ├── bootstrap-new-project.md  # New project setup + first feature
│       ├── add-new-feature.md        # Adding rate limiting with full RPI cycle
│       └── refactor-existing-code.md # Auth service extraction with phased refactor
├── patterns/                         # Operational knowledge
│   ├── quick-reference.md            # Rules to internalize before any work
│   └── agent-errors.md               # Detailed error catalog with solutions
└── templates/                        # Files to adapt for new projects
    ├── AGENTS.md.template            # Starting point for project AGENTS.md
    ├── vscode-settings.json.template # .vscode/settings.json (Copilot config)
    ├── vscode-mcp.json.template      # .vscode/mcp.json (MCP server config)
    ├── setup-checklist.md            # Step-by-step new project setup
    ├── prompts/                      # Prompt file templates (.github/prompts/)
    │   ├── bootstrap.prompt.md       # /bootstrap — new project setup
    │   ├── adopt.prompt.md           # /adopt — existing project migration
    │   ├── update.prompt.md          # /update — blueprint sync
    │   ├── research.prompt.md        # /research — codebase research
    │   ├── plan.prompt.md            # /plan — implementation planning
    │   ├── implement.prompt.md       # /implement — phased execution
    │   ├── validate.prompt.md        # /validate — verification
    │   ├── quality-review.prompt.md  # /quality-review — code reuse, quality, efficiency review
    │   ├── describe-pr.prompt.md     # /describe-pr — PR description
    │   ├── pre-launch.prompt.md      # /pre-launch — production audit
    │   ├── remediate.prompt.md       # /remediate — fix all pre-launch findings
    │   ├── triage.prompt.md          # /triage — morning agent report processing
    │   ├── status.prompt.md          # /status — quick project orientation
    │   ├── fix-ci.prompt.md          # /fix-ci — self-healing CI
    │   ├── detach.prompt.md          # /detach — clean removal of copilot-rpi
    │   ├── release.prompt.md         # /release — version release automation
    │   └── update-docs.prompt.md     # /update-docs — comprehensive docs refresh
    ├── scripts/                      # Agent shell script templates
    │   ├── copilot-rpi-update-agent.sh  # Nightly blueprint sync agent
    │   └── morning-triage.sh            # Multi-project morning triage
    └── github/                       # Copilot-specific templates
        ├── copilot-instructions.md.template
        ├── instructions/             # Path-specific rule templates
        │   ├── tests.instructions.md.template
        │   ├── api.instructions.md.template
        │   └── migrations.instructions.md.template
        └── chatmodes/                # Specialized chat persona templates
            ├── rpi-research.chatmode.md
            ├── rpi-planner.chatmode.md
            └── rpi-auditor.chatmode.md
```
