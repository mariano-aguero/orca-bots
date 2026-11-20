# Dependabot PRs: light review

A light review, focused on the library change. Two questions: is the new version safe (supply chain), and does it break us.

Verdict, one of: Merge / Merge after a change / Wait (too young) / Do not merge (compromise signal).

## A. Is the new version safe

Nothing in this part runs install scripts: install with `--ignore-scripts` (npm, pnpm, yarn and bun all take it) until part A passes.

1. Age. `npm view <pkg> time --json`. Under 7 days since publish: verdict Wait, and stop here. Do not install it.
   Also check the repo's own gate: `minimumReleaseAge` in bunfig.toml (seconds) or pnpm-workspace.yaml (minutes), `npmMinimalAgeGate` in .yarnrc.yml, and `cooldown` in .github/dependabot.yml. Missing gate is a finding on the repo, reported once.
2. Publisher. `npm view <pkg>@<old> _npmUser` vs `@<new>`. Different publisher, or a maintainer added just before the release: red flag.
3. Provenance. Old version had a provenance attestation and the new one does not: red flag. In the worktree after an install with `--ignore-scripts`, `npm audit signatures`.
4. Published code, not GitHub. `npm diff --diff=<pkg>@<old> --diff=<pkg>@<new>` and read it. Look for:
   - new or changed preinstall / install / postinstall scripts
   - new network calls, child_process, fs writes outside the package
   - `eval(`, `new Function(`, Base64 strings that decode to URLs, minified or obfuscated new files
   - new dependencies
   Code in the tarball that is not in the GitHub tag diff: red flag.
5. Transitives. Diff the lockfile: every package added or bumped by this PR goes through steps 1 to 4, at least age and install scripts.
6. Known advisories. `npm audit` / `pnpm audit` / `bun audit` on the head, and GHSA for the new version.

GitHub Actions bumps: the action must be pinned by commit SHA, and that SHA must match the release tag. Diff action.yml and dist/ between the two refs, with the same red flags as step 4.

## B. Does it break us

1. Semver. Major, or 0.x minor: read release notes, changelog and migration guide, and list each breaking item.
2. Our usage. Grep the repo for imports of the package. For each API we use, check it against the breaking list. Only APIs we touch matter.
3. Only after part A passed, run base vs head in the worktree: frozen install, typecheck, lint, build, tests. Head must be green. Typecheck catches signature changes, tests catch behavior only where they cover our usage, so say which used APIs no test exercises.
4. Runtime-critical libraries (encoding, crypto, money: viem, ox and similar): run the calls we make on the same inputs at base and head and compare outputs.
5. Peers and engines: new peer dependency ranges or Node engine requirements against what the repo pins.
6. If the repo is a published library, check that its own exports, types and bundle do not change for consumers.

## Limits to state in the report

None of this proves there is no backdoor. The age gate is the main defense against hijacked releases. Say what was checked and what was not.
