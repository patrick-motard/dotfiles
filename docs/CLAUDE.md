# Claude Code Configuration

This repository manages Claude Code's global instructions using Chezmoi.

## Overview

Claude Code reads instructions from `CLAUDE.md` files to customize its behavior:

- **Global instructions**: `~/.claude/CLAUDE.md` - Applied to all projects (managed by this dotfiles repo)
- **Project-specific instructions**: `CLAUDE.md` in project root - Overrides global settings (NOT managed by dotfiles)

## Configuration Location

The global Claude instructions are stored in `private_dot_claude/CLAUDE.md` in the Chezmoi source:

```
~/.local/share/chezmoi/private_dot_claude/
└── CLAUDE.md    # Global instructions
```

When applied, this maps to `~/.claude/CLAUDE.md`.

## Current Global Settings

The global `~/.claude/CLAUDE.md` includes:

- **Commit style**: No emojis, no Claude co-authoring mentions, focus on "why" not "what"
- **File management**: Prefer editing existing files over creating new ones
- **Code style**: Follow existing project conventions, prioritize readability
- **Security rules**: Never commit secrets or .env files

## Syncing Changes

After editing `~/.claude/CLAUDE.md`:

```bash
chezmoi add ~/.claude/CLAUDE.md
cd ~/.local/share/chezmoi
git add -A && git commit -m "Update Claude global instructions" && git push
```

Or use `/pm:sync-claude-config` if available.

## Custom Commands and Skills

Custom slash commands and skills are managed through a separate plugin system, not through this dotfiles repo. See the plugin repositories for more information.

## File Naming

Chezmoi uses the `private_` prefix for the `.claude` directory, which sets restrictive permissions (0600) on the synced files for security.
