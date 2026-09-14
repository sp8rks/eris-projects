# Vibe Coding 101: Claude Agents in GitHub Actions
## Copy-paste command cheatsheet (in order)

All commands below are PowerShell-ready. Notes for PC users:
- The backtick ` is PowerShell's line-continuation character (not \)
- Command chaining uses ; (Windows PowerShell 5.1 does not support &&)
- `gh secret set NAME` prompts you to paste the value interactively, so no
  secret ever lands in your history or on screen. Great for recording.

---

### Step 0. Prerequisites (one time per machine)

```powershell
# Claude Code CLI (requires Node 18+ and Git for Windows)
npm install -g @anthropic-ai/claude-code

# GitHub CLI
winget install GitHub.cli
# (restart PowerShell so gh lands on your PATH)

# Log in to GitHub CLI
gh auth login
```

You also need: a Claude Pro or Max subscription, a GitHub account, and any
tool accounts you want to wire in (Asta beta access, Edison Scientific account,
CHPC allocation).

---

### Step 1. Create the repo

Name it as the group's one-stop shop: one catch-all agent repo for random
projects, exploratory analyses, and quick tasks. Dedicated grant repos (AURORA,
proposal repos, etc.) get their own copy of this setup separately, with their
own secrets.

```powershell
gh repo create sparks_group_random_projects --private --clone
cd sparks_group_random_projects
git commit --allow-empty -m "init"; git push -u origin main
```

---

### Step 2. Install the Claude GitHub App

One terminal command launches the installer:

```powershell
claude /install-github-app
```

- Pick the specific repo (not all repos).
- The browser flow may try to route you to API-key setup. Pro/Max users:
  skip that. We authenticate with an OAuth token in the next step.
- Alternative: install manually at https://github.com/apps/claude

---

### Step 3. Generate the Claude OAuth token

In a regular terminal:

```powershell
claude setup-token
```

Copy the token (starts with `sk-ant-oat01-`). You only see it once. Then:

```powershell
gh secret set CLAUDE_CODE_OAUTH_TOKEN
# paste token when prompted
```

---

### Step 4. Asta (Allen AI) plugins + token

Install the plugins straight from your terminal (this also gives you the
`asta` CLI):

```powershell
claude plugin marketplace add https://github.com/allenai/asta-plugins.git
claude plugin install asta-tools@asta-plugins
claude plugin install asta-flows@asta-plugins
```

Then authenticate with the email your Asta credits are tied to, and print a
refresh token:

```powershell
asta auth login
asta auth print-token --raw --refresh
```

Add it as a secret:

```powershell
gh secret set ASTA_TOKEN
# paste token when prompted
```

Note: Asta refresh tokens are user-scoped and can expire. If agent runs start
failing Asta auth, regenerate and re-set the secret.

---

### Step 5. Edison Scientific API key

Get your key from the Edison platform (platform.edisonscientific.com), then:

```powershell
gh secret set EDISON_PLATFORM_API_KEY
# paste key when prompted
```

---

### Step 6. CHPC credentials

```powershell
gh secret set CHPC_USERNAME
gh secret set CHPC_PASSWORD
```

Reminder: CHPC accounts are personal under the acceptable use policy, and Duo
2FA means some runs need you in the loop. Think of this as delegating YOUR
access to the agent, not creating shared access.

---

### Step 7. Add the config files

```powershell
mkdir .github\workflows   # mkdir creates parent dirs automatically in PowerShell
# copy claude.yml into .github\workflows\ and CLAUDE.md into the repo root, e.g.:
#   Copy-Item ~\Downloads\claude.yml .github\workflows\
#   Copy-Item ~\Downloads\CLAUDE.md .
git add .github/workflows/claude.yml CLAUDE.md
git commit -m "Add Claude agent workflow and instructions"
git push
```

If the app installer created `.github/workflows/claude-code-review.yml`, either
delete it or fix its auth line to use `claude_code_oauth_token`. As generated,
it references `anthropic_api_key` and will fail on every PR for Pro/Max users:

```powershell
git rm .github/workflows/claude-code-review.yml
git commit -m "Remove broken auto-review workflow"; git push
```

---

### Step 8. Verify all secrets are in place

```powershell
gh secret list
```

You should see:
- CLAUDE_CODE_OAUTH_TOKEN
- ASTA_TOKEN
- EDISON_PLATFORM_API_KEY
- CHPC_USERNAME
- CHPC_PASSWORD

---

### Step 9. Test it

Smoke test:

```powershell
gh issue create --title "Agent smoke test" --body "@claude say hi"
```

Real test (exercises Asta + CHPC):

```powershell
gh issue create --title "Integration test" `
  --body "@claude Use Asta to find 3 recent papers on ML-guided thermoelectric discovery and summarize them. Then SSH to CHPC and submit a hello-world SLURM job, and report the job ID."
```

Watch the run:

```powershell
gh run watch
```

---

### Team access (the payoff)

Add lab members as collaborators. They trigger the agent with a GitHub comment.
No Anthropic account, no API keys, no tool setup on their end:

```powershell
gh repo edit --add-collaborator STUDENT_GITHUB_USERNAME
```

Everything runs on YOUR credentials and quotas, so only add people you trust,
especially with `bypassPermissions` enabled.
