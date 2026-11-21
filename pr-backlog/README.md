# PR backlog

[![Orca](https://img.shields.io/badge/Orca-bot-1f6feb)](https://github.com/stablyai/orca)
[![Last commit](https://img.shields.io/github/last-commit/mariano-aguero/orca-bots/main?path=pr-backlog)](https://github.com/mariano-aguero/orca-bots/commits/main/pr-backlog)
[![Mode](https://img.shields.io/badge/mode-merge%20on%20yes-lightgrey)](#permissions)
[![Trigger](https://img.shields.io/badge/trigger-weekly-8250df)](#install)
[![License: MIT](https://img.shields.io/badge/license-MIT-green)](../LICENSE)

An Orca bot for the pull requests nobody is moving. Once a week it reads every open PR from a dependency bot, and every other PR with no recent activity, in the repos you name. For each one it proposes a single action: merge, review, rebase, close or wait, with the reason. It merges or closes only the PRs you say yes to in its chat.

## Files

- `SOUL.md`: who the bot is, its settings, its permissions and what it may never do.
- `skills/pr-backlog/SKILL.md`: the procedure. Collect, read each PR, decide, report, and act on a yes.
- `examples/automation.txt`: the automation prompt.

## Install

Create a bot in Orca named `PR backlog`, then from this folder:

```sh
BOT=$(dirname "$(grep -l '"name": "PR backlog"' ~/.orca/bots/*/bot.json)")
cp "$BOT/SOUL.md" "$BOT/SOUL.md.bak"
cp SOUL.md "$BOT/SOUL.md"
mkdir -p "$BOT/.claude/skills/pr-backlog"
cp skills/pr-backlog/SKILL.md "$BOT/.claude/skills/pr-backlog/"
```

Set your repos in your copy of `examples/automation.txt`, then add the weekly automation:

```sh
orca automations create --bot "PR backlog" --name "PR backlog" \
  --trigger weekly --day 1 --time 10:00 --runs-in new --results-to chat \
  --prompt "$(cat examples/automation.txt)"
```

`stale_days`, `close_days` and `min_release_age` take their defaults from `SOUL.md`. Add any of them to the prompt, one per line, to change them.

## What it proposes

| Action | When |
|---|---|
| close | Superseded by another PR, or idle past `close_days` with conflicts, failing checks, or still a draft |
| rebase | Conflicts or behind its base, otherwise in good shape |
| review | Waiting on a reviewer, or touching a path in `.github/risky-paths` |
| merge | Green, mergeable, approved, no open threads, no risky path; a dependency bump also needs its release public for `min_release_age` days |
| wait | None of the above, such as checks still running |

A PR that gets the same recommendation two runs in a row says so, so what keeps sliding stands out.

## Permissions

It starts read only. A yes in its chat lets it merge or close the PRs you name, and it checks each one again before acting. A yes never lets it merge a draft, a PR with failing or pending checks, one the branch rules block, or one that touches a risky path.

## With the other bots

Your own PRs that need a rebase or a fix are marked for the [PR shepherd](../pr-shepherd/). PRs waiting on your review are only listed, since the [Pull request reviewer](../pr-reviewer/) already wakes on them.

## License

[MIT](../LICENSE)
