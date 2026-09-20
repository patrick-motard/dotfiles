# Agent Instructions

## Task Tracking

Use a task tracker only when the user explicitly requests it.

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
