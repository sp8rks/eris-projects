# CLAUDE.md

This file teaches the Claude agent how to behave in this repository. It is read
automatically at the start of every agent run.

## What this repo is

Public working repo for two candidate submissions to the DARPA ERIS
(Expedited Research Innovation System) marketplace, solicitation
DARPA-PS-25-05. Collaborators: Taylor Sparks (University of Utah, @sp8rks)
and Sterling Baird (BYU, @sgbaird).

Repo layout:

- `projects/project-a/` and `projects/project-b/`: one folder per ERIS idea.
  Each holds the 7-minute video script, the four supplemental slides
  (Appendix B format), the abstract, keywords, TRL justification, and any
  supporting analysis. Keep the two projects independent; do not cross-link
  content between them unless asked.
- `eris/`: notes on the ERIS rules, rubric, and topic areas. Read
  `eris/eris-notes.md` before drafting or reviewing any pitch content.
- `docs/`: setup cheatsheet for the agent workflow.

## ERIS content rules (hard constraints)

- This repo is PUBLIC and ERIS submissions are licensed to the entire .mil
  domain. Never write proprietary, export-controlled, or CUI content here.
  Flag anything that looks like it might be.
- Video pitch: 7:00 max, HD 1280x720, .mp4 under 1 GB. Scripts should be
  timed; assume ~130 words per minute, so a full script is roughly 900 words.
- Every pitch must cover the four required elements, in order: (1) problem and
  current state of the art, (2) advancing the state of the art, (3) team
  capability, (4) defense and/or commercial use case and impact.
- Supplemental slides are exactly four, in the Appendix B format: submission
  info, company/team introduction, criteria quad chart, solution overview and
  white-space chart.
- Abstract is 1,500 characters max. Title under 128 characters. At least five
  keywords.
- Each submission targets one ERIS topic area. State the topic explicitly at
  the top of each project README.

## Coding Agent Etiquette

- In comment replies, avoid `#<numeral>` style shorthand such as "#1" unless you
  are specifically referring to an issue or pull request, since GitHub
  auto-formats it as an issue/PR link. Write "No. 1" or "number 1" instead.
- This repo uses the `main` branch as its default branch.
- Be cautious with `~` ("approximately"): repeated tildes trigger strikeout
  formatting in Markdown previews.
- Include plots directly in your comment reply via
  `![image name](https://github.com/<user-or-org>/<repo>/blob/<short-hash>/<filename>?raw=true)`.
  Truncate the commit hash to the first 7 characters. For provenance, always use
  the shortened commit hash, never the branch name.
- If you mention files in your comment reply, add direct hyperlinks based on the
  shortened (7-character) commit hash.
- IMPORTANT: Never echo, grep, or print environment secrets. They must never
  appear in terminal history, logs, or comment replies.

### The GitHub token dies at minute 60 (push early, re-mint to continue)

The GitHub App token a session starts with (`GITHUB_TOKEN`/`GH_TOKEN` in the
session environment, and embedded in the origin remote URL) expires exactly 60
minutes after the Run Claude Code step starts. The session keeps running, but
`git push` fails, `gh` fails, and the MCP tool that updates the progress
comment fails, all with 401, so from the outside the session goes silent while
finished work stops landing.

- Push and update the tracking comment early and often. Treat minute 50 as the
  deadline for anything that must reach GitHub, in case recovery fails.
- At the first 401 from a push or `gh` call (or proactively around minute 55),
  run `python scripts/refresh_github_app_token.py`. It re-runs the action's
  own OIDC exchange, saves a fresh one-hour token to `/tmp/.ghtok` (mode
  0600), and re-points the origin remote at it, so plain `git push` works
  again. Validated live on a 125 minute session that re-minted hourly.
- `gh` keeps reading the dead token from the environment, so prefix each call:
  `GH_TOKEN=$(cat /tmp/.ghtok) gh ...`. Separately, `DEFAULT_WORKFLOW_TOKEN`
  is a distinct token that lasts the whole job and works for reads at any age.
- The MCP comment tool cannot be re-keyed mid-session. After a re-mint, update
  the tracking comment over REST instead: write the body to a file and run
  `GH_TOKEN=$(cat /tmp/.ghtok) gh api -X PATCH
  repos/$GITHUB_REPOSITORY/issues/comments/<comment-id> -F body=@that-file`.
- A re-minted token also lives one hour, so re-run the script each hour it is
  needed. Never echo, log, or commit a token value; the script prints only
  statuses and lengths.

## Asta (Allen Institute for AI)

The Asta plugins (Theorizer, AutoDiscovery, and related tools) are installed via
the Claude Code plugin system, configured in `.github/workflows/claude.yml`:

- Marketplace: `https://github.com/allenai/asta-plugins.git`
- Plugins: `asta-tools@asta-plugins` and `asta-flows@asta-plugins`

Authentication is provided via the `ASTA_TOKEN` GitHub Actions secret, exposed
as the `ASTA_TOKEN` environment variable. Do not echo, grep, or otherwise
surface this token. If Asta calls fail with authentication errors, the token has
likely expired; report this in your comment reply so the operator can regenerate
it locally (`asta auth login`, then `asta auth print-token --raw --refresh`) and
update the repo secret. Asta beta credits are tied to the operator's account, so
use the tools purposefully rather than for trivial lookups.

Use Asta tools when the task involves literature-grounded hypothesis generation
(Theorizer) or automated discovery workflows (AutoDiscovery), such as proposal
background research, identifying prior work, or generating candidate research
directions.

## Edison Scientific

When waiting on an Edison task in GitHub Actions, NEVER run the polling script
in the background (`run_in_background`, `nohup`, `&`). The runner is destroyed
the moment you post your final comment, killing background processes. Poll in
the FOREGROUND: either run the blocking fetch script as a single Bash call with
an explicit long timeout, or loop on short calls (`sleep 240` + `fetch --once`,
each under the Bash timeout). If you loop on short calls, you can take care of
intermediate tasks while you wait. Do not post your final comment until results
are fetched and committed, or ~45 minutes of wall-clock have elapsed, in which
case commit the task-id file and state that a follow-up `@claude` comment is
needed to fetch results.

If you need to upload files, use the analysis query type. Docs:
https://edisonscientific.gitbook.io/edison-cookbook/edison-client
Endpoint: https://api.platform.edisonscientific.com
The API key is in the `EDISON_PLATFORM_API_KEY` environment variable. Do not
expose this secret. Pass it in explicitly:

```python
from edison_client import EdisonClient, JobNames
client = EdisonClient(api_key=EDISON_PLATFORM_API_KEY)
```

Whenever you retrieve results (during the current agent session or a follow-up
session), fetch and commit all artifacts associated with a trajectory.

If using Edison Analysis, see
https://docs.edisonscientific.com/edison-client/file-management#upload for file
upload instructions. If able to use Context7, see
https://context7.com/future-house/edison-client-docs/llms.txt?tokens=10000 to
better inform your use of EdisonClient.

## University of Utah CHPC Access

CHPC credentials are provided via GitHub Actions secrets, exposed as the
`CHPC_USERNAME` and `CHPC_PASSWORD` environment variables. Never print them.

- Default login node: `notchpeak.chpc.utah.edu`
- CHPC uses Duo two-factor authentication. Interactive Duo pushes require the
  operator's participation; use the file-based 2FA workflow scripts in `hpc/`
  when available, and report clearly in your comment reply if a run is blocked
  waiting on 2FA.
- Wrap remote commands in a login shell (`bash -lc '...'`) so modules and paths
  load correctly.
- Submit compute via SLURM (`sbatch`); do not run heavy jobs on login nodes.
- Beware: `rsync --delete` can wipe remote virtual environments. Sync
  deliberately and exclude `venv/` and similar directories.
- CHPC scratch space is subject to automatic purge policies; commit important
  results back to the repo rather than leaving them in scratch.

## LaTeX

Install MiKTeX instead of TeXLive to reduce download size and time. In the first
installation of MiKTeX, download known required packages based on the LaTeX file
itself, and install anything else ad-hoc as needed.
