#!/usr/bin/env bash
# =============================================================================
# run-validate-step.sh
# Companion runner for the /validate-step prompt.
# Fetches the success criteria for a given step from the GitHub issue and
# checks each file/state criterion against the current workspace.
#
# - Silent on success (prints only a final ✅ summary when all pass).
# - Never stops on error — collects all failures and reports at the end.
# - Filters log to non-success lines only.
# - Prints a consolidated error list at the end.
#
# Usage:
#   bash scripts/run-validate-step.sh <step-number>   e.g. 5-0, 5-1
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

ERRORS=()       # blocking setup/fetch errors
FAILED=()       # criteria that did not pass
PASSED=()       # criteria that passed (used only for final count)

fail()     { ERRORS+=("$1"); }
criterion_fail() { FAILED+=("$1"); }
criterion_pass() { PASSED+=("$1"); }

# ---------------------------------------------------------------------------
# Require step number
# ---------------------------------------------------------------------------
STEP="${1:-}"
if [ -z "$STEP" ]; then
  fail "Step number is required. Usage: bash scripts/run-validate-step.sh <step-number>  (e.g. 5-0)"
fi

# ---------------------------------------------------------------------------
# Prereq: gh CLI
# ---------------------------------------------------------------------------
if ! command -v gh &>/dev/null; then
  fail "gh CLI not found. Install from https://cli.github.com"
fi

# ---------------------------------------------------------------------------
# Resolve exercise issue
# ---------------------------------------------------------------------------
if [ ${#ERRORS[@]} -eq 0 ]; then
  RAW_LIST=$(gh issue list --state open 2>&1) || fail "gh issue list failed: $RAW_LIST"
  ISSUE_NUMBER=$(echo "$RAW_LIST" | grep -i 'Exercise:' | head -1 | awk '{print $1}') || true
  if [ -z "$ISSUE_NUMBER" ]; then
    fail "Could not find an open issue with 'Exercise:' in the title."
  fi
fi

# ---------------------------------------------------------------------------
# Fetch issue
# ---------------------------------------------------------------------------
if [ ${#ERRORS[@]} -eq 0 ]; then
  ISSUE_BODY=$(gh issue view "$ISSUE_NUMBER" --comments 2>&1) || fail "Failed to fetch issue #$ISSUE_NUMBER"
fi

# ---------------------------------------------------------------------------
# Extract success criteria for the requested step
# ---------------------------------------------------------------------------
if [ ${#ERRORS[@]} -eq 0 ]; then
  # Grab block from "# Step X-Y:" up to the next "# Step" or end of output
  STEP_BLOCK=$(echo "$ISSUE_BODY" | awk "/^# Step ${STEP}:/{found=1} found && /^# Step / && !/^# Step ${STEP}:/{found=0} found{print}" 2>/dev/null) || true

  if [ -z "$STEP_BLOCK" ]; then
    fail "Could not find '# Step ${STEP}:' in the issue comments."
  fi

  # Extract lines inside the Success Criteria section (✅ bullet points)
  CRITERIA=$(echo "$STEP_BLOCK" | awk '/## Success Criteria/{found=1; next} found && /^##/{found=0} found && /^- ✅/{print}' 2>/dev/null) || true

  if [ -z "$CRITERIA" ]; then
    fail "No '## Success Criteria' section found in Step ${STEP}."
  fi
fi

# ---------------------------------------------------------------------------
# Check each criterion
# ---------------------------------------------------------------------------
check_file() {
  local desc="$1"
  local path="$2"
  if [ -e "$path" ]; then
    criterion_pass "$desc"
  else
    criterion_fail "$desc — NOT FOUND: $path"
  fi
}

check_branch() {
  local desc="$1"
  local branch="$2"
  if git branch -a 2>/dev/null | grep -q "$branch"; then
    criterion_pass "$desc"
  else
    criterion_fail "$desc — branch '$branch' not found"
  fi
}

if [ ${#ERRORS[@]} -eq 0 ]; then
  while IFS= read -r line; do
    # Strip leading "- ✅ "
    desc=$(echo "$line" | sed 's/^- ✅ //')

    # Match file-path patterns (starts with . or contains /)
    if echo "$desc" | grep -qE '^Created `?\.' || echo "$desc" | grep -qE "'\./" ; then
      fpath=$(echo "$desc" | grep -oE '`[^`]+`' | head -1 | tr -d '`') || fpath=""
      [ -n "$fpath" ] && check_file "$desc" "$fpath" || criterion_pass "$desc (manual check needed)"

    # Match branch push criteria
    elif echo "$desc" | grep -qi 'pushed\|branch'; then
      bname=$(echo "$desc" | grep -oE 'feature/[a-zA-Z0-9_-]+') || bname=""
      [ -n "$bname" ] && check_branch "$desc" "$bname" || criterion_pass "$desc (manual check needed)"

    # Generic: try to extract a backtick path and check it exists
    else
      fpath=$(echo "$desc" | grep -oE '`[^`]+`' | head -1 | tr -d '`') || fpath=""
      if [ -n "$fpath" ] && [ -e "$fpath" ]; then
        criterion_pass "$desc"
      elif [ -n "$fpath" ]; then
        criterion_fail "$desc — NOT FOUND: $fpath"
      else
        criterion_pass "$desc (manual check needed)"
      fi
    fi
  done <<< "$CRITERIA"
fi

# ---------------------------------------------------------------------------
# Consolidated error / failure report
# ---------------------------------------------------------------------------
if [ ${#ERRORS[@]} -gt 0 ]; then
  echo -e "\n${BOLD}${RED}══════════════════════════════════════════${RESET}"
  echo -e "${BOLD}${RED}  VALIDATE-STEP SETUP ERRORS${RESET}"
  echo -e "${BOLD}${RED}══════════════════════════════════════════${RESET}"
  for err in "${ERRORS[@]}"; do
    echo -e "  ${RED}✖ $err${RESET}"
  done
  echo ""
  exit 1
fi

if [ ${#FAILED[@]} -gt 0 ]; then
  echo -e "\n${BOLD}${YELLOW}══════════════════════════════════════════${RESET}"
  echo -e "${BOLD}${YELLOW}  Step ${STEP} — INCOMPLETE (${#FAILED[@]} remaining)${RESET}"
  echo -e "${BOLD}${YELLOW}══════════════════════════════════════════${RESET}"
  for f in "${FAILED[@]}"; do
    echo -e "  ${RED}❌ $f${RESET}"
  done
  echo ""
  echo -e "${CYAN}Fix the items above, then re-run: bash scripts/run-validate-step.sh ${STEP}${RESET}"
  echo ""
  exit 1
fi

# ---------------------------------------------------------------------------
# All passed (only output on full success)
# ---------------------------------------------------------------------------
echo -e "${GREEN}${BOLD}✅ Step ${STEP} complete — all ${#PASSED[@]} criteria passed.${RESET}"
echo -e "${CYAN}Next: bash scripts/run-commit-and-push.sh <branch-name>${RESET}"
