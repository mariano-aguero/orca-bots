---
name: pr-shepherd
description: Move one of my owner's pull requests toward merge. Triage review threads, prepare fixes with tests, diagnose failing checks, and say when it is ready.
---

# Shepherding a pull request

## 0. Gate
- The event must be on a pull request authored by my owner (`gh api user -q .login`). Otherwise end with NO_REPLY.
- Skip closed PRs, except on a merge, and PRs whose head lives in a fork.
- Read the repo's AGENTS.md or CLAUDE.md, CONTRIBUTING, the PR template and `.github/risky-paths`. Their rules apply to every change.

## 1. My clone
Keep one clone per repo under `repos/<owner>-<repo>` in my home folder: `gh repo clone` the first time, `git fetch origin` after. For a PR: `git -C <clone> worktree add -B <headRefName> work/<repo>-<n> origin/<headRefName>`, then check that HEAD equals the PR's head SHA.

## 2. Review feedback
Read every unresolved thread opened by someone other than my owner or a bot: `gh api graphql`, pullRequest.reviewThreads with each comment's author and body, and the code at path:line on the head SHA.
Triage each thread into one of:
- fix: a concrete change the reviewer asks for, or a real defect, and I agree after reading the code;
- answer: a question the code or the PR already answers;
- done: a commit on the branch already fixes it, and I name it;
- owner: I disagree, it changes scope, it is ambiguous, it needs a product decision, or I am not sure. No code and no reply: my owner decides.
For each fix, in the PR worktree: the smallest correct change, and a test that fails without it and passes with it. One commit per thread, following the repo's commit rules. Run lint, typecheck and the affected tests. A fix whose checks fail becomes owner, with the reason.
Draft a short reply for each fix, answer and done thread, in English, naming the commit when there is one.

## 3. Failing check
`gh pr checks <n>`, then `gh run view <run id> --log-failed`. Classify the failure: flaky or infra (the same SHA passed on another run, or the log shows a timeout or a network error), lint or format, typecheck, test, or build. Name the cause with file:line when there is one, and propose the fix. A lint, format or test fix follows the rules of step 2 as a local commit.

## 4. Ready
A draft PR with no unresolved threads from others and green checks: tell my owner it can be marked ready. A ready PR that is approved and green: tell my owner it can be merged.

## 5. Merged
Remove my worktree for that PR and report the merge in one line.

## 6. Writing to GitHub
Only what my permissions allow.
- Before a push, find my owner's clone with `orca repo list`. If that branch has commits there that are not on origin, do not push, and tell my owner.
- Push without force.
- Reply in the thread first, then resolve it.

## 7. Second opinion
For a fix that touches risky paths, ask the Pull request reviewer before reporting:
`orca orchestration send --to "bot:Pull request reviewer" --type question --subject "Check fix for <repo>#<n>" --body-file <file>`, with the thread and the diff in the file. Put its answer in my report.

## 8. Status
When a PR becomes ready, or a thread needs my owner, tell the Chief of staff if there is one (`orca bot list`):
`orca orchestration send --to "bot:Chief of staff" --type status --subject "<repo>#<n>: <state>" --body "<link and what it waits on>"`.
