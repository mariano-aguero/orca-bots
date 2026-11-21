# orca-bots

[![Orca](https://img.shields.io/badge/built%20for-Orca-1f6feb)](https://github.com/stablyai/orca)
[![Bots](https://img.shields.io/badge/bots-8-8250df)](#bots)
[![Last commit](https://img.shields.io/github/last-commit/mariano-aguero/orca-bots)](https://github.com/mariano-aguero/orca-bots/commits/main)
[![License: MIT](https://img.shields.io/github/license/mariano-aguero/orca-bots?color=green)](LICENSE)
[![Stars](https://img.shields.io/github/stars/mariano-aguero/orca-bots?style=flat)](https://github.com/mariano-aguero/orca-bots/stargazers)

Bots for [Orca](https://github.com/stablyai/orca), ready to install. Each one does a single job for an engineering team, works as you through `gh` and your trackers, and keeps a person in charge of anything that reaches the main branch.

## Bots

| Bot | Starts on | What it does | Writes |
|---|---|---|---|
| [Pull request reviewer](pr-reviewer/) | A review request, a mention or new commits | Checks the PR against its task, verifies it by running the code, and drafts validated inline comments with suggested fixes | Nothing until you allow it |
| [Garbage collector](garbage-collector/) | A schedule | Removes useless comments and proven dead code and tests, one small PR per app | PRs against an integration branch, never merged |
| [Daily standup notes](standup-notes/) | A weekday schedule | Writes Yesterday / Today / Blockers from your Orca workspaces, pull requests and Linear issues | Nothing |
| [PR shepherd](pr-shepherd/) | A review, comment, failing check or merge on your own PR | Sorts review threads, prepares fixes with tests in its own clone, diagnoses failing checks, says when a PR is ready | Local commits until you allow pushes |
| [Chief of staff](chief-of-staff/) | A weekday schedule, morning and evening | One plan from your issues, reviews, PRs, meetings and the other bots, and hands approved work to the right bot | Hand-offs and issues you approve |
| [Eng lead](eng-lead/) | A hand-off | Plans an issue, waits for your OK, runs a writer and a verifier worker | Draft PRs |
| [Ops watch](ops-watch/) | A schedule and failed checks | Reports new production and staging problems with their likely cause, and drafts the issue | Issues you approve |
| [PR backlog](pr-backlog/) | A weekly schedule | Triages the open PRs nobody is moving, dependency bumps included, and proposes merge, review, rebase or close for each | Merges and closes you say yes to |

## Layout

Every bot folder has the same shape:

```text
<bot>/
  SOUL.md          who the bot is, what wakes it, what it reports, what it may never do
  skills/<name>/   the procedure, as a skill the bot runs
  README.md        what it does and how to install it
  examples/        automation prompts to copy, when the bot needs settings
```

The soul stays short and stable. The procedure lives in the skill, so it can improve without touching the bot's identity or its limits.

## Tools

- `tools/gh-changed.sh`: a precheck for scheduled automations. It runs a read-only command and lets the run start only when the output changed, so a bot that polls GitHub with `gh` costs nothing when there is nothing new.

## Install

Every bot does its GitHub work with `gh`, so it needs `gh` installed and signed in as you. The Orca GitHub app is optional: with it, GitHub events wake the bots; without it, they run on a schedule and find the work with `gh`. Use one or the other for a bot, not both.

1. Create the bot in Orca.
2. Copy its `SOUL.md` and its skill into `~/.orca/bots/<bot>/`, as its README shows.
3. Add the event or schedule that wakes it.

Every bot starts in a mode where nothing reaches your repos without you, and its README says how to widen that.

## License

[MIT](LICENSE)
