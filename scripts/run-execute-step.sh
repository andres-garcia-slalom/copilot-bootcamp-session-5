#!/usr/bin/env bash
# =============================================================================
# run-execute-step.sh
# Companion runner for the /execute-step prompt.
# Fetches the latest exercise step from the GitHub issue and prints the
# activities so the developer (or AI) can act on them.
#
# - Silent on success (no output when everything resolves cleanly).
# - Never stops on error — collects all failures and reports at the end.
# - Filters log to non-success lines only.
# - Prints a consolidated error list at the end.
#
# Usage:
#   bash scripts/run-execute-step.sh              # auto-detect issue
#   bash scripts/run-execute-step.sh <issue-num>  # use explicit issue number
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
# Prereq: gh CLI
# ---------------------------------------------------------------------------
if ! command -v gh &>/dev/null; then
  fail "gh CLI not found. Install from https://cli.github.com"
fi

# ---------------------------------------------------------------------------
# Resolve issue number
# ---------------------------------------------------------------------------
ISSUE_NUMBER="${1:-}"

if [ -z "$ISSUE_NUMBER" ]; then
  raw=$(gh issue list --state open 2>&1) || { fail "gh issue list failed: $raw"; }
  ISSUE_NUMBER=$(echo "$raw" | grep -i 'Exercise:' | head -1 | awk '{print $1}') || true
  if [ -z "$ISSUE_NUMBER" ]; then
    fail "Could not find an open issue with 'Exercise:' in the title. Pass the issue number as an argument."
  fi
fi

# ---------------------------------------------------------------------------
# Fetch issue content
# ---------------------------------------------------------------------------
ISSUE_BODY=$(gh issue view "$ISSUE_NUMBER" --comments 2>&1) || {
  fail "Failed to fetch issue #$ISSUE_NUMBER"
  ISSUE_BODY=""
}

# ---------------------------------------------------------------------------
# Extract latest step
# ---------------------------------------------------------------------------
LATEST_STEP=$(echo "$ISSUE_BODY" | grep -oE '# Step [0-9]+-[0-9]+:' | tail -1) || true

if [ -z "$LATEST_STEP" ]; then
  fail "No '# Step X-Y:' heading found in issue #$ISSUE_NUMBER"
fi

# ---------------------------------------------------------------------------
# Extract activities from latest step
# ---------------------------------------------------------------------------
# Print only if we have content and no blocking errors so far
if [ ${#ERRORS[@]} -eq 0 ] && [ -n "$LATEST_STEP" ]; then
  ACTIVITIES=$(echo "$ISSUE_BODY" | awk "/^$LATEST_STEP/{found=1} found && /^:keyboard: Activity:/{print}" 2>/dev/null) || true

  if [ -n "$ACTIVITIES" ]; then
    echo -e "${BOLD}${CYAN}Latest step: $LATEST_STEP${RESET}"
    echo -e "${CYAN}Activities to execute:${RESET}\n"
    echo "$ACTIVITIES"
    echo ""
    echo -e "${GREEN}Fetch complete. Review activities above, then use the tdd-developer agent to execute them.${RESET}"
    echo -e "${YELLOW}When done: run  bash scripts/run-validate-step.sh <step-number>${RESET}"
  else
    fail "No ':keyboard: Activity:' sections found under $LATEST_STEP"
  fi
fi

# ---------------------------------------------------------------------------
# Consolidated error report
# ---------------------------------------------------------------------------
if [ ${#ERRORS[@]} -gt 0 ]; then
  echo -e "\n${BOLD}${RED}══════════════════════════════════════════${RESET}"
  echo -e "${BOLD}${RED}  EXECUTE-STEP ERRORS${RESET}"
  echo -e "${BOLD}${RED}══════════════════════════════════════════${RESET}"
  for err in "${ERRORS[@]}"; do
    echo -e "  ${RED}✖ $err${RESET}"
  done
  echo ""
  exit 1
fi
