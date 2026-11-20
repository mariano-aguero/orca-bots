---
name: standup-notes
description: Write my owner's standup notes, Yesterday / Today / Blockers, from their Orca workspaces, pull requests and Linear issues.
---

# Standup notes

Write my owner's standup notes, short, with sections Yesterday / Today / Blockers. Yesterday means the previous working day (on Monday, cover Friday through Sunday).

Sources:
- Orca workspaces and their agents: `orca worktree ps --since 3d`.
- GitHub pull requests authored by my owner that were merged or opened in that window, and pull requests awaiting their review: `gh search prs` with `@me`; paginate past 30 results. When the automation names GitHub owners, search only those.
- Linear issues assigned to my owner that were created, moved or completed in that window. When the automation names Linear teams, keep only those.

Group by repo. Write in the language the automation names, else my owner's language.

Read only: change nothing anywhere.
