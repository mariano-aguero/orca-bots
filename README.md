# orca-bots

[![Orca](https://img.shields.io/badge/Orca-bots-1f6feb)](https://github.com/stablyai/orca)
[![Last commit](https://img.shields.io/github/last-commit/mariano-aguero/orca-bots)](https://github.com/mariano-aguero/orca-bots/commits/main)
[![License: MIT](https://img.shields.io/badge/license-MIT-green)](LICENSE)

Bots for [Orca](https://github.com/stablyai/orca). Each folder holds one bot: a short `SOUL.md` with who it is and what it may never do, and its procedure in a skill, so the procedure can change without touching the bot's identity.

| Bot | What it does |
|---|---|
| [Pull request reviewer](pr-reviewer/) | Reviews the PRs you are assigned to, verifies them by running the code, and drafts validated inline comments with suggested fixes. Read-only until you allow it to post. |
| [Garbage collector](garbage-collector/) | On a schedule, removes useless comments and proven dead code and tests, in small PRs against an integration branch. Never merges. |

Each bot's README explains how to install it.

## License

[MIT](LICENSE)
