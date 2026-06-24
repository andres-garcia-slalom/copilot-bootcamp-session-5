---
description: "Analyze changes, generate commit message, and push to feature branch"
tools:
  - read
  - execute
  - todo
---

# Commit and Push

This prompt works with any active agent. It handles the complete Git workflow for committing and pushing changes.

## Instructions

1. **Require branch name** — if `branch-name` was not provided as input, ask:
   > "What branch should I push to? (e.g. `feature/agentic-workflow`)"
   Do NOT proceed until a branch name is confirmed.

2. **Review current changes**
   ```bash
   git diff
   git status
   ```

3. **Generate a conventional commit message** (from the Git Workflow section of `.github/copilot-instructions.md`):
   - `feat:` — new feature or behavior
   - `fix:` — bug fix
   - `chore:` — tooling, config, non-functional changes
   - `docs:` — documentation only
   - `refactor:` — restructure without behavior change
   - `test:` — test additions or fixes

4. **Create or switch to the specified branch**
   ```bash
   # Branch does not exist yet:
   git checkout -b <branch-name>

   # Branch already exists:
   git checkout <branch-name>
   ```

5. **Stage all changes**
   ```bash
   git add .
   ```

6. **Commit**
   ```bash
   git commit -m "<generated-message>"
   ```

7. **Push**
   ```bash
   git push origin <branch-name>
   ```

8. **Confirm** — report the branch pushed to and the commit message used.

> ⚠️ ONLY push to the user-provided branch. Never push to `main` or any other branch.
