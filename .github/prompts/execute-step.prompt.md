---
description: "Execute instructions from the current GitHub Issue step"
mode: agent
agent: tdd-developer
tools:
  - search
  - read
  - edit
  - execute
  - web
  - todo
---

# Execute Step

You are running in **tdd-developer** mode. Follow all TDD principles and testing constraints in `.github/copilot-instructions.md`.

## Instructions

1. **Resolve the exercise issue number**
   - If `issue-number` was provided as input, use it directly.
   - Otherwise find it:
     ```bash
     gh issue list --state open
     ```
     Identify the issue with **"Exercise:"** in the title and note its number.

2. **Fetch the issue with all comments**
   ```bash
   gh issue view <issue-number> --comments
   ```

3. **Identify the latest step** — find the most recent `# Step X-Y:` heading in the comments.

4. **Execute each `:keyboard: Activity:` section** in order:
   - Read each activity fully before starting it.
   - Implement required changes following TDD principles from project instructions.
   - Run tests after each implementation change and surface failures immediately.
   - Respect **testing scope constraints**: NO Playwright, Cypress, Selenium, or any browser automation.

5. **Do NOT commit or push** — that is handled by `/commit-and-push`.

6. **After all activities are complete**:
   - Summarize what was implemented.
   - Remind the user: `Run /validate-step <step-number> to check success criteria.`
   - Remind the user: `Run /commit-and-push when ready to push.`
