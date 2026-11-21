# Chief of staff

[![Orca](https://img.shields.io/badge/Orca-bot-1f6feb)](https://github.com/stablyai/orca)
[![Last commit](https://img.shields.io/github/last-commit/mariano-aguero/orca-bots/main?path=chief-of-staff)](https://github.com/mariano-aguero/orca-bots/commits/main/chief-of-staff)
[![Mode](https://img.shields.io/badge/mode-read%20and%20hand%20off-lightgrey)](#install)
[![Trigger](https://img.shields.io/badge/trigger-schedule-8250df)](#install)
[![License: MIT](https://img.shields.io/badge/license-MIT-green)](../LICENSE)

An Orca bot that starts your day with one short plan: issues assigned to you, pull requests waiting on your review, your own open pull requests, next steps from your meetings, and what the other bots reported. You answer in its chat, and it hands the work you approve to the bot that owns it. In the evening it reports what moved and what is stuck.

## Files

- `SOUL.md`: who the bot is, what it reads, which bot gets which work, and what it may never do.
- `skills/triage/SKILL.md`: the procedure. Morning plan, hand-offs after your OK, and the evening report.
- `examples/automation-morning.txt` and `examples/automation-evening.txt`: the two automation prompts.

## Install

Create a bot in Orca named `Chief of staff`, then from this folder:

```sh
BOT=$(dirname "$(grep -l '"name": "Chief of staff"' ~/.orca/bots/*/bot.json)")
cp "$BOT/SOUL.md" "$BOT/SOUL.md.bak"
cp SOUL.md "$BOT/SOUL.md"
mkdir -p "$BOT/.claude/skills/triage"
cp skills/triage/SKILL.md "$BOT/.claude/skills/triage/"
```

Then add the two automations:

```sh
orca automations create --bot "Chief of staff" --name "Morning triage" \
  --trigger "30 8 * * 1-5" --runs-in new --results-to chat \
  --prompt "$(cat examples/automation-morning.txt)"
orca automations create --bot "Chief of staff" --name "End of day" \
  --trigger "0 18 * * 1-5" --runs-in new --results-to chat \
  --prompt "$(cat examples/automation-evening.txt)"
```

It reads Linear and Granola through a connector or the MCP servers of your Claude Code. Hand-offs go to the bots named `Eng lead` and `PR shepherd` in this repo, through Orca mail.

## Standup

With `Standup: <language>` in the morning prompt, the plan ends with a Yesterday / Today / Blockers block in that language, grouped by repo and ready to paste in your team's standup. It replaces the [Daily standup notes](../standup-notes/) bot, so the same sources are not read twice each morning. Leave the line out to keep the plan alone.



## License

[MIT](../LICENSE)
