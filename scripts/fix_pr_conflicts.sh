#!/usr/bin/env bash
set -euo pipefail

# Rebuild current PR branch on top of origin/main and replay local commits.
# Usage:
#   scripts/fix_pr_conflicts.sh [base_branch]
# Example:
#   scripts/fix_pr_conflicts.sh main

BASE_BRANCH="${1:-main}"
CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"

if [[ "$CURRENT_BRANCH" == "HEAD" ]]; then
  echo "[ERROR] Detached HEAD. Checkout your PR branch first."
  exit 1
fi

if ! git remote get-url origin >/dev/null 2>&1; then
  echo "[ERROR] Remote 'origin' not configured."
  exit 1
fi

echo "[INFO] Fetching origin/${BASE_BRANCH}..."
git fetch origin "${BASE_BRANCH}"

BASE_REF="origin/${BASE_BRANCH}"
if ! git show-ref --verify --quiet "refs/remotes/${BASE_REF}"; then
  echo "[ERROR] Base ref ${BASE_REF} not found after fetch."
  exit 1
fi

# Local-only commits in current branch relative to base
COMMITS=$(git rev-list --reverse "${BASE_REF}..${CURRENT_BRANCH}" || true)
if [[ -z "${COMMITS}" ]]; then
  echo "[INFO] No local commits to replay. Branch is already based on ${BASE_REF}."
  exit 0
fi

TS="$(date +%Y%m%d%H%M%S)"
BACKUP_BRANCH="backup/${CURRENT_BRANCH}-${TS}"

echo "[INFO] Creating backup branch: ${BACKUP_BRANCH}"
git branch "${BACKUP_BRANCH}"

echo "[INFO] Resetting ${CURRENT_BRANCH} to ${BASE_REF}"
git reset --hard "${BASE_REF}"

for c in ${COMMITS}; do
  echo "[INFO] Cherry-picking ${c}"
  if ! git cherry-pick "${c}"; then
    echo "[ERROR] Conflict while cherry-picking ${c}."
    echo "Resolve files, then run:"
    echo "  git add <files>"
    echo "  git cherry-pick --continue"
    echo "After finishing all commits, push with:"
    echo "  git push --force-with-lease origin ${CURRENT_BRANCH}"
    exit 2
  fi
done

echo "[OK] Branch rebuilt on top of ${BASE_REF}."
echo "[NEXT] Push updated branch:"
echo "  git push --force-with-lease origin ${CURRENT_BRANCH}"
