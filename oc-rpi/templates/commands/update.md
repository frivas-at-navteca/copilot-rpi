---
description: Sync this project with the latest oc-rpi blueprint improvements
---
# Update Project from oc-rpi Blueprint

You are syncing this project with the latest oc-rpi blueprint.
The blueprint lives at `$ARGUMENTS`.

This command works for both interactive use (`/update`) and headless scheduled agents.

## Prerequisites

Before starting, verify this project was bootstrapped or adopted from oc-rpi:

- If `.opencode/commands/` exists with RPI commands (research, plan, implement, validate) → proceed.
- If `AGENTS.md` exists with "RPI Workflow" section → proceed.
- If neither exists → this project hasn't been set up with oc-rpi.
  Tell the user to run `/adopt` first and stop.

## Phase 1: Check for Updates

1. Pull the latest oc-rpi: `git -C <oc-rpi-path> pull --rebase`
2. Check if `.opencode/oc-rpi-sync.json` exists in THIS project.
   - If YES: read it and note the `lastSyncCommit` hash.
   - If NO: this is the first sync. Treat everything as new.
3. If `lastSyncCommit` exists:
   - Run `git -C <oc-rpi-path> log --oneline <lastSyncCommit>..HEAD` to see what changed.
   - Run `git -C <oc-rpi-path> diff --name-only <lastSyncCommit>..HEAD` to get changed files.
   - If nothing changed, report "Already up to date" and stop.

## Phase 2: Internalize New Knowledge

Read these files from oc-rpi to internalize the latest rules and patterns:

1. `patterns/quick-reference.md` — All operational rules.
2. `patterns/agent-errors.md` — All known error patterns.
3. `methodology/README.md` — Methodology overview.

On incremental syncs (lastSyncCommit exists), prioritize reading files that appear
in the git diff. You can skip unchanged methodology files.

## Phase 3: Update Command Files

1. Compare each file in oc-rpi `oc-rpi/templates/commands/` against this project's
   `.opencode/commands/`:
   - **Skip** `bootstrap.md` and `adopt.md` — these are blueprint-level commands,
     not project-level.
   - For each remaining command (research, plan, implement, validate, describe-pr,
     pre-launch, update):
     - If it exists in both locations and the oc-rpi version is different → replace
       the project version.
     - If it exists in oc-rpi but not in this project → add it.
     - If it exists only in this project → leave it (project-specific command).
   - The update command itself (`update.md`) IS replaced — this command is self-updating.

## Phase 4: Update AGENTS.md

1. Read this project's `AGENTS.md` fully.
2. Read oc-rpi's `oc-rpi/templates/AGENTS.md.template`.
3. Identify **blueprint-managed sections** by their headers. These sections come from
   the template and should be kept in sync:
   - `## RPI Workflow` (and all `###` subsections under it)
   - `## Agent Operational Rules` (and all `###` subsections under it)
   - `## Push Accountability`
   - `## TDD Protocol`
   - `## Agent Autonomy`
   - `## Memory Management`
4. For each blueprint-managed section:
   - If the project's version differs from the template → update to match.
   - If the project has added project-specific content *within* a blueprint section,
     preserve it — only update the parts that came from the template.
   - If a section doesn't exist in the project → add it from the template.
5. **Do NOT touch** project-specific sections: Project name, One-liner, Stack,
   Key Commands, Git Workflow, Deployment, Commit Messages, or any custom section.

## Phase 5: Update opencode.json

1. Read this project's `opencode.json`.
2. Read oc-rpi's `oc-rpi/templates/opencode.json.template`.
3. Add any new keys present in the template that are missing in the project.
4. **Never remove or change** existing project settings.
5. If `opencode.json` doesn't exist in the project → skip.

## Phase 6: Update Instruction Files

1. Compare each file in oc-rpi `oc-rpi/templates/instructions/` against this project's
   instruction files (as listed in `opencode.json` `instructions` glob):
   - For each template instruction file, check if the corresponding project file exists.
   - If it exists and differs → replace it.
   - If it doesn't exist → skip (adding is `/adopt`'s job).
   - Never touch project-specific instruction files not in the template.

## Phase 7: Write Sync Metadata

1. Get the current HEAD commit hash of oc-rpi: `git -C <oc-rpi-path> rev-parse HEAD`
2. Get the current version tag: `git -C <oc-rpi-path> describe --tags --abbrev=0 2>/dev/null`
3. Write/update `.opencode/oc-rpi-sync.json`:

```json
{
  "lastSyncCommit": "<commit-hash>",
  "lastSyncDate": "YYYY-MM-DD",
  "blueprintVersion": "<version-tag>"
}
```

## Phase 8: Report and Commit

1. If any project files were changed (commands, AGENTS.md, instructions, opencode.json):
   - Stage only the changed files (not unrelated changes).
   - Commit with: `chore: sync with oc-rpi blueprint <version-tag>`
   - Always update the sync metadata even if no other files changed.
2. Present a summary:
   - oc-rpi version synced to (tag + commit hash)
   - Commands updated/added (list them)
   - AGENTS.md sections updated/added (list them)
   - Instructions updated (list them)
   - opencode.json changes (list them)
   - Notable new content: new error patterns, new rules, methodology changes
   - "Already up to date" if nothing changed

## Rules

- **Never delete project content.** Only add or update blueprint-managed sections.
- **Preserve project identity.** Stack, deployment, key commands, commit conventions
  are the project's own.
- **Be idempotent.** Running twice with no oc-rpi changes should produce zero file changes.
- **Commit atomically.** All sync changes go in one commit with the sync metadata.
- **If unsure, skip and report.** When a section has been heavily customized beyond the
  template, leave it alone and note it in the report as "skipped — heavily customized."
- **No interactive prompts.** This command must work headlessly for scheduled agents.
  Don't ask for confirmation — just apply safe updates and report what you did.
