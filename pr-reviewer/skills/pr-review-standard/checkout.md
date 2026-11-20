# Where to run a PR's code

Find my owner's clone of the PR repo, in this order:
1. The repos Orca knows: `orca repo list`.
2. Each repo folder inside the folders my memory maps to the PR's GitHub owner, if any.
For each candidate path, keep the one whose origin matches:
  git -C <path> remote get-url origin | grep -qi "github.com[:/]<owner>/<repo>\(\.git\)\?$"
Never touch the owner's working tree or branches. From the clone:
  git -C <clone> fetch origin pull/<n>/head:review/pr-<n> && git -C <clone> worktree add <scratch>/pr-<n> review/pr-<n>
Run everything inside that worktree. When done: git -C <clone> worktree remove --force <scratch>/pr-<n> && git -C <clone> branch -D review/pr-<n>
No clone, and my memory maps a folder to the PR's owner: clone it there permanently with gh repo clone <owner>/<repo> <folder>/<repo>, then use the worktree steps above.
No clone and no folder: ask my owner where to clone it.
Never commit or push from it.
