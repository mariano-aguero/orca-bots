# PR shepherd

[![Orca](https://img.shields.io/badge/Orca-bot-1f6feb)](https://github.com/stablyai/orca)
[![Last commit](https://img.shields.io/github/last-commit/mariano-aguero/orca-bots/main?path=pr-shepherd)](https://github.com/mariano-aguero/orca-bots/commits/main/pr-shepherd)
[![Mode](https://img.shields.io/badge/mode-no%20merges-lightgrey)](#install)
[![Trigger](https://img.shields.io/badge/trigger-GitHub%20events-8250df)](#install)
[![License: MIT](https://img.shields.io/badge/license-MIT-green)](../LICENSE)

An Orca bot for the pull requests you author. When a teammate reviews or comments, it sorts each thread into fix, answer, already done, or yours to decide, prepares the fixes with a test each in its own clone, and drafts the replies. When a check fails, it finds the cause. It tells you when a PR can be marked ready or merged. It never merges, and it pushes nothing until you allow it.

## Files

- `SOUL.md`: who the bot is, what wakes it, its opt-in permissions and what it may never do.
- `skills/pr-shepherd/SKILL.md`: the procedure. Gate on the PR author, its own clone, thread triage, failing checks, ready, merged, writing to GitHub, and a second opinion from the Pull request reviewer.
- `examples/automation.txt`: the automation prompt.

## Install

Create a bot in Orca named `PR shepherd`, then from this folder:

```sh
BOT=$(dirname "$(grep -l '"name": "PR shepherd"' ~/.orca/bots/*/bot.json)")
cp "$BOT/SOUL.md" "$BOT/SOUL.md.bak"
cp SOUL.md "$BOT/SOUL.md"
mkdir -p "$BOT/.claude/skills/pr-shepherd"
cp skills/pr-shepherd/SKILL.md "$BOT/.claude/skills/pr-shepherd/"
```

Connect GitHub to the bot (`orca bot connectors --offer github` from its chat, or in the app). Then add the automation, limited to your repos. `from=` keeps comment events to your teammates, which also leaves out bots:

```sh
orca automations create --bot "PR shepherd" --name "My pull requests" \
  --on "github.review in=your-org/your-repo from=@teammate" \
  --on "github.review_comment in=your-org/your-repo from=@teammate" \
  --on "github.comment in=your-org/your-repo from=@teammate" \
  --on "github.ci_failed in=your-org/your-repo" \
  --on "github.pr_merged in=your-org/your-repo" \
  --runs-in new --results-to chat \
  --prompt "$(cat examples/automation.txt)"
```

The events fire on every pull request in those repos. The skill drops the ones you did not author.


## With the Pull request reviewer

The two bots split pull requests by author. The reviewer takes the ones you review, the shepherd the ones you wrote. Install both SOULs from this repo: each ends with NO_REPLY on the other's pull requests.

## Permissions

It starts by committing fixes only in its own clone. To widen that, add to your copy of the prompt any of: "My owner allowed pushing my fix commits", "My owner allowed replying to and resolving the threads I fixed", "My owner allowed marking a draft PR ready for review".


## Without the Orca GitHub app

GitHub events reach a bot only for repos the Orca GitHub app can see, and adding a repo to an org's installation takes an org admin. Without that, run the bot on a schedule and let it find the work with `gh`, which acts as you. `tools/gh-changed.sh` from this repo, used as the precheck, starts a run only when the precheck's output changed since the last one:

```sh
install -m 755 ../tools/gh-changed.sh ~/.local/bin/gh-changed
mkdir -p "$BOT/state" && cp examples/precheck.sh "$BOT/state/" && chmod +x "$BOT/state/precheck.sh"
orca automations create --bot "PR shepherd" --name "My pull requests" \
  --trigger "*/30 9-19 * * 1-5" --runs-in new --results-to chat \
  --precheck "PATH=$(dirname "$(command -v gh)"):$HOME/.local/bin:/usr/bin:/bin $HOME/.local/bin/gh-changed $BOT/state/last $BOT/state/precheck.sh" \
  --prompt "$(cat examples/automation-schedule.txt)"
```

Set your repos or owners in your copies of `examples/precheck.sh` and `examples/automation-schedule.txt`. Use events or the schedule, not both, or two runs can work the same pull request.


## License

[MIT](../LICENSE)
