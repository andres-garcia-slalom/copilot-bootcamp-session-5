# Session Notes

Historical summaries of completed development sessions. Add a new entry at the top after each session.

---

## Template

```
## Session: <descriptive name>
**Date**: YYYY-MM-DD
**Branch**: feature/<branch-name>

### What Was Accomplished
- <bullet points of completed work>

### Key Findings
- <non-obvious discoveries, root causes, or surprises>

### Decisions Made
- <architectural or implementation decisions and their rationale>

### Outcomes
- Tests passing: yes/no
- Lint errors: resolved/outstanding
- PR opened: yes/no — #<number>
```

---

## Session: Memory System Setup
**Date**: 2026-06-24
**Branch**: main

### What Was Accomplished
- Created `.github/copilot-instructions.md` with project context, testing scope, workflow patterns, agent usage, and git workflow guidelines
- Created `.github/memory/` working memory system with README, session-notes, patterns-discovered, and scratch directory
- Established the two-tier memory model: ephemeral (`scratch/`) vs. committed (`session-notes.md`, `patterns-discovered.md`)

### Key Findings
- The `scratch/` directory is gitignored to keep active session notes out of git history
- Copilot instructions benefit from explicit constraints (e.g., "do NOT suggest Playwright") to prevent unwanted suggestions
- Linking to `docs/` files in copilot-instructions helps AI navigate project documentation

### Decisions Made
- Use `.github/memory/` as the working memory root (co-located with copilot-instructions for discoverability)
- Keep `scratch/working-notes.md` ephemeral — summarize at end of session instead of committing raw notes
- Document patterns in a separate file (`patterns-discovered.md`) rather than inline in session notes for easier lookup

### Outcomes
- Tests passing: N/A (infrastructure only)
- Lint errors: N/A
- PR opened: no — committed directly to main
