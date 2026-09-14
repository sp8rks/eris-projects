#!/usr/bin/env bash
# One-time setup. Run from inside this folder after unzipping.
# Requires: gh (logged in), claude CLI, git.
set -e
REPO=${1:-eris-projects}

git init -b main
git add -A
git commit -m "Initial ERIS projects scaffold with Claude agent workflow"
gh repo create "$REPO" --public --source=. --push

# Add Sterling as a collaborator (write access)
gh repo edit --add-collaborator sgbaird

# Install the Claude GitHub App on this repo (pick THIS repo only in the browser)
claude /install-github-app || echo "If that failed, install manually at https://github.com/apps/claude"

# Secrets. Only CLAUDE_CODE_OAUTH_TOKEN is required. The rest are optional
# and only needed if you want Asta / Edison / CHPC available to the agent.
echo "Run: claude setup-token   then paste the sk-ant-oat01-... token below"
gh secret set CLAUDE_CODE_OAUTH_TOKEN
# gh secret set ASTA_TOKEN
# gh secret set EDISON_PLATFORM_API_KEY
# gh secret set CHPC_USERNAME
# gh secret set CHPC_PASSWORD

# If the app installer added a broken auto-review workflow, remove it
if [ -f .github/workflows/claude-code-review.yml ]; then
  git rm .github/workflows/claude-code-review.yml
  git commit -m "Remove broken auto-review workflow"
  git push
fi

gh secret list
echo "Smoke test:"
echo '  gh issue create --title "Agent smoke test" --body "@claude say hi"'
