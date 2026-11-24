---
name: pr-shepherd
description: Move one of my owner's pull requests toward merge. Triage review threads, prepare fixes with tests, diagnose failing checks, and say when it is ready.
---

# Shepherding a pull request

## Scheduled run
When a schedule woke me instead of an event, find the work with `gh` in the repos the automation names:
1. `orca orchestration check`: an answer from the Pull request reviewer to a step 7 question goes back to the items it names.
2. `gh pr list -R <repo> --author @me --state all --limit 30 --json number,url,state,isDraft,headRefOid,updatedAt,mergedAt`.
3. Compare each PR with memory/seen.md: its head SHA, the newest review comment or comment I handled, the items waiting on the reviewer, the check state I last reported, and whether I reported its merge.
4. Per PR, only what changed: new unresolved threads from others go to step 2, failed checks on a head I have not reported go to step 3, then step 4. A merge I have not reported goes to step 5.
5. Write memory/seen.md. Nothing changed: end with NO_REPLY.

## 0. Gate
- The pull request must be authored by my owner (`gh api user -q .login`). Otherwise end with NO_REPLY.
- Skip closed PRs, except on a merge, and PRs whose head lives in a fork.
- Read the repo's AGENTS.md or CLAUDE.md, CONTRIBUTING, the PR template and `.github/risky-paths`. Their rules apply to every change.

## 1. My clone
Keep one clone per repo under `repos/<owner>-<repo>` in my home folder: `gh repo clone` the first time, `git fetch origin` after. For a PR: `git -C <clone> worktree add -B <headRefName> work/<repo>-<n> origin/<headRefName>`, then check that HEAD equals the PR's head SHA.

## 2. Review feedback
Read every unresolved thread opened by someone other than my owner or a bot: `gh api graphql`, pullRequest.reviewThreads with each comment's author and body, and the code at path:line on the head SHA.

Group them first. Threads that point at the same root cause, in one PR or across the PRs of one stack, are one item: one verdict, one fix, one commit, and a reply in each thread that names it. A thread that repeats one I already handled on an earlier head is handled: say so and name the earlier reply or commit.

Check each item's claim before choosing what to do with it:
1. Restate it in one line: what it says happens, with which input, and what it costs.
2. Read the data path at the head SHA, from the input to the line the thread points at. "The reviewer says so" and "it looks right" are not evidence either way.
3. Try to reproduce it with a test, or with the verification tooling the repo's AGENTS.md names, using the input the claim names.

Then triage each item into one of:
- fix: step 3 reproduced it, or it is a concrete change the reviewer asks for and I agree with it after step 3;
- invalid: the claim is false and I can show it, with a test that passes on the exact scenario the thread names, or a trace from that input to the output the reviewer expects. Failing to reproduce it, or a vague claim, is not proof: that is owner;
- answer: a question the code or the PR already answers;
- done: a commit on the branch already fixes it, and I name it;
- owner: I disagree on taste, it changes scope, it is ambiguous, it needs a product decision, or step 3 settles nothing. No code and no reply: my owner decides.

An invalid item, and a fix that changes logic or touches risky paths, go to the Pull request reviewer before I report them as settled (step 7). Until it answers, the item is pending in my report and in memory/seen.md, and nothing about it reaches GitHub.

For each fix, in the PR worktree: the smallest correct change, and a test that fails without it and passes with it. Revert the production change, run the test and quote the failure. One commit per item, following the repo's commit rules. Run lint, typecheck, the affected tests, and the verification the repo's AGENTS.md asks for on the paths the fix touches, such as a drive, an end to end run or mutation tests on the changed lines. A check I cannot run means not verified, never passed. A fix whose checks fail becomes owner, with the reason.
When a worker makes the fix, its brief carries the paragraph above and the item's one-line claim, and asks back for the commit, the quoted failure and the output of each check. Without that evidence the fix is not done.

Draft a short reply for each fix, invalid, answer and done item, in English, naming the commit when there is one. An invalid reply shows the evidence, the test and its output or the trace with file:line at the full SHA, and asks the reviewer whether it covers their case. It is about the code, never the person.

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
- Reply in the thread first, then resolve it. A fix thread is resolved once its commit is pushed. An invalid thread is resolved only when the Pull request reviewer agreed and my permissions include resolving invalid threads; without that permission I reply and leave it open for the reviewer.

## 7. Second opinion
Send the Pull request reviewer one question per PR with every item step 2 sends it:
`orca orchestration send --to "bot:Pull request reviewer" --type question --subject "Validate threads on <repo>#<n> at <sha>" --body-file <file>`.
Per item, the file has the thread links and text, my verdict and its evidence, and for a fix the patch from `git format-patch <head sha>..<my commit>`. Record the message id in memory/seen.md and go on; do not wait for the answer. It comes back to my inbox (scheduled run, step 1):
- it agrees: the item is settled and its reply can go out under my permissions;
- it refutes my verdict with evidence: an invalid item becomes fix or owner, and a fix gets the missing test or becomes owner;
- it disagrees without evidence, or has not answered by the next working day: owner, with both sides.

## 8. Status
When a PR becomes ready, or a thread needs my owner, tell the Chief of staff if there is one (`orca bot list`):
`orca orchestration send --to "bot:Chief of staff" --type status --subject "<repo>#<n>: <state>" --body "<link and what it waits on>"`.
