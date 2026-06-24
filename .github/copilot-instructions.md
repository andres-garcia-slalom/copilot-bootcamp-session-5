# Copilot Instructions

## Project Context

- Full-stack TODO application with React frontend and Express backend
- Focus on iterative, feedback-driven development
- Current phase: Backend stabilization and frontend feature completion

## Documentation References

Link to existing documentation (helps AI navigate the project):

- [docs/project-overview.md](../docs/project-overview.md) - Architecture, tech stack, and structure
- [docs/testing-guidelines.md](../docs/testing-guidelines.md) - Test patterns and standards
- [docs/workflow-patterns.md](../docs/workflow-patterns.md) - Development workflow guidance

## Development Principles

- **Test-Driven Development**: Red-Green-Refactor cycle
- **Incremental Changes**: Small, testable modifications
- **Systematic Debugging**: Use test failures as guides
- **Validation Before Commit**: All tests pass, no lint errors

## Testing Scope

This project uses unit tests and integration tests ONLY:

- **Backend**: Jest + Supertest for API testing
- **Frontend**: React Testing Library for component unit/integration tests
- **Manual browser testing** for full UI verification
- ❌ DO NOT suggest or implement e2e test frameworks (Playwright, Cypress, Selenium)
- ❌ DO NOT suggest browser automation tools
- **Reason**: Keep lab focused on unit/integration tests without e2e complexity

### Testing Approach by Context

- **Backend API changes**: Write Jest tests FIRST, then implement (RED-GREEN-REFACTOR)
- **Frontend component features**: Write React Testing Library tests FIRST for component behavior, then implement (RED-GREEN-REFACTOR). Follow with manual browser testing for full UI flows.
- This is true TDD: **Test first, then code to pass the test**

## Workflow Patterns

1. **TDD Workflow**: Write/fix tests → Run → Fail → Implement → Pass → Refactor
2. **Code Quality Workflow**: Run lint → Categorize issues → Fix systematically → Re-validate
3. **Integration Workflow**: Identify issue → Debug → Test → Fix → Verify end-to-end

## Agent Usage

Use the appropriate specialized agent for each task type:

- **`tdd-developer`**: For test-related work and Red-Green-Refactor cycles
- **`code-reviewer`**: For addressing lint errors and code quality improvements

## Workflow Utilities

GitHub CLI commands for workflow automation (available to all modes):

```bash
# List open issues
gh issue list --state open

# Get issue details
gh issue view <issue-number>

# Get issue with comments
gh issue view <issue-number> --comments
```

- The main exercise issue will have **"Exercise:"** in the title
- Steps are posted as comments on the main issue
- Use these commands when `/execute-step` or `/validate-step` prompts are invoked

## Git Workflow

- Use **conventional commits**: `feat:`, `fix:`, `chore:`, `docs:`, etc.
- **Feature branches**: `feature/<descriptive-name>`
- Always stage all changes before committing: `git add .`
- Push to the correct branch: `git push origin <branch-name>`
