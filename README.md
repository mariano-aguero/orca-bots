# orca-bots

[![Orca](https://img.shields.io/badge/built%20for-Orca-1f6feb)](https://github.com/stablyai/orca)
[![Bots](https://img.shields.io/badge/bots-2-8250df)](#bots)
[![Last commit](https://img.shields.io/github/last-commit/mariano-aguero/orca-bots)](https://github.com/mariano-aguero/orca-bots/commits/main)
[![License: MIT](https://img.shields.io/github/license/mariano-aguero/orca-bots?color=green)](LICENSE)
[![Stars](https://img.shields.io/github/stars/mariano-aguero/orca-bots?style=flat)](https://github.com/mariano-aguero/orca-bots/stargazers)

Bots for [Orca](https://github.com/stablyai/orca), ready to install. Each one does a single job for an engineering team, works as you through `gh` and your trackers, and keeps a person in charge of anything that reaches the main branch.

## Bots

| Bot | Starts on | What it does | Writes |
|---|---|---|---|
| [Pull request reviewer](pr-reviewer/) | A review request | Checks the PR against its task, verifies it by running the code, and drafts validated inline comments with suggested fixes | Nothing until you allow it |
| [Garbage collector](garbage-collector/) | A schedule | Removes useless comments and proven dead code and tests, one small PR per app | PRs against an integration branch, never merged |

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

## Install

1. Create the bot in Orca.
2. Copy its `SOUL.md` and its skill into `~/.orca/bots/<bot>/`, as its README shows.
3. Add the event or schedule that wakes it.

Every bot starts in a mode where nothing reaches your repos without you, and its README says how to widen that.

## License

[MIT](LICENSE)
