---
name: process-errors
description: Process agent error screenshots — read images, cross-reference the error catalog, add new entries, commit and push
---
# Process Agent Error Screenshots

Process agent error screenshots from `~/Desktop/agent-errors/`.
Cross-reference against `patterns/agent-errors.md`, skip duplicates, add new entries,
update the quick-reference one-liners, commit, push, and delete the processed images.

## Steps

1. **Scan for images:**

   ```bash
   ls ~/Desktop/agent-errors/
   ```

   If the directory is empty or doesn't exist, report "No images to process" and stop.

2. **Read all images** — use the Read tool on each image file.
   Extract the error shown: what the agent did wrong, the symptom, and the context.

3. **Read the error catalog** at `patterns/agent-errors.md` to understand
   existing entries and the highest current error number.

4. **For each extracted error:**
   - Search the catalog for a matching pattern (same root cause).
   - If a match exists: skip this image (already catalogued). Note it.
   - If no match: this is a new error. Draft a full entry.

5. **For each new error, create a catalog entry** following the existing format:

   ```markdown
   ## Error #N — [Short Title]

   **Symptom:** [What went wrong — observable behavior]

   **Root Cause:** [Why it happened — the underlying mistake]

   **Correct Approach:**
   [The right way to handle this situation]

   **What NOT to Do:**
   [The specific anti-pattern to avoid]
   ```

6. **Add one-liner to `patterns/quick-reference.md`** under the appropriate section.
   Match the style of existing one-liners — one concise sentence.

7. **Append new entries to `patterns/agent-errors.md`** — do not insert in the middle.
   Keep entries in sequence by number.

8. **Commit and push:**

   ```bash
   git add patterns/agent-errors.md patterns/quick-reference.md
   git commit -m "pattern: add Error #N — [title]"
   git pull --rebase
   git push
   ```

   If multiple errors were added, list all of them in the commit message.

9. **Delete processed images:**

   ```bash
   rm ~/Desktop/agent-errors/<filename>
   ```

   Only delete images that were successfully processed and committed.

10. **Report summary:**
    - Images processed: N
    - New errors added: N (list titles)
    - Duplicates skipped: N (list which existing error they matched)
    - Images deleted: N

## Rules

- Never add a duplicate. Cross-reference thoroughly before adding.
- Never modify existing entries — only append new ones.
- One commit per run, even if multiple errors were added.
- Delete images only after a successful push.
- If the push fails, do not delete images — they need to be reprocessed.
