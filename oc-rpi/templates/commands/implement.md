---
description: Execute an implementation plan phase by phase with verification gates
---
Implement the plan at: $ARGUMENTS

Process:

1. Read the plan completely. Check for existing checkmarks.
2. Use the explore subagent (`@explore`) to gather relevant context.
3. For the CURRENT phase only:
   a. Implement the changes as specified.
   b. Self-review: re-read your changes critically for plan compliance.
   c. If issues found, fix them before proceeding.
   d. Run ALL automated verification commands via bash.
   e. Update checkboxes in the plan file.
   f. Recommend running `/quality-review` for a second-pass review (code reuse, quality,
      efficiency). This is a separate concern from plan compliance — self-review checks
      "did I follow the plan?" while quality review checks "is the code good?"
4. STOP. Report results and wait for human confirmation.
5. Do NOT proceed to the next phase without confirmation.
6. If the plan marks phases as `[batch-eligible]`, inform the user they can run those
   phases in parallel via separate `opencode run` processes.

If plan doesn't match reality:

- STOP and present: Expected vs Found vs Why it matters.
- Ask how to proceed.
