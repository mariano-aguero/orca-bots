---
name: cleanup
description: Remove comments that carry nothing and code and tests proven obsolete from one repo, verify the result, and open small PRs against an integration branch.
---

# Cleaning up a repo

The automation prompt gives the settings `repo`, `base`, `risky`, `issues` and `max_prs`; SOUL.md lists their defaults.

A run ends when the turn ends. Use subagents where they help (for example one per app for the audit), but wait for each one to finish before ending the turn, and run them on the same model as the bot.

## 0. Setup

1. `orca worktree create --name "gc-<repo name>-<date>" --repo id:<orca repo id> --base-branch origin/<base> --parent-worktree current --json`, then work in its path.
2. Create the run's integration branch `chore/gc-<date>` from `origin/<base>` and push it. Every PR of the run branches from it and targets it, never `base`.
3. Install with the repo's package manager.
4. Read the repo's AGENTS.md or CLAUDE.md and follow it.

## 1. Scope

LAST is the merge date of the newest merged PR whose title contains "remove comment slop" or "remove dead code". Scope is:

- every source file changed on `origin/<base>` since LAST (skip this part when there is no LAST), plus
- the one app or package with the most comment lines that has had no cleanup PR in the last 90 days.

First list open PRs with those titles and open issues titled "[<repo name>]". Drop any file an open cleanup PR already touches, or that a previous `chore/gc-*` branch not yet merged into `base` changed. Skip generated files, vendored code, lockfiles, fixtures and applied migrations.

## 2. Comments

Classify each comment in scope.

- **Keep:** TODO and FIXME, license headers, lint or type directives with a reason, and any comment that says something the code does not and is still true: a constraint, a provider quirk, why an obvious alternative is wrong, an invariant. When in doubt, keep.
- **Delete:** tautologies that restate the next line, stale comments, commented-out code, section banners, ceremonial docblocks on obvious functions.
- **Excuse** (HACK, or a comment that justifies a workaround): delete it and file an issue titled "[<repo name>] ..." with file:line where `issues` says. Search first and reuse an open match.

Before deleting a comment that states a constraint, check whether a test or a type already encodes it. If not, keep it.

## 3. Dead code and tests

Remove code only when it is proven unused:

- no references, by grep and by the type checker;
- not in a published package's public API;
- not referenced by config, scripts, CI, routes, or DI, decorator or cron wiring.

Remove a test only when it tests removed code, duplicates another test, or asserts nothing.

On a real bug: outside `risky`, fix it in its own PR with a test that fails before the fix; inside `risky`, only file an issue with the failing case. Stay above the repo's coverage thresholds.

## 4. PRs

- One per app or package per kind: `chore(<scope>): remove comment slop` and `chore(<scope>): remove dead code`.
- Anything under `risky` goes in its own PR that asks for a human review of each hunk and says the repo's manual verification was not run.
- At most `max_prs` PRs per run. The rest waits for the next run.
- No reformatting: the diff shows only the removal.

## 5. Verify

Before opening each PR, run lint, typecheck, test and build for the affected projects. If checks fail, do not open the PR, and say why in the report.

## 6. Clean up

Remove the run's worktree once its branches are pushed.

## Writing rules

- Commits, PRs and issues are in English.
- Commits: conventional commit subject only, at most 10 words, no body.
- If the repo has `.github/PULL_REQUEST_TEMPLATE.md`, fill every section in order, N/A where it does not apply. Tick only what was verified. Leave any AI-usage section unticked.
- PR description: what was removed, what was kept on purpose, issues filed, follow-ups found but not done.
- No em or en dashes. No local paths (`~/`, `/Users/`) in PRs or issues.
