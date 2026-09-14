# One-time setup (PowerShell). Run from inside this folder after unzipping.
# Requires: gh (logged in), claude CLI, git.
param([string]$Repo = "eris-projects")

git init -b main
git add -A
git commit -m "Initial ERIS projects scaffold with Claude agent workflow"
gh repo create $Repo --public --source=. --push

gh repo edit --add-collaborator sgbaird

claude /install-github-app
# If that fails, install manually at https://github.com/apps/claude (pick this repo only)

Write-Host "Run: claude setup-token   then paste the sk-ant-oat01-... token when prompted"
gh secret set CLAUDE_CODE_OAUTH_TOKEN
# Optional:
# gh secret set ASTA_TOKEN
# gh secret set EDISON_PLATFORM_API_KEY
# gh secret set CHPC_USERNAME
# gh secret set CHPC_PASSWORD

if (Test-Path .github/workflows/claude-code-review.yml) {
  git rm .github/workflows/claude-code-review.yml
  git commit -m "Remove broken auto-review workflow"; git push
}

gh secret list
Write-Host 'Smoke test: gh issue create --title "Agent smoke test" --body "@claude say hi"'
