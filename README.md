# AI Accelerated Engineering Bootcamp - Session 5

> **Empowering teams to leverage AI coding assistants for faster, higher‑quality software delivery—with the right context, workflows, and guardrails.**

## Purpose

This series exists to help teams adopt AI coding assistants thoughtfully and effectively across the entire software lifecycle–from discovery and design to implementation, testing, and delivery. Across sessions, participants develop the mental models (why AI, paradigm shift), the practical skills (context engineering, backlog and architecture creation), and the tool fluency (Copilot modes, MCPs, and comparable assistants) needed to build reliable, human‑in‑the‑loop, repeatable workflows. The goal is to accelerate delivery while improving quality and confidence, culminating in a capstone that demonstrates end‑to‑end, real‑world application.

## Session 5: Agentic Development - Building Workflows

This session focuses on building **iterative AI-assisted workflows** that mirror real-world development patterns:

- **Test-Driven Development (TDD)**: Write tests → Run → Fail → Fix → Iterate
- **Compilation Loops**: Compile → Identify Errors → Fix → Re-compile
- **Implementation Cycles**: Plan → Build → Test → Debug → Repeat

You'll learn to work with AI as a collaborative agent in continuous feedback loops, developing muscle memory for systematic problem-solving with Copilot.

## Quick Start (Skill Lab)

1. Click **Use this template**.
2. Select **Create a new repository**.
3. Once created, open the Actions tab in your new repository - a GitHub Actions workflow labeled "Step 5-0" should start automatically.
4. When the workflow completes, a GitHub Issue will be created in your new repository to guide the next steps of the lab.

That's it. The lab automation (workflow + seeded issue) is the only thing you need to verify to begin.

## Troubleshooting

**If you don't see the "Step 5-0" workflow:**

- Ensure Actions are enabled: Repository Settings > Actions > Allow all actions
- Refresh the Actions tab

**If the workflow fails:**

- Open the workflow run log to check for errors
- Click "Re-run jobs" (top-right) to try again

**If no Issue appears after workflow succeeds:**

- Check the workflow logs for the "Post Issue" step
- Verify you have Issues enabled: Repository Settings > General > Features > Issues

## Next Steps After Automation

Once the Issue appears, follow its guidance to work through the exercise. You'll first create custom Copilot agents (TDD Developer and Code Reviewer), then use them to practice:

- Running tests and fixing failures iteratively with TDD workflows
- Resolving compilation and linting errors systematically
- Building features through planned implementation cycles
- Debugging integration issues with continuous validation

## Tech Stack Snapshot

- Frontend: React
- Backend: Express
- Testing: Jest
- Package management: npm workspaces
- Code quality: ESLint

## License and Conduct

&copy; 2025 Slalom • [Code of Conduct](https://www.contributor-covenant.org/version/2/1/code_of_conduct/code_of_conduct.md) • [MIT License](https://gh.io/mit)

---

> 🎉 Happy hacking – use template, watch the workflow, find the Issue, and practice agentic workflows with Copilot.
