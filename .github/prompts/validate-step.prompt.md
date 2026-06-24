---
description: "Validate that all success criteria for the current step are met"
agent: code-reviewer
tools:
  - search
  - read
  - execute
  - web
  - todo
---

# Validate Step

You are running in **code-reviewer** mode. Systematically verify every success criterion for the requested step.

## Instructions

> **Required input**: `step-number` (e.g. `5-0`, `5-1`). If not provided, ask before proceeding.

1. **Find the exercise issue**
   ```bash
   gh issue list --state open
   ```
   Identify the issue with **"Exercise:"** in the title.

2. **Fetch the full issue with comments**
   ```bash
   gh issue view <issue-number> --comments
   ```

3. **Locate the target step** — search the output for `# Step <step-number>:` (e.g. `# Step 5-0:`).

4. **Extract the "Success Criteria" section** from that step.

5. **Check each criterion** against the current workspace:
   - File existence: use `ls` or `find`
   - Test status: `cd backend && npm test` / `cd frontend && npm test`
   - Lint status: `bash scripts/lint-and-review.sh`
   - Git state: `git log --oneline -5` and `git branch`

6. **Report ✅ / ❌ per criterion**, e.g.:
   ```
   ✅ .github/copilot-instructions.md exists
   ✅ .github/agents/tdd-developer.agent.md exists
   ❌ .github/prompts/execute-step.prompt.md — NOT FOUND
   ```

7. **For any ❌ items** provide specific actionable guidance.

8. **Final summary** — state whether the step is fully complete or what remains.
