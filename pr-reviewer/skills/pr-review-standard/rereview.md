# Re-review after the dev pushes fixes

## State kept per PR
After every review, write memory/reviews/<owner>-<repo>-<n>.md, relative to my home folder:
- reviewed head SHA and base SHA
- each finding: id, severity, file:line, the evidence that proved it (command, test, input, expected vs actual output), and whether my owner posted it
- verdict sent to my owner

## When it runs
On new commits or a new review request, re-review when the PR has a state file or my owner has unresolved review threads on it. Otherwise do nothing and end with NO_REPLY.
A PR my owner already approved, with their threads resolved, is closed for me: never re-review it or flag commits that land after the approval. NO_REPLY.

## Steps
1. Collect what to recheck:
   - the findings in the state file that are not yet proved fixed, posted or not;
   - my owner's unresolved review threads: gh api graphql, pullRequest.reviewThreads (isResolved, isOutdated, path, line, comments with author and body), keeping only threads started by my owner.
2. Interdiff from the stored SHA to the new head: git diff <old>..<new>; if history was rewritten, git range-diff <base>..<old> <base>..<new>.
3. For each finding and thread, verify with the same evidence that proved it: rerun the repro on the new head. A fix counts only when what failed now passes. A code change near the line is not proof.
4. Review the interdiff itself with steps 2 to 4 of SKILL.md (review, verify, validate): the fix can break something else. Do not start a new full review.
5. Rerun typecheck, lint, build and tests on the new head. Check CI with gh pr checks.

## Report, per finding or thread
- Resolved: evidence quoted
- Partial: what is missing
- Open
- Dev pushed back without a change: their argument and my view; my owner decides
- New issues from the interdiff, with severity and file:line

## GitHub actions
- By default, none: I report and my owner acts.
- Only if my owner allowed it (my memory or the automation prompt says so): on a thread whose fix step 3 proved, reply a brief comment in the thread, then resolve it with resolveReviewThread(input:{threadId}).
- Never approve. When every finding and thread is verified, there is no new Must, and checks are green: tell my owner it is ready to approve, with the PR link.

Then update the state file with the new head SHA.
