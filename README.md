# orca-pr-reviewer

[![Orca](https://img.shields.io/badge/Orca-bot-1f6feb)](https://github.com/stablyai/orca)
[![Last commit](https://img.shields.io/github/last-commit/mariano-aguero/orca-pr-reviewer)](https://github.com/mariano-aguero/orca-pr-reviewer/commits/main)
[![Mode](https://img.shields.io/badge/mode-read--only%20by%20default-lightgrey)](#install)
[![License: MIT](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Topics](https://img.shields.io/badge/verifies-mutation%20%C2%B7%20property--based%20%C2%B7%20TLA%2B-8250df)](skills/pr-review-standard/SKILL.md)

A pull request reviewer bot for [Orca](https://github.com/stablyai/orca). It reviews the PRs you are assigned to, checks the change against the task that asked for it, verifies it by running the code, and drafts inline comments that each carry a suggested fix. It stays read-only until you allow it to post.

## Files

- `SOUL.md`: who the bot is, what wakes it, what it reports and what it may never do.
- `skills/pr-review-standard/SKILL.md`: the review procedure. Gate, understanding the task, the review standard, verification scaled by risk (mutation, adversarial, property-based and model-based testing, differential testing, fault injection, small TLA+ models, Foundry fuzz and invariant tests, migration checks), finding validation, comment format, learning and re-review.

The soul stays short and stable. The procedure lives in the skill, so it can change without touching the bot's identity.

## Install

With an existing Orca bot created from the Pull request review template:

```sh
BOT=~/.orca/bots/pull-request-review
cp "$BOT/SOUL.md" "$BOT/SOUL.md.bak"
cp SOUL.md "$BOT/SOUL.md"
mkdir -p "$BOT/.claude/skills/pr-review-standard"
cp skills/pr-review-standard/SKILL.md "$BOT/.claude/skills/pr-review-standard/"
```

Then, in the bot's settings in Orca, change the `review_requested` event prompt to use `pr-review-standard` instead of `pr-review-checklist`. That prompt lives in config Orca regenerates, so edit it from the app, not on disk.

## Comment prefixes

| Prefix | Meaning |
|---|---|
| `Must:` | Blocks the merge: a bug, a security issue, data loss, or the task is not met |
| `Should:` | A real problem that does not block |
| `Nit:` | Minor, optional |
| `Optional:` | An alternative worth considering |
| `Question:` | The intent is unclear |
| `FYI:` | Context, no action needed |
| `PO:` | Personal opinion |

## References

- [Google engineering practices, the reviewer guide](https://google.github.io/eng-practices/review/reviewer/)
- [Palantir, code review best practices](https://medium.com/palantir/code-review-best-practices-19e02780015f)
- [Trail of Bits skills](https://github.com/trailofbits/skills): false-positive checks and property-based testing
- [Kent Beck, augmented coding](https://newsletter.kentbeck.com/p/augmented-coding-beyond-the-vibes)

## License

[MIT](LICENSE)
