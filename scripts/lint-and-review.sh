#!/usr/bin/env bash
# =============================================================================
# lint-and-review.sh
# Run ESLint across backend and frontend.
# - Suppresses success noise: only prints output when issues are found.
# - Never stops on errors: collects all issues, reports at the end.
# - Prints a consolidated error list at the end for easy fix planning.
#
# Usage:
#   bash scripts/lint-and-review.sh             # lint both
#   bash scripts/lint-and-review.sh backend     # lint backend only
#   bash scripts/lint-and-review.sh frontend    # lint frontend only
#   bash scripts/lint-and-review.sh fix         # auto-fix safe issues, then lint both
#   bash scripts/lint-and-review.sh backend fix # auto-fix backend only
#   bash scripts/lint-and-review.sh frontend fix # auto-fix frontend only
# =============================================================================

# Do NOT use set -e — we want to collect errors, not abort on first failure.
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

# ---------------------------------------------------------------------------
# Global error collector
# Each entry format: "[BACKEND|FRONTEND] rule:count  Description"
# ---------------------------------------------------------------------------
ALL_ERRORS=()
BACKEND_TOTAL=0
FRONTEND_TOTAL=0

# ---------------------------------------------------------------------------
# Known rule → human label mapping
# ---------------------------------------------------------------------------
declare -A RULE_LABELS=(
  ["no-unused-vars"]="Unused Variables"
  ["no-console"]="Console Statements"
  ["no-undef"]="Undefined Variables"
  ["semi"]="Missing Semicolons"
  ["quotes"]="Quote Style"
  ["eqeqeq"]="Strict Equality (=== vs ==)"
  ["prefer-const"]="Prefer const over let"
  ["no-var"]="No var (use let/const)"
  ["indent"]="Indentation"
  ["space-before-function-paren"]="Function Paren Spacing"
  ["import/order"]="Import Order"
  ["react-hooks/exhaustive-deps"]="React Hooks — Missing Deps"
  ["react-hooks/rules-of-hooks"]="React Hooks — Rules Violation"
  ["react/prop-types"]="Missing PropTypes"
)

# ---------------------------------------------------------------------------
# lint_dir <dir> <label> <fix:true|false>
# Returns 0 if clean, 1 if issues found.
# ---------------------------------------------------------------------------
lint_dir() {
  local dir="$1"
  local label="$2"
  local fix_mode="$3"

  if [ ! -d "$dir" ] || [ ! -f "$dir/package.json" ]; then
    return 0
  fi

  pushd "$dir" > /dev/null

  # Auto-fix pass (silent — only mention if it ran)
  if [ "$fix_mode" = "true" ]; then
    npx eslint . --fix --quiet 2>/dev/null || true
  fi

  # Capture lint output — allow failure
  local raw
  raw=$(npx eslint . --format=compact 2>&1) || true

  popd > /dev/null

  # Filter to only error/warning lines
  local issues
  issues=$(echo "$raw" | grep -E ': (error|warning)' || true)

  if [ -z "$issues" ]; then
    # Silent on success — no noise
    return 0
  fi

  # -------------------------------------------------------------------------
  # Count total issues for this target
  # -------------------------------------------------------------------------
  local total
  total=$(echo "$issues" | wc -l | tr -d ' ')

  if [ "$label" = "Backend" ]; then
    BACKEND_TOTAL=$total
  else
    FRONTEND_TOTAL=$total
  fi

  # -------------------------------------------------------------------------
  # Categorize by rule and collect into global error list
  # -------------------------------------------------------------------------
  for rule in "${!RULE_LABELS[@]}"; do
    local count
    count=$(echo "$issues" | grep -c "$rule" 2>/dev/null || true)
    count=$(echo "$count" | tr -d ' ')
    if [ "${count:-0}" -gt 0 ]; then
      ALL_ERRORS+=("$(printf '%-10s  %-4s  %-42s  (%s)' "[$label]" "[$count]" "${RULE_LABELS[$rule]}" "$rule")")
    fi
  done

  # Catch any rules not in our map
  local known_rules_pattern
  known_rules_pattern=$(IFS='|'; echo "${!RULE_LABELS[*]}")
  local uncategorized
  uncategorized=$(echo "$issues" | grep -vE "($known_rules_pattern)" | wc -l | tr -d ' ')
  if [ "${uncategorized:-0}" -gt 0 ]; then
    ALL_ERRORS+=("$(printf '%-10s  %-4s  %-42s' "[$label]" "[$uncategorized]" "Other / Uncategorized")")
  fi

  return 1
}

# ---------------------------------------------------------------------------
# Parse arguments
# Supports: backend, frontend, fix (any order, e.g. "backend fix" or "fix frontend")
# ---------------------------------------------------------------------------
TARGET="both"
FIX_MODE="false"

for arg in "${@:-}"; do
  case "$arg" in
    backend)  TARGET="backend" ;;
    frontend) TARGET="frontend" ;;
    fix)      FIX_MODE="true" ;;
  esac
done

# ---------------------------------------------------------------------------
# Run linting
# ---------------------------------------------------------------------------
BACKEND_EXIT=0
FRONTEND_EXIT=0

if [ "$TARGET" = "backend" ] || [ "$TARGET" = "both" ]; then
  lint_dir "backend" "Backend" "$FIX_MODE" || BACKEND_EXIT=1
fi

if [ "$TARGET" = "frontend" ] || [ "$TARGET" = "both" ]; then
  lint_dir "frontend" "Frontend" "$FIX_MODE" || FRONTEND_EXIT=1
fi

# ---------------------------------------------------------------------------
# Final report — only printed when there are issues
# ---------------------------------------------------------------------------
OVERALL_EXIT=$(( BACKEND_EXIT + FRONTEND_EXIT ))

if [ $OVERALL_EXIT -eq 0 ]; then
  echo -e "${GREEN}${BOLD}✅ Lint clean — no issues found.${RESET}"
  exit 0
fi

# Print consolidated error list
echo -e "\n${BOLD}${RED}═══════════════════════════════════════════════════════${RESET}"
echo -e "${BOLD}${RED}  LINT ISSUES FOUND — Fix Plan${RESET}"
echo -e "${BOLD}${RED}═══════════════════════════════════════════════════════${RESET}"
echo -e "${YELLOW}  Target    Count  Rule / Description${RESET}"
echo -e "${YELLOW}  ──────    ─────  ────────────────────────────────────────${RESET}"
for entry in "${ALL_ERRORS[@]}"; do
  echo -e "  ${RED}${entry}${RESET}"
done

echo ""
[ $BACKEND_TOTAL -gt 0 ]  && echo -e "  ${BOLD}Backend total:   $BACKEND_TOTAL issue(s)${RESET}"
[ $FRONTEND_TOTAL -gt 0 ] && echo -e "  ${BOLD}Frontend total:  $FRONTEND_TOTAL issue(s)${RESET}"

echo -e "\n${BOLD}${CYAN}Suggested fix order:${RESET}"
echo    "  1. Auto-fix formatting:  bash scripts/lint-and-review.sh ${TARGET} fix"
echo    "  2. no-unused-vars   — remove or use the variable"
echo    "  3. no-console       — replace with logger or remove debug logs"
echo    "  4. no-undef         — add missing imports/declarations"
echo    "  5. react-hooks/*    — add missing deps or wrap in useCallback"
echo    "  6. react/prop-types — add PropTypes declarations"
echo    "  7. Re-run:           bash scripts/lint-and-review.sh ${TARGET}"
echo    "  8. Run tests:        npm run test:backend && npm run test:frontend"
echo ""

exit 1
