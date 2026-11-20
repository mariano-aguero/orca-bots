# Pull request reviewer

[![Orca](https://img.shields.io/badge/Orca-bot-1f6feb)](https://github.com/stablyai/orca)
[![Last commit](https://img.shields.io/github/last-commit/mariano-aguero/orca-bots/main?path=pr-reviewer)](https://github.com/mariano-aguero/orca-bots/commits/main/pr-reviewer)
[![Mode](https://img.shields.io/badge/mode-read--only%20by%20default-lightgrey)](#install)
[![License: MIT](https://img.shields.io/badge/license-MIT-green)](../LICENSE)
[![Topics](https://img.shields.io/badge/verifies-mutation%20%C2%B7%20property--based%20%C2%B7%20TLA%2B-8250df)](skills/pr-review-standard/SKILL.md)

A pull request reviewer bot for [Orca](https://github.com/stablyai/orca). It reviews the PRs you are assigned to, checks the change against the task that asked for it, verifies it by running the code, and drafts inline comments that each carry a suggested fix. It stays read-only until you allow it to post.

## Files

- `SOUL.md`: who the bot is, what wakes it, what it reports and what it may never do.
- `skills/pr-review-standard/SKILL.md`: the review procedure. Gate, understanding the task, the review standard, verification scaled by risk (mutation, adversarial, property-based and model-based testing, differential testing, fault injection, small TLA+ models, Foundry fuzz and invariant tests, migration checks), finding validation, comment format, learning and re-review.
- `skills/pr-review-standard/rereview.md`: the re-review after new commits. Interdiff from the last reviewed SHA, each finding rechecked with the evidence that found it, and the opt-in to resolve proved threads.
- `skills/pr-review-standard/dependabot.md`: the light review for Dependabot PRs. Supply chain checks on the new version, then whether it breaks the repo.
- `skills/pr-review-standard/checkout.md`: where the PR code runs. A temporary worktree from your clone, found with `orca repo list` or in the folders the bot's memory maps to each GitHub owner.
- `examples/automation.txt`: the automation prompt.

The soul stays short and stable. The procedure lives in the skill, so it can change without touching the bot's identity. Nothing in these files names a person, an org or a path: the bot finds your clones through Orca or its memory, and acts as you through `gh`.

## Install

Create a bot in Orca named `Pull request reviewer`, then from this folder:

```sh
BOT=$(dirname "$(grep -l '"name": "Pull request reviewer"' ~/.orca/bots/*/bot.json)")
cp "$BOT/SOUL.md" "$BOT/SOUL.md.bak"
cp SOUL.md "$BOT/SOUL.md"
mkdir -p "$BOT/.claude/skills/pr-review-standard"
cp skills/pr-review-standard/*.md "$BOT/.claude/skills/pr-review-standard/"
```

The bot runs PR code in a worktree of your own clone. Register the repos you review with `orca repo add --path <path>`, or tell the bot in its chat which folder holds the clones of each GitHub owner, and it keeps that in its memory.

A bot made from Orca's Pull request review template may already have an automation and a `pr-review-checklist` skill. Check with `orca automations list`: if one exists, point it at this prompt with `orca automations edit <id> --prompt "$(cat examples/automation.txt)"` instead of creating a second one, and delete the old skill folder.

Otherwise add the automation, limited to the repos you review:

```sh
orca automations create --bot "Pull request reviewer" --name "PR reviews and re-reviews" \
  --on "github.review_requested in=your-org/your-repo" \
  --on "github.mentioned in=your-org/your-repo" \
  --on "github.pr_pushed in=your-org/your-repo" \
  --runs-in new --results-to chat \
  --prompt "$(cat examples/automation.txt)"
```

Without `in=`, every push to any open PR where the Orca GitHub app is installed starts a run. Per-PR review state goes to the bot's `memory/reviews/`, which stays on your machine.

## Resolving threads

The bot starts read-only. To let it reply to and resolve your review threads once it proved the fix, change the last line of your copy of the prompt to: "My owner allowed resolving review threads whose fix I proved, as .claude/skills/pr-review-standard/rereview.md says; that is the only thing allowed on GitHub. Never approve." It never approves.

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

[MIT](../LICENSE)
