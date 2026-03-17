# New Project Setup Checklist

Use this when setting up a new project to follow oc-rpi best practices.

## README Header

- [ ] Structure the project README with a standard header:
  1. `# Project Name — Tagline`
  2. GitHub badges (CI, Security Scan, Secret Scanning, stack versions, and optionally
     license if open source)
  3. One-line project description
  4. Horizontal divider (`---`)
  5. Rest of the README content below the divider
- [ ] Adjust badge URLs to match the project's GitHub owner/repo
- [ ] Add or remove stack badges as relevant

## Directory Setup

- [ ] Create `AGENTS.md` at project root (adapt from `AGENTS.md.template`)
  - Manually craft every line — don't auto-generate
  - Keep it lean: only universally applicable instructions
  - This is the cross-tool instruction file (read by OpenCode, Claude Code, Cursor, etc.)
- [ ] Create `opencode.json` at project root (adapt from `opencode.json.template`)
- [ ] Create `.opencode/commands/` and copy command files from `templates/commands/`
- [ ] Create `.opencode/agents/` for specialized agent personas:
  - `rpi-research.md` — documentarian-constrained research subagent (read-only)
  - `rpi-planner.md` — planning subagent with pseudocode output (read-only)
  - `rpi-auditor.md` — validation subagent with structured reports (read-only)
- [ ] Add instruction file globs to `opencode.json` `instructions` array:
  - Domain instruction files auto-load when agent opens matching files
- [ ] Create `docs/` directory with subdirectories:
  - `docs/research/` — Research documents
  - `docs/plans/` — Implementation plans
  - `docs/decisions/` — Architecture decision records
  - `docs/agents/` — Agent reports and project memory

## AGENTS.md Configuration

- [ ] Fill in project name, description, and stack
- [ ] Document build/test/lint commands
- [ ] Document deployment pipeline (which branch deploys where)
- [ ] Document git workflow (default branch, production branch)
- [ ] Include all Agent Operational Rules from the template
- [ ] Add project-specific context (key routes, data types, code ownership)

## opencode.json Configuration

- [ ] Set `$schema` for IDE support
- [ ] Configure `instructions` glob array for domain instruction files
- [ ] Add any project-specific model overrides if needed

The `instructions` array is how OpenCode loads domain-specific rules automatically.
Add globs matching your instruction files:

```json
{
  "instructions": [
    ".opencode/instructions/tests.md",
    ".opencode/instructions/api.md",
    ".opencode/instructions/migrations.md"
  ]
}
```

## Command Files

Copy and adapt from `templates/commands/`:

- [ ] `/research` — Codebase research with documentarian constraint
- [ ] `/plan` — Interactive plan creation with phases
- [ ] `/implement` — Phase-by-phase execution with review gates
- [ ] `/validate` — Post-implementation verification
- [ ] `/describe-pr` — PR description generation
- [ ] `/pre-launch` — Multi-specialist production audit
- [ ] `/remediate` — Fix all pre-launch findings with parallel TDD agents
- [ ] `/triage` — Morning agent report processing and action

Verify each file has valid YAML frontmatter with a `description:` field.

**Commands vs instructions:** Commands (`.opencode/commands/`) are user-invoked
workflows — they appear in the `/` menu. Instructions (referenced via `opencode.json`
`instructions` array) are auto-loaded rules. Use commands for RPI phases; use
instructions for domain conventions.

## Instruction Files

Create domain instruction files and reference them in `opencode.json`:

- [ ] Test conventions (apply to test files via glob)
- [ ] API conventions (apply to route/controller files via glob)
- [ ] Migration conventions (apply to migration files via glob, if applicable)

Each instruction file is a plain markdown file — no frontmatter needed.
The `opencode.json` `instructions` array controls when they are loaded.

## Agent Files

- [ ] Create research agent: `.opencode/agents/rpi-research.md`
  - Bakes in the documentarian constraint at the session level
  - `mode: subagent`, tools restricted (no write, edit, bash)
  - Invoked with `@rpi-research` in chat
- [ ] Create planning agent: `.opencode/agents/rpi-planner.md`
  - Includes pseudocode notation reference
  - Focuses on interactive plan development
  - `mode: subagent`, tools restricted (no write, edit, bash)
- [ ] Create auditor agent: `.opencode/agents/rpi-auditor.md` (optional)
  - Read-only validation with structured report output
  - `mode: subagent`

## Pre-Commit Hooks

- [ ] Install a hook framework (e.g., Husky for Node.js, pre-commit for Python)
- [ ] Configure pre-commit to run typecheck + lint:

  ```bash
  # Example: Husky
  npx husky init
  echo "pnpm run typecheck && pnpm run lint" > .husky/pre-commit
  ```

- [ ] Test that the hook rejects a commit with a deliberate type error
- [ ] Add a note to AGENTS.md reminding agents to run checks before committing

## CI Setup

- [ ] Create a CI workflow (GitHub Actions, etc.) that runs on push and PR:
  - Typecheck
  - Lint
  - Unit tests
  - Build verification
  - (Optional) Security audit, E2E tests
- [ ] Mark critical CI jobs as required for PR merges
- [ ] Enable branch protection on the production branch (require CI + review)
- [ ] Verify CI runs successfully on the development branch

## Git Setup

- [ ] Initialize repo with `main` as production branch
- [ ] Create `develop` as default working branch
- [ ] Set up branch protection rules on GitHub
- [ ] Configure pre-commit hooks (typecheck, lint, test)

## Push Accountability

- [ ] Add push accountability instructions to AGENTS.md:
  - After every push to develop, verify CI passes
  - Investigate failures, fix, and re-push
- [ ] Test the workflow: push a deliberate failure, verify the process catches it

## Scheduled Agents (Optional)

- [ ] Create `scripts/agents/` directory for agent shell scripts
- [ ] Create `docs/agents/` directory for agent reports and shared context
- [ ] Create `logs/` directory for agent output capture
- [ ] **Set up the `/update` agent first** — keeps your project in sync with oc-rpi
      improvements:
  1. Copy `templates/scripts/oc-rpi-update-agent.sh` to `scripts/agents/oc-rpi-update.sh`
  2. Set `OC_RPI_PATH` to your oc-rpi clone location
  3. Make executable: `chmod +x scripts/agents/oc-rpi-update.sh`
  4. Create required directories: `mkdir -p docs/agents logs`
  5. Schedule with launchd or cron (examples are in the script comments)
- [ ] Write additional agent scripts (e.g., test-health, security-audit)
- [ ] Ensure OpenCode CLI is authenticated (`opencode auth` or equivalent)
- [ ] Schedule with launchd (macOS) or cron (Linux)
- [ ] Test with `launchctl start` (macOS) — don't test from a terminal,
      it masks launchd issues
- [ ] Verify the agent runs successfully and produces a report

## Workflow Habits

- [ ] Always `/research` before `/plan`
- [ ] Always `/plan` before `/implement`
- [ ] Always review plans before approving
- [ ] Never skip the human confirmation gate between implementation phases
- [ ] Use `/validate` after implementation
- [ ] Run `/remediate` after `/pre-launch` to fix all findings with parallel agents
- [ ] Run `/triage` every morning to process overnight agent reports
- [ ] Start a new session between unrelated tasks to reset context
- [ ] Run each RPI phase in its own conversation
- [ ] Research and plan on the default branch; implement in feature branches
- [ ] Read research output critically — throw out and redo if wrong
- [ ] Invest most review time on research and plans, not generated code
- [ ] Follow TDD: write failing tests before implementation code
- [ ] Monitor CI after every push — never push and forget

## Project-Type Adaptation

The defaults above assume a web application.
Adapt these sections based on your project type:

### Web Application (default)

The standard setup applies as-is.

### Library / npm Package

- **Git workflow:** May use `main` only (no `develop`) if releases are tagged from `main`
- **CI additions:** Add `npm pack` or `pnpm pack` verification, publish dry-run
- **AGENTS.md:** Document the public API surface

### CLI Tool

- **CI additions:** Test the CLI binary end-to-end
- **AGENTS.md:** Document all commands and flags.
  ESM CLI files use shebang — never run with `node`

### Monorepo

- **CI additions:** Use `turbo`/`nx` affected detection
- **AGENTS.md:** Document the workspace structure,
  how packages depend on each other
- **Pre-commit:** Run typecheck across ALL workspace packages

### Python Project

- **Pre-commit hooks:** Use the `pre-commit` framework (not Husky)
- **Key commands:** Replace `pnpm run *` with equivalents: `pytest`, `mypy .`,
  `ruff check .`

### Static Site / Documentation

- **Git workflow:** May deploy directly from `main`
- **CI:** Build verification + link checking

## Directory Structure

```text
docs/
├── research/                  # Research documents
│   └── YYYY-MM-DD-topic.md
├── plans/                     # Implementation plans
│   ├── YYYY-MM-DD-feature.md  # Main plan
│   └── YYYY-MM-DD-feature-phases/
│       ├── phase-1.md
│       └── phase-2.md
├── decisions/                 # ADRs / decision records
└── agents/                    # Agent reports and project memory
    ├── project-memory.md
    ├── shared-context.md
    └── *-report.md
```
