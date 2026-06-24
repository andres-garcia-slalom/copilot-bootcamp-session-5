# AI Working Memory System

This directory provides a **working memory system** that helps AI assistants and developers track discoveries, patterns, and decisions across development sessions.

---

## Purpose

AI assistants have no persistent memory between conversations. This memory system solves that by storing:

- **Patterns** discovered during development (so they aren't re-discovered each session)
- **Decisions** made and the reasoning behind them
- **Lessons learned** from debugging, refactoring, and TDD cycles
- **Active session notes** for in-progress work

By reading these files at the start of a task, the AI can provide context-aware suggestions that reflect the actual state and history of the project.

---

## Two Types of Memory

| Type | Location | Purpose | Committed? |
|------|----------|---------|------------|
| **Persistent Memory** | `.github/copilot-instructions.md` | Foundational principles, workflows, and constraints that rarely change | ✅ Yes |
| **Working Memory** | `.github/memory/` | Discoveries, patterns, and session notes that evolve with the project | ✅ Most files |
| **Ephemeral Memory** | `.github/memory/scratch/` | Active in-progress notes for the current session only | ❌ No (gitignored) |

---

## Directory Structure

```
.github/memory/
├── README.md                  # This file — explains the memory system
├── session-notes.md           # Historical summaries of completed sessions (committed)
├── patterns-discovered.md     # Accumulated code patterns and learnings (committed)
└── scratch/
    ├── .gitignore             # Ignores all files in this directory
    └── working-notes.md       # Active session notes (NOT committed)
```

### `session-notes.md` — Historical Session Summaries

- **What it is**: A chronological log of completed development sessions.
- **When to write**: At the **end** of a session, after committing your work.
- **What to include**: What was accomplished, key findings, decisions made, and outcomes.
- **Committed to git**: Yes — this is a permanent historical record.
- **How AI uses it**: Reviews past sessions to understand what has already been tried, decided, or fixed.

### `patterns-discovered.md` — Accumulated Code Patterns

- **What it is**: A catalog of recurring patterns, solutions, and anti-patterns found in this codebase.
- **When to write**: When you solve a non-obvious problem or recognize a pattern worth preserving.
- **What to include**: Pattern name, context, problem, solution, code example, and related files.
- **Committed to git**: Yes — grows over time as the team accumulates knowledge.
- **How AI uses it**: Applies known-good patterns instead of re-deriving solutions from scratch.

### `scratch/working-notes.md` — Active Session Notes

- **What it is**: A scratchpad for the **current active session** only.
- **When to write**: Continuously during a session — update as you discover things.
- **What to include**: Current task, approach, key findings, decisions, blockers, and next steps.
- **Committed to git**: ❌ **Never** — the `scratch/` directory is gitignored.
- **How AI uses it**: Maintains context within a single session without polluting git history.
- **End of session**: Summarize key findings into `session-notes.md` before closing.

---

## When to Use Each File

### During TDD Workflow

| Stage | Action |
|-------|--------|
| Before starting | Read `session-notes.md` and `patterns-discovered.md` for relevant context |
| Writing tests | Note edge cases and assumptions in `scratch/working-notes.md` |
| RED → GREEN | Document what made the test pass in `scratch/working-notes.md` |
| Refactor | Note any patterns emerging in `scratch/working-notes.md` |
| Session complete | Summarize findings into `session-notes.md`; extract patterns to `patterns-discovered.md` |

### During Linting / Code Quality Workflow

| Stage | Action |
|-------|--------|
| Before starting | Check `patterns-discovered.md` for known lint patterns or fixes |
| Categorizing issues | Log issue categories in `scratch/working-notes.md` |
| Fixing systematically | Note which fixes work and which cause side effects |
| Session complete | Document any recurring lint patterns in `patterns-discovered.md` |

### During Debugging / Integration Workflow

| Stage | Action |
|-------|--------|
| Identifying issue | Write hypothesis in `scratch/working-notes.md` |
| Debugging | Update findings as you investigate |
| Root cause found | Document the cause, fix, and rationale |
| Session complete | Add to `session-notes.md`; if it's a recurring pattern, add to `patterns-discovered.md` |

---

## How AI Reads and Applies These Patterns

When you start a new task, the AI should:

1. **Read `copilot-instructions.md`** — understand project principles and constraints.
2. **Read `patterns-discovered.md`** — apply known-good patterns to the current problem.
3. **Read `session-notes.md`** — understand what has been done before and avoid repeating mistakes.
4. **Read `scratch/working-notes.md`** (if it exists) — pick up where the last session left off.

This allows the AI to give suggestions that are **grounded in the actual history of this project** rather than generic best practices.

---

## Summary: Ephemeral vs. Persistent

```
scratch/working-notes.md  →  (end of session)  →  session-notes.md
                                                 →  patterns-discovered.md
```

- **Active work** lives in `scratch/` (ephemeral, never committed).
- **Completed session summaries** live in `session-notes.md` (committed, historical).
- **Reusable patterns** live in `patterns-discovered.md` (committed, growing catalog).
- **Foundational rules** live in `copilot-instructions.md` (committed, stable).
