# Daily standup notes

[![Orca](https://img.shields.io/badge/Orca-bot-1f6feb)](https://github.com/stablyai/orca)
[![Last commit](https://img.shields.io/github/last-commit/mariano-aguero/orca-bots/main?path=standup-notes)](https://github.com/mariano-aguero/orca-bots/commits/main/standup-notes)
[![Mode](https://img.shields.io/badge/mode-read--only-lightgrey)](#install)
[![Trigger](https://img.shields.io/badge/trigger-schedule-8250df)](#install)
[![License: MIT](https://img.shields.io/badge/license-MIT-green)](../LICENSE)

An Orca bot that writes your standup every working morning: what you and your agents did the day before, what is next, and what blocks you. It reads your Orca workspaces, your pull requests and your Linear issues, and changes nothing.

## Files

- `SOUL.md`: who the bot is, what it reads, what it writes and what it may never do.
- `skills/standup-notes/SKILL.md`: the procedure. Window, sources and grouping.
- `examples/automation.txt`: the automation prompt, with the language and the GitHub owners and Linear teams to narrow to.

## Install

Create a bot in Orca named `Daily standup notes`, then from this folder:

```sh
BOT=$(dirname "$(grep -l '"name": "Daily standup notes"' ~/.orca/bots/*/bot.json)")
cp "$BOT/SOUL.md" "$BOT/SOUL.md.bak"
cp SOUL.md "$BOT/SOUL.md"
mkdir -p "$BOT/.claude/skills/standup-notes"
cp skills/standup-notes/SKILL.md "$BOT/.claude/skills/standup-notes/"
```

Copy `examples/automation.txt`, set the language and the GitHub owners and Linear teams, or delete those lines, then add the automation:

```sh
orca automations create --bot "Daily standup notes" --name "Standup notes" \
  --trigger "0 9 * * 1-5" --runs-in new --results-to chat \
  --prompt "$(cat automation.txt)"
```

The bot reads Linear through a Linear connector (`orca bot connectors --offer linear`) or the Linear MCP server of your Claude Code. Without either, the notes cover Orca and GitHub only.

## License

[MIT](../LICENSE)
