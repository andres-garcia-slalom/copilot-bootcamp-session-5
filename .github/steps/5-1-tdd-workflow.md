# Step 5-1: Test-Driven Development Workflow

## Goal

Fix failing backend tests iteratively using Test-Driven Development (TDD) with your `tdd-developer` agent. You'll work through the Red-Green-Refactor cycle: run tests (Red), implement code (Green), improve quality (Refactor), and repeat.

## Background

The backend has **comprehensive tests that currently fail** because the implementation is incomplete or buggy. Your job is to make these tests pass one by one using Copilot as your pair programming partner.

> **Continuing from Step 5-0**: You already have your Codespace running and you're on the `feature/agentic-workflow` branch. Let's put your workflow automation system to work!

> ⚠️ **Branch Reminder**: You should be on the `feature/agentic-workflow` branch throughout Steps 5-1 to 5-3. All commits go to this branch.

## Instructions

> 🔄 **Fresh Start**: Before beginning, **start a new chat** (click the **+** button in Copilot Chat panel). This gives you a clean context for this step while still leveraging your project instructions and agents.

> ✅ **Prerequisites Validated**: If you're seeing this step, the GitHub Actions workflow has verified that Step 5-0 is complete! All required files (agents, prompts, instructions) are in place and you're on the correct branch.

### :keyboard: Activity: Fix All Backend Tests

> 💡 **How `/execute-step` works**: When you run `/execute-step`, it reads the instructions from this GitHub Issue comment (the text you're reading right now), auto-switches to `tdd-developer` mode, and autonomously executes the tasks. You're not giving it instructions - **the GitHub Issue is the instruction set!**

Use `/execute-step` to autonomously fix the failing backend tests:

1. **Run** `/execute-step 5-1` in Copilot Chat

2. **Watch the AI work!** It will:
   - Auto-switch to `tdd-developer` agent
   - Navigate to `packages/backend`
   - Run tests to identify failures
   - Fix each endpoint in `src/app.js` (GET, POST, PUT, PATCH, DELETE)
   - Run tests after each fix to verify
   - Continue until all tests pass

   **IMPORTANT - Scope Boundary**:
   This step focuses ONLY on making tests pass. The AI should:
   - ✅ Fix code to make failing tests pass
   - ✅ Verify tests pass after each fix
   - ❌ DO NOT fix ESLint warnings or errors (those are for Step 5-2)
   - ❌ DO NOT remove console.log statements
   - ❌ DO NOT fix unused variables unless they break tests

   Code quality issues will be addressed systematically in Step 5-2!

3. **Review the changes** it made

> 💡 **What's happening?** The AI uses TDD Red-Green-Refactor cycles: run tests (Red) → fix code (Green) → verify (Refactor). As it works, it automatically documents patterns to `.github/memory/patterns-discovered.md` - no separate step needed!

### :keyboard: Activity: Validate and Progress

Now verify your work and push to trigger the next step:

1. **Validate completion** using `/validate-step`
   - Run: `/validate-step 5-1` in Copilot Chat
   - Checks that all tests pass
   - Verifies changes are ready to commit

2. **Commit and push** using `/commit-and-push`
   - Run: `/commit-and-push` in Copilot Chat
   - Provide branch: `feature/agentic-workflow`
   - AI analyzes changes and creates commit message
   - Pushes to trigger Step 5-2 workflow automatically

## Success Criteria

To complete this exercise successfully:

- ✅ All tests in `packages/backend/__tests__/app.test.js` pass
- ✅ Changes are committed and pushed to `feature/agentic-workflow` using `/commit-and-push`

## Key Workflow Patterns

✨ **Test-Driven Development**: Tests define requirements, implementation makes them pass

✨ **Iterative Development**: Small, focused changes with continuous validation

✨ **Red-Green-Refactor**: Run tests → Fix code → Improve quality → Repeat

✨ **AI-Assisted Analysis**: Using `tdd-developer` agent to understand test expectations and implement solutions

✨ **Workflow Automation**: Using `/validate-step` and `/commit-and-push` prompts to progress through steps

---

Wait for the automation to post Step 5-2 instructions below!
