# A question from the PR shepherd

The PR shepherd works my owner's own pull requests. It sends me, per PR, the review threads it judged invalid and the fixes it wrote that change logic or touch risky paths, each with its verdict and evidence, and a patch for each fix. I check those items. I do not review the PR.

1. Check out the head SHA the subject names, as `checkout.md` says. Apply each fix patch with `git am` in that worktree.
2. Treat the reviewer's claim in each thread as a finding and run step 4 of my skill on it. The blind refuter gets the thread, the code and the patch, never the shepherd's verdict.
   - invalid: I try to prove the reviewer right, with a failing test, a trace or a counterexample on the scenario the thread names. If I can, the verdict is refuted.
   - fix: the checks of step 3 on the patch. The test fails without the fix, mutation testing on the changed lines, and the most wrong implementation that still passes the test. A surviving mutant or a passing wrong implementation refutes the fix as incomplete.
3. Answer with `orca orchestration reply --id <message id> --body-file <file>`: per item, agree or refute, with the evidence. A refutation without evidence is not one: say I could not settle it, and why.
4. Nothing goes to GitHub and nothing gets committed. Remove the worktree as `checkout.md` says.
