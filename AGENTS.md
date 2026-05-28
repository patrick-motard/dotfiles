# Agent Instructions

This project uses **bd** (beads) for issue tracking. Run `bd onboard` to get started.

## Quick Reference

```bash
bd ready              # Find available work
bd show <id>          # View issue details
bd update <id> --status in_progress  # Claim work
bd close <id>         # Complete work
bd vc status          # Check beads database version-control state
bd dolt push          # Push beads state when a remote is configured
```

## Landing the Plane (Session Completion)

**When ending a work session**, you MUST complete ALL steps below. Work is NOT complete until `git push` succeeds.

**MANDATORY WORKFLOW:**

1. **File issues for remaining work** - Create issues for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **PUSH TO REMOTE** - This is MANDATORY:
   ```bash
   git pull --rebase
   bd vc status
   bd dolt push       # If configured; if no remote is configured, note that explicitly
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

## Beads Command Drift Note

If `bd sync` appears in older notes or habits, do not use it. In this environment, check beads state with `bd vc status` and push with `bd dolt push` when a remote is configured. If `bd dolt push` reports that no remote is configured, record that outcome and continue with normal git push verification.

See [CLAUDE.md](./CLAUDE.md) for full project guidelines and instructions.

## Jira Wiki Markup Gotchas

When writing Jira comments or descriptions via MCP tools (`atlassian_mcp_jira_add_comment`, `atlassian_mcp_jira_edit_comment`):

- **NEVER use `#` for ordered lists.** Jira renders `#` at line start as H1 headings, not numbered lists. Use `* *Step 1*: ...` (bold labels inside bullet points) instead.
- **Bold**: Use `*text*` (single asterisk). `**text**` does NOT work — it renders as literal asterisks.
- **Headings**: Use `h1.`, `h2.`, `h3.` etc. (with a period), NOT `#`, `##`, `###`.
- **Links**: Use `[display text|https://url]`, NOT `[display text](url)`.
- **Tables**: Use `||header||header||` for header rows and `|cell|cell|` for data rows.
- **Horizontal rules**: Use `----` on its own line.
- **Code blocks**: Use `{code}...{code}` or backticks for inline code.

This is Jira wiki markup, NOT Markdown. The MCP tool does NOT auto-convert.
