# copilot-rpi — GitHub Copilot Reference & Project Intelligence

<!-- AGENTS.md — cross-tool instruction file for GitHub Copilot, Claude Code, Cursor, and Gemini CLI.
Read by every agent every session. Keep it lean.
Test each line: "Would removing this cause the agent to make a mistake?" If not, cut it. -->

## What This Is

Blueprint repository for projects that use GitHub Copilot. Contains:

- The RPI (Research-Plan-Implement) methodology adapted for GitHub Copilot
- A catalog of known agent errors with proven solutions
- Operational rules that prevent recurring mistakes
- Templates for AGENTS.md, prompt files, path-specific instructions, and project setup

## Stack

Pure Markdown — no code, no build toolchain, no package manager.
The only automated check is `markdownlint` via CI.

## Build / Lint / Test Commands

```bash
# Lint all Markdown files — mirrors CI exactly. Run before every commit.
npx markdownlint-cli2 "**/*.md" "!node_modules/**"

# Lint a single file
npx markdownlint-cli2 "path/to/file.md"
```

There is no pre-commit hook. CI (`markdown-lint.yml`) is the enforcer — failures are always lint errors.
After every push: `gh run list --branch main --limit 1`. If CI fails: `gh run view <id> --log-failed`, fix, re-push.

## Markdown Style Rules

These rules are active (violations will fail CI):

- ATX-style headings (`#`, `##`, `###`) — never Setext style
- Fenced code blocks must have a language identifier
- No trailing spaces; blank line required before and after fenced blocks
- No bare URLs — wrap in angle brackets or use `[text](url)` syntax

These rules are disabled in `.markdownlint.json` and will NOT fail CI:

| Rule | What it checks | Why disabled |
|------|---------------|--------------|
| MD013 | Line length | Long tables and URLs are unavoidable |
| MD024 | Duplicate headings | Same heading text in different sections is intentional |
| MD026 | Trailing punctuation in headings | Intentional use of `—` dashes |
| MD036 | Emphasis used as heading | Used in templates |
| MD041 | First line must be H1 | Template files don't start with H1 |
| MD060 | Fenced code block style | Consistent backtick style already enforced manually |

**Writing style:**

- One sentence per line where practical (aids diffs)
- Lines under 120 characters where possible
- Plain, direct language — no filler words
- Keep all content generic — no project-specific references anywhere in this repo

## Git Workflow

**`main` is the only branch.** All changes go directly to `main`.

**Push sequence** (Error #19 — never pull before committing):

```bash
git add <files> && git commit -m "msg" && git pull --rebase && git push
```

**Commit types** (conventional commits):

```text
docs: description
feat: description
fix: description
chore: description
pattern: add Error #N — title    # use for new error catalog entries
```

**Before committing:** run markdownlint, verify current branch (`git branch --show-current`).
**After any structural change** (new files, renamed sections): check cross-references for breakage.

## How This Repo Is Used

When starting a new project: "Go check my copilot-rpi repository and set up the environment to follow all the best practices."

Agent should:

1. Read `patterns/quick-reference.md` — internalize all operational rules
2. Read `patterns/agent-errors.md` — know every known error pattern
3. Read `methodology/README.md` — understand the RPI approach
4. Use `templates/setup-checklist.md` to set up the new project
5. Adapt `templates/AGENTS.md.template` for the new project's AGENTS.md
6. Copy `templates/prompts/` → `.github/prompts/`, `templates/github/instructions/` → `.github/instructions/`, `templates/github/chatmodes/` → `.github/chatmodes/`

## RPI Workflow

Significant changes go through:

1. `/research` — Understand what exists and where it lives
2. `/plan` — Draft the change with a clear rationale
3. `/implement` — Make the change; verify with markdownlint
4. `/validate` — Confirm CI passes and content is consistent

Minor fixes (typos, formatting, broken links) can skip planning.
Each RPI phase should be its own conversation — start a new Chat window between unrelated tasks.

## Agent Operational Rules

**Git:**

- Commit or stash BEFORE `git pull --rebase` — requires a clean working tree
- `git worktree remove --force`; `git branch -D` (uppercase) for worktree branches
- Remove worktrees BEFORE merging PRs with `--delete-branch`
- Don't fabricate filesystem paths — discover with `ls`

**GitHub CLI:**

- Don't guess `gh --json` field names — run `gh <cmd> --json 2>&1 | head -5` first
- `review: fail` means "needs approval", NOT a CI failure — filter it out
- Check for existing PRs before `gh pr create`: `gh pr list --head <branch> --base <base>`

**Copilot-specific:**

- Always include YAML frontmatter in `.prompt.md` files — without it the file won't appear in the `/` menu
- Use `${input:variableName}` for prompt parameters, NOT `$ARGUMENTS` (Claude Code syntax)
- Path-specific instruction files need `applyTo` in frontmatter — without it they are never loaded
- Chat mode files must be in `.github/chatmodes/` — not `.github/prompts/` or project root
- Authenticate `copilot` CLI before using in cron/launchd — run `copilot auth` interactively first

**Autonomy:** Exhaust CLI tools (`gh`, `git`) and terminal commands before asking the user to do anything manually.
Commit and push when changes are complete — don't wait to be asked unless the change is risky or destructive.

## Contributing

**New error pattern:**

1. Add full entry to `patterns/agent-errors.md` (format: Error #N — Title, Symptom, Root Cause, Correct Approach, What NOT to Do)
2. Add one-liner to `patterns/quick-reference.md` under the appropriate section
3. Commit with `pattern: add Error #N — title`

**New methodology content:** add to appropriate file under `methodology/`; update `methodology/README.md` reading order if adding a new file.

**Error screenshot workflow:** user drops screenshots into `~/Desktop/agent-errors/`. Run `/process-errors`.
Full flow: read images → cross-reference `patterns/agent-errors.md` → skip duplicates → add new entries → add one-liners → commit and push → delete processed images.

## Project File Locations

Go directly to these paths — never search the codebase for them.

| Topic | Path |
|-------|------|
| Operational rules | `patterns/quick-reference.md` |
| Error catalog | `patterns/agent-errors.md` |
| Methodology overview | `methodology/README.md` |
| New project setup | `templates/setup-checklist.md` |
| AGENTS.md template | `templates/AGENTS.md.template` |
| Prompt templates | `templates/prompts/` (17 files) |
| Instruction templates | `templates/github/instructions/` |
| Chat mode templates | `templates/github/chatmodes/` |
| This repo's prompts | `.github/prompts/` |
| Copilot instructions | `.github/copilot-instructions.md` |

## Relationship to cc-rpi

Copilot counterpart to `cc-rpi` (Claude Code Reference & Project Intelligence).
~60% shared content; differs in tool-specific mechanics.
When updating shared methodology content, check whether `cc-rpi` needs a parallel update.
