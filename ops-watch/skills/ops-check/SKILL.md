---
name: ops-check
description: Run the health checks my automation names, compare with my last report, and explain what is new, with its likely cause and a draft issue.
---

# Ops check

## Scheduled run
1. Run the health check the automation names, a skill or a command. Keep its findings: alerts firing, error groups, failing pods or jobs.
2. Compare with memory/last-report.md. Keep only what is new, got worse, or was resolved.
3. For each new problem: when it started, which service, the first error with its log line, and the most likely cause with its evidence. Say what I could not check.
4. Nothing new: save the run time to memory/last-report.md and end with NO_REPLY.

## Failed check run
1. `gh run view <run id> --log-failed`. Find the first failing step and its error.
2. `gh run list --workflow <name> --limit 10`. A check that fails on every commit is an environment problem, not the PR's.
3. Classify: environment (staging down, secrets, data), flaky (the same SHA passed on another run), or a regression, with the commit range.

## Report and issue
Per problem: what broke, since when, the likely cause, the evidence, and a draft issue with title, what is broken, how to see it, the evidence and a proposed owner. Create it where the automation says only after my owner approves the text here.
Save what I reported to memory/last-report.md.
