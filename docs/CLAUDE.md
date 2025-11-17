# Claude Code Configuration

This repository manages Claude Code's global configuration using Chezmoi.

## Overview

Claude Code reads instructions from `CLAUDE.md` files to customize its behavior:

- **Global instructions**: `~/.claude/CLAUDE.md` - Applied to all projects (managed by this dotfiles repo)
- **Project-specific instructions**: `CLAUDE.md` in project root - Overrides global settings (NOT managed by dotfiles)
- **Custom slash commands**: `~/.claude/commands/` - Reusable command workflows (managed by this dotfiles repo)

## Configuration Location

The Claude configuration is stored in the `private_dot_claude/` directory in the Chezmoi source:

```
~/.local/share/chezmoi/private_dot_claude/
├── CLAUDE.md                               # Global instructions
└── commands/
    └── private_sync-claude-config.md       # Slash command to sync changes
```

When applied, this maps to:
```
~/.claude/
├── CLAUDE.md
└── commands/
    └── sync-claude-config.md
```

## Current Global Settings

The global `~/.claude/CLAUDE.md` includes:

- **Commit style**: No emojis, no Claude co-authoring mentions, focus on "why" not "what"
- **File management**: Prefer editing existing files over creating new ones
- **Code style**: Follow existing project conventions, prioritize readability

## Syncing Configuration Changes

When you make changes to your Claude configuration, use the custom slash command to sync them:

```bash
# In Claude Code, run:
/sync-claude-config
```

This command will:
1. Add changes from `~/.claude/` to Chezmoi
2. Show you what changed
3. Generate an appropriate commit message
4. Ask for approval before committing
5. Optionally push changes to remote

## Adding Custom Slash Commands

To add a new slash command:

1. Create a markdown file in `~/.claude/commands/`:
   ```bash
   vim ~/.claude/commands/my-command.md
   ```

2. Write the command prompt in the file

3. Sync the changes:
   ```bash
   /sync-claude-config
   ```

4. Use the command in Claude Code:
   ```bash
   /my-command
   ```

## File Naming

Chezmoi uses the `private_` prefix for the `.claude` directory, which sets restrictive permissions (0600) on the synced files for security.

## Integration with Dotfiles Workflow

Claude configuration follows the same workflow as other dotfiles:

1. Make changes to `~/.claude/` files
2. Sync to Chezmoi source using `/sync-claude-config`
3. The slash command handles committing and pushing changes
4. On other machines, `chezmoi apply` or `ma` to sync the configuration

This ensures consistent Claude Code behavior across all your development machines.
