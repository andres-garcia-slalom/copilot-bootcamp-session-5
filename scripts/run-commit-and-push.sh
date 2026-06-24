#!/usr/bin/env bash
# =============================================================================
# run-commit-and-push.sh
# Companion runner for the /commit-and-push prompt.
# Analyzes git changes, generates a conventional commit message, and pushes
# to the specified branch.
#
# - Silent on success (only prints the final commit/push confirmation).
# - Never stops on error — collects all failures and reports at the end.
# - Filters log to non-success lines only.
# - Prints a consolidated error list at the end.
#
# Usage:
#   bash scripts/run-commit-and-push.sh <branch-name>
# =============================================================================

set -uo pipefail

# ---------------------------------------------------------------------------
# Colors
# ---------------------------------------------------------------------------
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

ERRORS=()

fail() { ERRORS+=("$1"); }

# ---------------------------------------------------------------------------
# Require branch name
# ---------------------------------------------------------------------------
BRANCH="${1:-}"
if [ -z "$BRANCH" ]; then
  fail "Branch name is required. Usage: bash scripts/run-commit-and-push.sh <branch-name>"
fi

# Guard: never push to main
if [ "$BRANCH" = "main" ] || [ "$BRANCH" = "master" ]; then
  fail "Refusing to push to '$BRANCH'. Provide a feature branch name."
fi

# ---------------------------------------------------------------------------
# Check there is something to commit
# ---------------------------------------------------------------------------
if [ ${#ERRORS[@]} -eq 0 ]; then
  STATUS=$(git status --porcelain 2>&1) || fail "git status failed"
  DIFF=$(git diff HEAD 2>&1) || true

  if [ -z "$STATUS" ] && [ -z "$DIFF" ]; then
    fail "No changes detected. Nothing to commit."
  fi
fi

# ---------------------------------------------------------------------------
# Generate conventional commit message from diff summary
# ---------------------------------------------------------------------------
if [ ${#ERRORS[@]} -eq 0 ]; then
  CHANGED_FILES=$(git diff --name-only HEAD 2>/dev/null; git ls-files --others --exclude-standard 2>/dev/null) || true

  # Infer commit type from changed paths
  TYPE="chore"
  SCOPE=""
  if echo "$CHANGED_FILES" | grep -qE '\.(test|spec)\.(js|jsx|ts|tsx)$'; then
    TYPE="test"
  elif echo "$CHANGED_FILES" | grep -qE '^(src|frontend|backend|packages/frontend|packages/backend)/.*\.(js|jsx|ts|tsx)$'; then
    if echo "$CHANGED_FILES" | grep -qE '(feature|feat)'; then
      TYPE="feat"
    else
      TYPE="fix"
    fi
  elif echo "$CHANGED_FILES" | grep -qE '\.(md|txt|rst)$'; then
    TYPE="docs"
  elif echo "$CHANGED_FILES" | grep -qE '^\.github/'; then
    TYPE="chore"
    SCOPE="(ci)"
  fi

  # Build a short description from changed file names
  FILE_SUMMARY=$(echo "$CHANGED_FILES" | head -3 | xargs -I{} basename {} | tr '\n' ', ' | sed 's/,$//') || FILE_SUMMARY="project files"
  COMMIT_MSG="${TYPE}${SCOPE}: update ${FILE_SUMMARY}"
fi

# ---------------------------------------------------------------------------
# Create or switch branch
# ---------------------------------------------------------------------------
if [ ${#ERRORS[@]} -eq 0 ]; then
  EXISTING=$(git branch --list "$BRANCH" 2>/dev/null) || true
  if [ -z "$EXISTING" ]; then
    git checkout -b "$BRANCH" 2>&1 | grep -v '^Switched' || fail "Failed to create branch '$BRANCH'"
  else
    git checkout "$BRANCH" 2>&1 | grep -v '^Switched\|^Already' || fail "Failed to switch to branch '$BRANCH'"
  fi
fi

# ---------------------------------------------------------------------------
# Stage, commit, push
# ---------------------------------------------------------------------------
if [ ${#ERRORS[@]} -eq 0 ]; then
  git add . 2>&1 | grep -vE '^$' || fail "git add failed"
  git commit -m "$COMMIT_MSG" 2>&1 | grep -vE '^$' || fail "git commit failed"
  PUSH_OUT=$(git push origin "$BRANCH" 2>&1) || fail "git push failed: $PUSH_OUT"
fi

# ---------------------------------------------------------------------------
# Consolidated error report
# ---------------------------------------------------------------------------
if [ ${#ERRORS[@]} -gt 0 ]; then
  echo -e "\n${BOLD}${RED}══════════════════════════════════════════${RESET}"
  echo -e "${BOLD}${RED}  COMMIT-AND-PUSH ERRORS${RESET}"
  echo -e "${BOLD}${RED}══════════════════════════════════════════${RESET}"
  for err in "${ERRORS[@]}"; do
    echo -e "  ${RED}✖ $err${RESET}"
  done
  echo ""
  exit 1
fi

# ---------------------------------------------------------------------------
# Success (only output on success)
# ---------------------------------------------------------------------------
echo -e "${GREEN}${BOLD}✅ Pushed to '$BRANCH'${RESET}"
echo -e "   Commit: ${CYAN}$COMMIT_MSG${RESET}"
