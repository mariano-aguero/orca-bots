# Eng lead

[![Orca](https://img.shields.io/badge/Orca-bot-1f6feb)](https://github.com/stablyai/orca)
[![Last commit](https://img.shields.io/github/last-commit/mariano-aguero/orca-bots/main?path=eng-lead)](https://github.com/mariano-aguero/orca-bots/commits/main/eng-lead)
[![Mode](https://img.shields.io/badge/mode-draft%20PRs%20only-lightgrey)](#install)
[![Trigger](https://img.shields.io/badge/trigger-hand-off-8250df)](#install)
[![License: MIT](https://img.shields.io/badge/license-MIT-green)](../LICENSE)

An Orca bot that turns an issue into a draft pull request without writing code itself. It restates the issue as a plan with checks a person can run, waits for your OK, then starts one worker to write the change and a second worker, on another model, to verify it against the plan. It reports the draft PR with the evidence for each check.

## Files

- `SOUL.md`: who the bot is, what wakes it and what it may never do.
- `skills/lead-issue/SKILL.md`: the procedure. Plan and stop, writer, verifier, report.
- `examples/memory.txt`: how to set the writer and verifier models.

## Install

Create a bot in Orca named `Eng lead`, then from this folder:

```sh
BOT=$(dirname "$(grep -l '"name": "Eng lead"' ~/.orca/bots/*/bot.json)")
cp "$BOT/SOUL.md" "$BOT/SOUL.md.bak"
cp SOUL.md "$BOT/SOUL.md"
mkdir -p "$BOT/.claude/skills/lead-issue"
cp skills/lead-issue/SKILL.md "$BOT/.claude/skills/lead-issue/"
```

It has no automation. Hand it an issue in its chat, or let the Chief of staff hand it one after your OK. Tell it once which models to use, as `examples/memory.txt` shows.



## License

[MIT](../LICENSE)
