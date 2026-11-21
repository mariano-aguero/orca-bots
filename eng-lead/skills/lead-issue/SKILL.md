---
name: lead-issue
description: Plan an issue, get my owner's OK, run a writer and a verifier worker, and end with a draft pull request.
---

# Leading an issue

## 1. Understand
Read the issue and its comments, then the repo's AGENTS.md or CLAUDE.md, CONTRIBUTING, PR template and `.github/risky-paths`. Find the repo with `orca repo list`; if it is not there, ask my owner.

## 2. Plan, then stop
Send my owner, here:
- Goal: one sentence, in my words.
- Done when: checks a person can run, such as a test, a command and its output, or a page that shows something.
- Steps, and the files each one touches.
- Risk: risky paths, migrations, public contracts the plan touches.
- Out of scope: what I will not do.
- Questions, if any.
Then stop. Nothing starts without an OK.

## 3. Writer
On OK, write the brief to a file: the approved plan, the repo rules, the commit rules (the repo's, or conventional commits with a short subject and no body), and "open a draft PR that fills every section of the PR template, and tick only what you verified". Start one worker:
`orca orchestration worker-start --spec-file <brief> --worktree new-child --repo <selector> --base-branch <base> --agent claude --model <writer model> --task-title "<issue key>: <title>"`
Follow it with `orca orchestration worker-show` and my mail. Answer its questions from the plan. What the plan does not answer goes to my owner.

## 4. Verifier
When the writer reports its PR, start a second worker on the PR branch, on a different model than the writer, with this brief. It changes nothing.
- Run each "Done when" check and report pass or fail with its evidence: the command and its output.
- Review the diff against the repo's rules.
- Check each claim the writer made, in its report and in the PR description, against the diff and the test output. A claim with no evidence there, such as a test said to pass that never ran, a file said to change that did not, or a box ticked for something not run, fails.
- Name any file the diff touches that the plan did not list.

A failure goes back to the writer with the verifier's evidence, and I send the same verifier worker back to check the new commits, so the issue still uses two workers. Two rounds at most: a failure after the second goes to my owner, with what still fails.

## 5. Report
To my owner: the draft PR link, each "Done when" check with its evidence, the writer's claims the verifier could not back, files outside the plan, how many verifier rounds ran, and what is left.
To the Chief of staff, if there is one (`orca bot list`): `orca orchestration send --to "bot:Chief of staff" --type status --subject "<issue key>: <state>" --body "<link and what it waits on>"`.

## Models
The automation or my memory names the writer and verifier models. Without that, the writer uses my own model and the verifier another one I have.
