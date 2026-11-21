---
name: pr-backlog
description: Triage the open pull requests nobody is moving in the repos the automation names, propose a merge, review, rebase or close for each, and carry out only what my owner says yes to.
---

# Triaging the PR backlog

The automation prompt gives `repos`, `stale_days`, `close_days` and `min_release_age`; SOUL.md lists their defaults.

## 1. Collect
Per repo:
1. `gh pr list -R <repo> --state open --limit 100 --json number,title,url,author,isDraft,createdAt,updatedAt,mergeable,reviewDecision,headRefName,baseRefName,labels,files`.
2. Keep every PR whose author is a dependency bot (renovate, dependabot), and any other with no activity in `stale_days`.
3. Read the repo's `.github/risky-paths` and AGENTS.md or CLAUDE.md on the base branch. Their rules apply.

## 2. Read each PR
- Checks: `gh pr checks <n> -R <repo>`.
- Conflicts and whether it is behind its base: `mergeable` and `gh api repos/<repo>/compare/<base>...<head>`.
- Unresolved review threads: `gh api graphql`, pullRequest.reviewThreads with isResolved and each comment's author.
- Requested reviewers, and how long the request has waited.
- Risky paths: any file that matches a glob in `.github/risky-paths`.
- Superseded: a newer open or merged PR that does the same, such as a later bump of the same dependency or the same branch reopened.
- For a dependency bump: the version jump (major, minor, patch), the release date of the new version (`npm view <pkg>@<version> time` or the GitHub release), and the breaking changes in its release notes.

## 3. Decide
One action per PR, the first that fits:
- **close**: superseded, or no activity in `close_days` and it has conflicts or failing checks, or a draft with no activity in `close_days`. Draft the closing comment: one or two lines on why, and the PR that replaces it when there is one.
- **rebase**: conflicts or behind its base, and otherwise in good shape. Name who: the author, or "PR shepherd" when my owner authored it.
- **review**: waiting on a review. Name the requested reviewers and how long it has waited. A risky path always lands here until a person reviewed it, whatever else is true.
- **merge**: checks green, not a draft, mergeable, no unresolved threads, approved or no approval required by the branch rules, and no risky path. A dependency bump also needs a new version public for `min_release_age` days, and no breaking change that touches our code (cite file:line when it does). A major bump goes to review with its breaking changes listed.
- **wait**: none of the above, for example checks still running. Say what it waits on.

Compare with `memory/backlog.md`: a PR I recommended the same action for last run says so ("2nd week"), so my owner sees what keeps sliding.

## 4. Report
Here, in my owner's language, grouped by action, one line per PR:
`<repo>#<n> <title>: <action>. <why, in a few words>. <age> days, last activity <days> ago.`
Put the drafted closing comments under the list. End with: "Answer with the PRs to merge or close."

Write `memory/backlog.md`: per PR, the date and the action recommended. Nothing in the list: end with NO_REPLY.

## 5. On a yes
Only for the PRs my owner named in this chat, and only if each still passes the rules of step 3 and SOUL.md's Never list at that moment:
- merge: `gh pr merge <n> -R <repo>` with the merge method the repo allows (`gh repo view <repo> --json mergeCommitAllowed,squashMergeAllowed,rebaseMergeAllowed`; prefer squash when several are allowed).
- close: `gh pr close <n> -R <repo> --comment "<the drafted comment>"`.
Report what was done, with links, and any PR I skipped because it no longer qualified.

## Writing rules
- Comments on GitHub are in English, short, with no local paths and no em or en dashes.
