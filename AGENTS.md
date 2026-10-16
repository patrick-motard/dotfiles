# Agent Instructions

## Task Tracking

Use a task tracker only when the user explicitly requests it.

## Orca Workspaces

A session cwd under `~/orca/workspaces/` (a git linked worktree; `.git` is a file, not a dir) means the session is driven by Orca. Check Orca's terminal quick commands before hand-rolling any local workflow; they encode the established setup (env sourcing, ports, service bring-up, teardown).

- Quick commands live in `~/Library/Application Support/orca/profiles/local-default/orca-data.json` under `settings.terminalQuickCommands` (read-only app state; never edit it). Entries carry `label` (user-prefixed per repo), `scope` (repo with `repoId`, or global), `action` (`terminal-command` or `agent-prompt`), and `command`/`prompt`.
- Resolve the current repo's commands: parent dir of `git rev-parse --git-common-dir` → match against `repos[].path` in the same file for the `repoId` → filter `terminalQuickCommands` by `scope.repoId`.
- Also check `/Applications/Orca.app/Contents/Resources/bin/orca agent-context --json`, Orca's agent-facing command schema (quick commands not yet included, may grow).
- Surface the relevant commands to the user and prefer them over ad-hoc equivalents, run in the user's Orca terminals or reproduced verbatim as shell commands. Hand-rolling the setup while a quick command exists caused a real incident; the existing command already carried the fix.

## Landing the Plane (Session Completion)

**When ending a work session**, you MUST complete ALL steps below. Work is NOT complete until `git push` succeeds.

**MANDATORY WORKFLOW:**

1. **Record remaining work** - Include any follow-up work in the handoff
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update an explicitly user-selected tracker** - Only when applicable
4. **PUSH TO REMOTE** - This is MANDATORY:
   ```bash
   git pull --rebase
   git push
   git status  # MUST show "up to date with origin"
   ```
5. **Clean up** - Clear stashes, prune remote branches
6. **Verify** - All changes committed AND pushed
7. **Hand off** - Provide context for next session

**CRITICAL RULES:**
- Work is NOT complete until `git push` succeeds
- NEVER stop before pushing - that leaves work stranded locally
- NEVER say "ready to push when you are" - YOU must push
- If push fails, resolve and retry until it succeeds

See [CLAUDE.md](./CLAUDE.md) for full project guidelines and instructions.
