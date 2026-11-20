---
name: pr-review-standard
description: Review a pull request against its original task and the team standard, verify by running it, validate every finding, and draft inline comments that each carry a suggested fix.
---

# Reviewing a pull request

## 0. Gate
- On a first review of a PR opened by Dependabot, use the light review in `dependabot.md` in this folder instead of this procedure.
- Skip drafts, closed PRs and PRs already reviewed at the same head SHA. If there are new commits, go to re-review (step 7).
- Read the issue or ticket behind the PR (GitHub, Linear), the repo's agent instructions (AGENTS.md and similar), the PR template, `.github/risky-paths` and CODEOWNERS.
- Read existing comments, from people and bots, only after your own pass, so they do not steer it.

## 1. Understand before judging
- Summarize in two lines what the task asks and what the diff does. If they differ, that is the first finding. If there is no issue, say so and take the PR description as the intent.
- Rate the risk: money, keys, auth, migrations, public contracts, risky-paths. The risk decides how much verification step 3 runs.
- Audit the author's own verification: what they ran, on which SHA, with what evidence.

## 2. Review against the standard
Give two separate verdicts and never merge them: Task (does what was asked) and Standard (follows the repo and team rules).

Intent and scope
- Does what the task asked, no less and no more. Every task finding quotes the line of the issue it relies on.
- Agent signals: features nobody asked for, even reasonable ones, side refactors, files touched in passing, changes that go back and forth across commits.
- Every claim in the description ("tested", "handles X", "no breaking changes") has evidence behind it.
- A PR over about 1000 lines, or one that mixes a refactor with a feature: suggest splitting it.

Design and code health
- Fits where it lives and follows the repo's current patterns, not the legacy ones that happened to sit nearby.
- Reuses what exists. A helper or type that duplicates one already in the repo under another name is a finding.
- No abstraction for a single case, no layers, wrappers or config added just in case.
- No defensive code against impossible states: try/catch that swallows errors, fallbacks that hide failures (`?? 0`, `|| []`, `catch { return null }`).
- No dead code, unused imports, or the old variant left next to the new one.
- No test-only methods in production code.
- Readable in one pass without the author explaining it. If I cannot follow it, ask for the code to be made clearer, not only the thread.

Correctness
- Every API, method, flag or option exists in the installed version. Check it against the dependency's source or types.
- Edges: null or undefined, empty, limits, units and decimals, time zones, concurrency, retries, idempotency.
- Errors propagate with useful information instead of being logged and dropped.

Tests
- They test observable behavior, written from what the task asks. Expected values come from the requirement, not from the code under test.
- No tautological assertions, no assertions on the mock, no mocks of the project's own modules (mock only at system boundaries), no snapshots accepted blindly.
- An assertion that something never happens comes with a case where it does.
- No test was weakened to pass: loosened assertions, changed expected values, `skip`, `only`, a removed `it.fails`, inflated timeouts. Compare against the previous version of the test.
- No check was turned off to pass: `@ts-ignore`, `eslint-disable`, `any`, lowered thresholds, removed CI steps.
- In risky-paths, a changed function with no test is a `Must`.

Documentation and comments
- Docs, types, README or AGENTS.md that the change invalidates are updated.
- Comments explain why, and there are few. Flag comments that narrate the line below, commented-out code, banners, and leftovers from a conversation with an agent ("now we", "updated to", "as requested").
- No AI tool files committed (`.claude/`, `.cursor/`, plans, session notes).

Compatibility, security and dependencies
- APIs, wire contracts, schemas and events: the change is additive, or the break is declared.
- Migrations are reversible, run in the right order, and are safe with existing data.
- Unvalidated input, secrets in code or logs, permissions or scopes that widen.
- If the code passes outside text to a model or a tool: prompt injection, and what the model can do with what it receives.
- Every new package exists, is the one intended (not a lookalike name), is maintained and respects the repo's minimum release age. On a version bump, read the changelog and the lockfile diff.

Pre-mortem
- Assume the change caused an incident two weeks after merge. Name the three most likely causes, each with file:line and the test that would have caught it. A cause with no test covering it is a finding.

## 3. Verify by running it, scaled by risk
Always
- Build and test the affected project in a clean worktree of the PR head, made as `checkout.md` in this folder says. Record the SHA.
- Every new or changed test must fail without the fix: revert the production change, run the test and quote the failure.

When the PR adds or changes logic (calculations, validation, permissions, state)
- Mutation testing on the changed lines. A surviving mutant in new logic is a missing test.
- Two-sided test check: break the behavior and the test fails; refactor the internals and it still passes.
- Adversarial: write the most wrong implementation that still passes the new tests. Every behavior it breaks unnoticed is a finding.
- Property-based testing on pure functions with a clear invariant: roundtrip, idempotency, monotonicity, bounds, conservation of amounts.
- Model-based stateful testing (`fc.commands` in fast-check, or the stack's equivalent) when the logic keeps state across calls: budgets, balances, sessions, connections. Generate sequences of operations and check an invariant after each one, such as "spend never exceeds the budget".

When the PR is a refactor, or replaces a library or an implementation
- Differential testing: run the base SHA and the PR head on the same inputs, generated or recorded, and compare the outputs. Any difference the PR does not declare is a finding.

When the PR touches network calls, sockets, queues or external APIs
- Fault injection on the edge the change touches: drop the connection mid-flow, return timeouts, partial or malformed responses, and duplicate deliveries. Check that the state stays consistent and the error reaches the caller.

When the PR touches concurrency, retries, locks, queues or a state machine
- A small TLA+ model or an interleaving test, only when the invariant fits in one line.
- A pass counts only if the model catches a planted mutation. Label every counterexample as reproduced, reachable with the shipped config, or model only.

When the PR changes a Solidity contract
- Foundry fuzz and invariant tests on the changed functions: properties per function, and invariants over random call sequences, such as "total supply equals the sum of balances" or "only the owner can move funds".

When the PR changes the database schema
- Run the migration up and down against representative data, and check that the code at both the base SHA and the PR head works with the migrated schema.

When the PR changes visible behavior (UI, CLI, endpoint)
- Run it with the repo's verification tooling, through the real user path, forcing the edge the change touches. Keep the evidence: output, screenshot, request and response.

Rules
- A tool that is not available means not verified. It never counts as a pass.
- When a check fails, suspect the way it was observed before the system.
- Nothing gets committed. Patches and worktrees are deleted; the evidence is kept.

## 4. Validate every finding
1. Restate the finding in one line: what it claims, what triggers it, what it costs. If it does not fit in one precise line, drop it.
2. Trace the full data path. "Looks dangerous" or "similar code had a bug" is not evidence.
3. Require evidence: a failing test, a surviving mutant, a counterexample, or a trace from input to wrong output.
4. Blind refuter: another model gets the diff, the task and the commit range, never my conclusion, and tries to refute the finding. If it does, drop it. If two models found it independently, confidence goes up.
5. Confidence from 0 to 100. Post only at 80 or above. Anything below goes to the report as a doubt, not to GitHub.
6. Classify it: valid, task misread, accepted trade-off, or noise.

Drop it when:
- It is not on lines the PR adds or changes, unless the PR makes it worse. Pre-existing issues go to the report as a note, not inline.
- The change is intentional and the author shows they know the consequences.
- It is silenced on purpose in the code, with a reason.
- It depends on an input or state I cannot name.
- It claims the change may break something elsewhere without naming the affected code. That becomes a `Question`.
- It amounts to "I would have done it differently".
- CI already catches it (lint, typecheck, formatter).
- The author would not fix it, because it asks for more rigor than the rest of the repo has.
- Someone else, another bot, or I in an earlier review already raised it. If others raised it, say so.
- A later commit in the same PR fixes it.

A finding based on AGENTS.md or a similar rules file quotes the rule verbatim, with file and line, and confirms it applies to that path.
Findings with the same root cause are merged into one.

## 5. Write
Inline comments, in English, one paragraph each, no limit on count, ordered by severity:
- Prefix: `Must:` blocks (bug, security, data loss, the task is not met). `Should:` real problem that does not block. `Nit:` minor. `Optional:` an alternative worth considering. `Question:` the intent is unclear to me. `FYI:` context, no action needed. `PO:` personal opinion.
- What happens, with which input or scenario, and a suggested fix. Do not overstate the severity.
- A `suggestion` block only when applying it fixes the whole issue; otherwise describe the fix. Ten lines at most.
- Links use the full SHA and a line range.
- Phrase it as a question or a proposal ("should we...?", "what do you think about...?"). Neutral wording: "this function", never "your code". About the code, never about the person.
- No long dashes, no bold in prose, no superlatives, no hedging ("probably", "seems"), no mention of AI tools.

Summary comment, short:
- The Task verdict and the Standard verdict, one line each.
- What I verified and on which SHA, and what I could not verify and why.
- Whether I want to re-review after the changes.
- Something done well, if there is something specific.

If no finding survives, say so, along with the verification that backs that result.

## 6. Learn
- After merge or close, record in the bot's memory which comments were resolved, rejected or ignored.
- Ignored and rejected comments count as likely false positives. Lower the weight of the rule that produced them, and retire it if it keeps happening.
- Anything a person caught that I missed becomes a rule candidate.
- When the same finding shows up in three PRs, propose to my owner turning it into a check: a lint rule, a type, a test or an API that makes it impossible.

## 7. Re-review
On new commits, follow `rereview.md` in this folder: review only the diff since my last review, prove each fix with the evidence that found it, and do not repeat what is still open.
