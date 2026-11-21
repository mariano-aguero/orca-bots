# Researcher

[![Orca](https://img.shields.io/badge/Orca-bot-1f6feb)](https://github.com/stablyai/orca)
[![Last commit](https://img.shields.io/github/last-commit/mariano-aguero/orca-bots/main?path=researcher)](https://github.com/mariano-aguero/orca-bots/commits/main/researcher)
[![Mode](https://img.shields.io/badge/mode-read%20only-lightgrey)](#permissions)
[![Trigger](https://img.shields.io/badge/trigger-chat%2C%20Linear%2C%20schedule-8250df)](#install)
[![License: MIT](https://img.shields.io/badge/license-MIT-green)](../LICENSE)

An Orca bot that researches for you. It answers questions from primary sources, analyzes datasets with scripts it keeps, and measures what a feature, a dependency release or a spec change means for your projects, down to file:line. A weekly run reviews the releases and spec changes that touch your projects, and a daily run diffs the pages you name and speaks only when one changed in a way that matters. Every claim carries a source, and every report says what it could not verify.

## Files

- `SOUL.md`: who the bot is, its settings, its permissions and what it may never do.
- `skills/research/SKILL.md`: the procedure. Research, data analysis, feature impact, weekly watch, page watch, its clones and the report format.
- `examples/settings.md`: the settings file, with your projects, specs, packages and pages.
- `examples/automation-weekly.txt`, `examples/automation-pages.txt`: the automation prompts.

## Install

Create a bot in Orca named `Researcher`, then from this folder:

```sh
BOT=$(dirname "$(grep -l '"name": "Researcher"' ~/.orca/bots/*/bot.json)")
cp "$BOT/SOUL.md" "$BOT/SOUL.md.bak"
cp SOUL.md "$BOT/SOUL.md"
mkdir -p "$BOT/.claude/skills/research" "$BOT/memory"
cp skills/research/SKILL.md "$BOT/.claude/skills/research/"
cp examples/settings.md "$BOT/memory/settings.md"
```

Edit `memory/settings.md` in the bot's folder with your projects and what to watch. Only `projects` is required. Then add the schedules you want:

```sh
orca automations create --bot "Researcher" --name "Weekly watch" \
  --trigger weekly --day 1 --time 09:00 --runs-in new --results-to chat \
  --prompt "$(cat examples/automation-weekly.txt)"
orca automations create --bot "Researcher" --name "Page watch" \
  --trigger weekdays --time 09:30 --runs-in new --results-to chat \
  --prompt "$(cat examples/automation-pages.txt)"
```

Questions need no automation: ask in its chat, or mention or assign it on a Linear issue and it answers there.

## Reports

The full report goes to `reports/<date>-<topic>.md` in the bot's folder: the answer, the evidence with sources and their dates, the impact per project, what was verified and what was not, and the open questions. The chat gets the answer in a few lines and the report's path. An answer on a Linear issue carries its sources inline and no local paths.

## Permissions

It reads GitHub and Linear as you, and runs spikes only in its own clones and worktrees, which it deletes after the report. It never pushes, opens or comments on anything, outside its chats and the Linear issue that woke it. A finding that needs code goes to you; you decide whether the [Eng lead](../eng-lead/) takes it.

## License

[MIT](../LICENSE)
