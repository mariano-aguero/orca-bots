# Ops watch

[![Orca](https://img.shields.io/badge/Orca-bot-1f6feb)](https://github.com/stablyai/orca)
[![Last commit](https://img.shields.io/github/last-commit/mariano-aguero/orca-bots/main?path=ops-watch)](https://github.com/mariano-aguero/orca-bots/commits/main/ops-watch)
[![Mode](https://img.shields.io/badge/mode-read%20only-lightgrey)](#install)
[![Trigger](https://img.shields.io/badge/trigger-schedule%20and%20checks-8250df)](#install)
[![License: MIT](https://img.shields.io/badge/license-MIT-green)](../LICENSE)

An Orca bot that runs your health checks on a schedule and reads failed check runs, such as a staging smoke test. It reports only what is new since its last report, with the likely cause and its evidence, and drafts the issue to fix it. It creates the issue after you approve the text, and never restarts, rolls back or reruns anything.

## Files

- `SOUL.md`: who the bot is, what wakes it and what it may never do.
- `skills/ops-check/SKILL.md`: the procedure. Scheduled run, failed check run, report and issue.
- `examples/automation-schedule.txt` and `examples/automation-check.txt`: the automation prompts.

## Install

Create a bot in Orca named `Ops watch`, then from this folder:

```sh
BOT=$(dirname "$(grep -l '"name": "Ops watch"' ~/.orca/bots/*/bot.json)")
cp "$BOT/SOUL.md" "$BOT/SOUL.md.bak"
cp SOUL.md "$BOT/SOUL.md"
mkdir -p "$BOT/.claude/skills/ops-check"
cp skills/ops-check/SKILL.md "$BOT/.claude/skills/ops-check/"
```

Name your health check in `examples/automation-schedule.txt`, a skill or a command, then add the automations. The second one needs GitHub connected to the bot:

```sh
orca automations create --bot "Ops watch" --name "Ops health" \
  --trigger "0 9,13,17 * * 1-5" --runs-in new --results-to chat \
  --prompt "$(cat examples/automation-schedule.txt)"
orca automations create --bot "Ops watch" --name "Smoke test failed" \
  --on "github.ci_failed in=your-org/your-repo contains=smoke" \
  --runs-in new --results-to chat \
  --prompt "$(cat examples/automation-check.txt)"
```



## License

[MIT](../LICENSE)
