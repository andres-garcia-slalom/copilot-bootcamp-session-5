# Project Overview

## Introduction

This project is a full-stack JavaScript TODO application designed for Session 5 of the AI Accelerated Engineering Bootcamp. The focus of this session is **Agentic Development** - learning to work with AI coding assistants through iterative, feedback-driven workflows.

## Architecture

The project follows a monorepo architecture with:

- `packages/frontend/`: React-based web application
- `packages/backend/`: Express.js API server with in-memory storage

## Technology Stack

### Frontend

- React 18
- Material-UI (MUI) v5 - Modern component library
- @mui/icons-material - Icon components
- @emotion/react & @emotion/styled - CSS-in-JS styling (required by MUI)
- React Query (TanStack Query) v5 - Data fetching and state management
- React Testing Library - Component testing
- ESLint for code quality

### Backend

- Node.js
- Express.js
- Jest and Supertest for testing
- ESLint for code quality

### Development Tools

- npm workspaces for monorepo management
- GitHub Actions for automated validation
- GitHub Codespaces for consistent development environment

## Intentional Issues for Learning

This codebase contains **intentional bugs and incomplete implementations** designed to teach agentic development workflows:

### Backend Issues

1. **Initialization bug**: `todos` array not properly initialized
2. **Missing ID counter**: No mechanism for generating unique IDs
3. **Incomplete endpoints**: POST, PUT, DELETE endpoints not implemented
4. **Toggle bug**: PATCH endpoint always sets completed to `true` instead of toggling
5. **Missing error handling**: No centralized error handling middleware
6. **ESLint violations** (marked with comments): Unused variables and console.log statements intentionally left for Step 5-2 linting exercise

### Frontend Issues

1. **Hardcoded API URL**: Should use relative URL instead of hardcoded localhost
2. **Missing error handling**: No error handling in React Query hooks
3. **Delete mutation incomplete**: deleteTodoMutation logs but doesn't call API
4. **Edit not implemented**: Edit button exists but functionality missing
5. **Stats always show 0**: Hardcoded instead of calculating from todos array
6. **No empty state**: Doesn't show message when todos.length === 0
7. **Missing validation**: React Query mutations need better error handling

### Test Issues

- Backend has comprehensive tests that **will initially fail**
- Students must fix code to make tests pass
- Frontend has minimal tests that need expansion

## Learning Workflow Pattern

Throughout this session, you'll practice:

1. **Test-Driven Development (TDD)**

   - Run tests → See failures → Fix code → Rerun tests → Iterate

2. **Compilation/Lint Loops**

   - Run lint → See errors → Fix issues → Re-lint → Iterate

3. **Implementation Cycles**

   - Plan feature → Build incrementally → Test → Debug → Repeat

4. **Integration Validation**
   - Run app → Test manually → Fix bugs → Retest → Iterate

## Getting Started

### Prerequisites

- Node.js (v16 or higher)
- npm (v7 or higher)
- GitHub Copilot access

### Installation

1. Fork this repository
2. Open in GitHub Codespaces (recommended) or clone locally
3. Run `npm install` at the root to install all dependencies
4. Follow the GitHub Issue instructions that appear after forking

### Running the Application

```bash
# Start both frontend and backend
npm run start

# Run tests for all packages
npm test

# Run linting
npm run lint
```

## Development Philosophy

This exercise emphasizes **iterative problem-solving with AI**:

- Don't try to fix everything at once
- Use tests as your guide
- Let errors inform your next step
- Build incrementally and validate continuously
- Learn to read and interpret test failures
- Practice clear communication with AI assistants

## Success Criteria

You've successfully completed this session when:

- ✅ All backend tests pass
- ✅ No ESLint errors in backend or frontend
- ✅ All CRUD operations work in the UI
- ✅ Application handles errors gracefully
- ✅ Code follows best practices and is well-documented

## License

MIT License - See LICENSE file for details
