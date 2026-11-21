---
name: triage
description: Build my owner's daily plan from Linear, GitHub, Granola and the other bots' mail, with a standup to paste when asked, and hand approved work to the bot that owns it.
---

# Triage

## Morning
1. Collect what changed since my last report (memory/last-run.md; on the first run, the last 3 days):
   - Linear issues assigned to my owner that are not done: state, priority, cycle, and when they were assigned. Mark the new ones.
   - Pull requests waiting on my owner's review: `gh search prs --review-requested=@me --state=open`, with their age.
   - My owner's open pull requests: `gh search prs --author=@me --state=open`, with checks, review state and age.
   - Next steps from my owner's Granola meetings since the last run that name them or have no owner.
   - Mail from other bots: `orca orchestration check`.
   - Only when the automation asks for a standup: my owner's Orca workspaces and their agents (`orca worktree ps --since 3d`), and the pull requests they merged or opened in the standup window.
   When the automation names GitHub owners or Linear teams, keep only those.
2. Write the plan:
   - Today: at most 5 items. First what blocks someone else (reviews others wait on, own PRs with changes requested), then issues in the current cycle by priority.
   - Hand-offs I propose: the item, the bot, and why.
   - Meeting next steps with no Linear issue: the issue text I would create.
   - Waiting on others, with how long.
   - Everything else, counted, not listed.
   - Standup, only when the automation asks for one with `Standup: <language>`: a block my owner can paste as is, in that language, with Yesterday / Today / Blockers grouped by repo. Yesterday is the previous working day; on Monday it covers Friday through Sunday. Today comes from the plan above. Blockers are what waits on someone else. No hand-offs, bot names or internal notes in it.
3. Save what I reported to memory/last-run.md.

## When my owner answers
- An OK for some or all proposed hand-offs: send each one with `orca orchestration send --to "bot:<name>" --type handoff --subject "<item>" --body "<link, what done looks like, limits>"`, and confirm each one here.
- An OK for a meeting next step: create the Linear issue with the approved text, assigned to my owner, and give the link.
- Anything else: answer, and change nothing.

## Evening
Read the bots' mail first. Then: what moved today (merged, closed, handed off and where it stands), what is stuck and on whom, and what carries to tomorrow.
