---
description: Cleanly remove all oc-rpi artifacts from this project
---
# Detach Project from oc-rpi Blueprint

You are cleanly removing oc-rpi artifacts from this project.
The blueprint lives at `$ARGUMENTS`.

This command removes all blueprint-managed files and configuration while preserving
project-specific content and user work products.

## Phase 1: Verify Adoption

1. Check for `.opencode/oc-rpi-sync.json` or RPI commands in `.opencode/commands/`
   (research.md, plan.md, implement.md, validate.md).
2. If neither exists: report "This project doesn't appear to use oc-rpi.
   Nothing to detach." and **stop**.
3. If sync metadata exists, read it and report the current blueprint version and
   last sync date.

## Phase 2: Inventory Artifacts

Scan this project for all oc-rpi artifacts. Categorize each into one of four tiers.

### Tier 1: Blueprint scaffolding (always remove)

Check for these files and note which exist:

**Command files** (`.opencode/commands/`):

- `research.md`
- `plan.md`
- `implement.md`
- `validate.md`
- `describe-pr.md`
- `pre-launch.md`
- `quality-review.md`
- `status.md`
- `fix-ci.md`
- `update.md`

**Agent files** (`.opencode/agents/`):

- `rpi-research.md`
- `rpi-planner.md`
- `rpi-auditor.md`

**Instruction files** (domain instructions — paths as listed in `opencode.json`):

- `tests.md` (or equivalent)
- `api.md` (or equivalent)
- `migrations.md` (or equivalent)

**Other files:**

- `.opencode/oc-rpi-sync.json` (sync state tracker)
- `scripts/agents/oc-rpi-update.sh` (nightly sync agent, if exists)

For each command file that exists, diff it against the template to detect customization.
Mark as "unmodified" or "customized."

### Tier 2: Blueprint-managed AGENTS.md sections

Read the project's AGENTS.md and identify these blueprint-managed sections
by their `##` or `###` headers:

- `## RPI Workflow` (including all `###` subsections under it)
- `## Agent Operational Rules` (including all `###` subsections under it)
- `## Push Accountability`
- `## TDD Protocol`
- `## Agent Autonomy`
- `## Memory Management`
- `## Project File Locations`
- `### CRITICAL: Run verification commands before committing`

Note which sections exist. Do NOT touch any other sections.

### Tier 3: Configuration entries

Read `opencode.json` and identify oc-rpi-managed entries:

- `instructions` array entries added by oc-rpi
- `$schema` field if added by oc-rpi

Note which exist. Leave all other `opencode.json` settings untouched.

Check for a systemd/launchd service for the oc-rpi update agent.

### Tier 4: User work products

Check for and count files in:

- `docs/research/` — research documents
- `docs/plans/` — implementation plans
- `docs/decisions/` — architecture decision records
- `docs/agents/` — agent reports and project memory
- `logs/` — agent logs

These are the user's intellectual work. Default is to **keep** them.

## Phase 3: Preview Report

Present the full inventory to the user:

```text
== Detach Preview ==

Blueprint version: <version> (synced <date>)

WILL REMOVE (blueprint scaffolding):
  [list each Tier 1 file that exists, with "unmodified" or "customized" tag]

WILL EDIT (AGENTS.md):
  Remove sections: [list each Tier 2 section found]
  Keep sections: [list remaining sections]

WILL CLEAN (opencode.json):
  Remove: [list Tier 3 entries to remove]
  Keep: [list what stays]

WILL KEEP (your work):
  [list Tier 4 directories with file counts, or "none found"]

CUSTOMIZED FILES (review recommended):
  [for each customized file, explain what custom content will be lost]
```

If no customized files exist, omit the CUSTOMIZED FILES section.

## Phase 4: Confirm and Execute

Ask the user three questions:

1. **"Proceed with detach?"** — required. If no, stop.
2. **"Remove research docs and plans too?"** — default: no.
   Only remove Tier 4 if user explicitly says yes.
3. **"Remove oc-rpi entries from opencode.json?"** — default: yes.
   If user wants to keep them, skip Tier 3.

For any customized files, ask: **"Keep [filename] as a custom command?"**
If yes, skip that file.

Then execute in order:

1. Delete Tier 1 files (skip any the user chose to keep).
2. Edit AGENTS.md to remove Tier 2 sections.
3. Clean Tier 3 configuration in `opencode.json`.
4. Handle Tier 4 per user decision (keep by default).
5. Clean up empty directories: remove `.opencode/commands/` if empty,
   `.opencode/agents/` if empty. Do NOT remove `.opencode/` itself.
6. If a scheduled agent service was found: unload it, then delete the file. Ask before this step.

## Phase 5: Commit

Stage all changes and create a single atomic commit:

```text
chore: detach from oc-rpi blueprint

Removed RPI methodology commands, agents, instructions, AGENTS.md
blueprint sections, and sync metadata. Project-specific configuration
preserved.
```

## Phase 6: Report

Present the final summary:

```text
== Detach Complete ==

Removed: [N] files, [N] AGENTS.md sections, [N] opencode.json entries
Kept: [list preserved Tier 4 directories with counts, or "no work products found"]
Commit: [hash]

This project no longer syncs with oc-rpi. The command files, agents,
instructions, and methodology sections have been removed. Your
project configuration and work products are untouched.

To re-adopt later: run /adopt
```

## Rules for This Process

- **Preview before delete.** Never remove anything without showing the user what will
  happen first (Phase 3).
- **Preserve project identity.** Only remove blueprint-managed content.
  Everything project-specific stays.
- **Keep user work products by default.** Research docs, plans, and decisions are the
  user's work. Only remove if explicitly asked.
- **Flag customizations.** If a command or agent has been modified from the template,
  warn the user before deleting it.
- **One atomic commit.** All removals go in a single commit.
- **Idempotent.** Running on a project without oc-rpi artifacts reports "nothing to
  detach" and stops.
