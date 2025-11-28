#!/usr/bin/env bash
set -euo pipefail

# Usage:
# DO_GH_CREATE=true ./scripts/push_to_github.sh
# or simply run the script after configuring gh auth locally.

REPO_NAME=${REPO_NAME:-crud-dd-task-mean-app}
GITHUB_USER=${GITHUB_USER:-}

if ! command -v gh >/dev/null 2>&1; then
  echo "The GitHub CLI 'gh' is required. Install from https://cli.github.com/"
  exit 1
fi

if [ -z "${GITHUB_USER}" ]; then
  echo "Set GITHUB_USER environment variable (your GitHub username)."
  echo "Falling back to authenticated user from gh..."
  GITHUB_USER=$(gh api user --jq .login)
fi

# Ensure repo is initialized
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || git init
git add .
git commit -m "chore: add docker, compose, nginx, CI/CD" || true

if [ "${DO_GH_CREATE:-false}" = "true" ]; then
  echo "Creating repo ${GITHUB_USER}/${REPO_NAME}..."
  gh repo create "${GITHUB_USER}/${REPO_NAME}" --public --source=. --remote=origin --push
else
  echo "Assuming remote 'origin' exists. If not, run with DO_GH_CREATE=true or set remote manually."
  git push -u origin main || git push -u origin master || true
fi

echo "Repository push step finished. Verify on GitHub web UI."
