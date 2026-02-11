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

## Plugin System

Custom slash commands and skills are managed through a plugin marketplace system, separate from this dotfiles repo.

### How It Works

1. **Plugin Repositories**: Plugins are organized into git repositories, each acting as a "marketplace"
2. **Ansible Installation**: The dotfiles ansible playbook clones plugin repos to `~/code/claude/`
3. **Marketplace Registration**: A sync script registers these repos as Claude plugin marketplaces
4. **Plugin Loading**: Claude Code discovers and loads plugins from registered marketplaces

### Plugin Repository Structure

Each plugin repository follows this structure:

```
plugins-example/
├── marketplace.json       # Marketplace metadata and plugin list
└── plugins/
    └── example/           # Plugin namespace
        ├── skills/        # Reusable workflows (invoked with /skill-name)
        │   └── my-skill/
        │       └── SKILL.md
        ├── commands/      # Simple slash commands
        │   └── my-command.md
        └── agents/        # Autonomous task handlers
            └── my-agent.md
```

### Plugin Types

| Type | Purpose | Invocation |
|------|---------|------------|
| **Skills** | Multi-step workflows with instructions | `/namespace:skill-name` |
| **Commands** | Simple prompt injections | `/namespace:command-name` |
| **Agents** | Background task handlers | Automatically triggered |

### Installation via Ansible

The ansible playbook handles plugin setup:

```bash
# Run the full playbook (includes plugin setup)
dotansible

# Or run just the claude-plugins tag
dotansible claude-plugins
```

This will:
1. Clone plugin repositories to `~/code/claude/`
2. Run the plugin sync script to register marketplaces
3. Machine-specific plugins (e.g., work-only) are conditionally installed

### Creating Your Own Plugins

To create a new plugin repository:

1. Create a git repo with the marketplace structure above
2. Add a `marketplace.json` with metadata:
   ```json
   {
     "name": "my-marketplace",
     "version": "1.0.0",
     "plugins": [
       {
         "name": "my-plugin",
         "version": "1.0.0",
         "description": "What this plugin does"
       }
     ]
   }
   ```
3. Add skills/commands/agents as markdown files
4. Register it as a marketplace in Claude Code

### Public Marketplace

A public plugin marketplace is available at [patrick-motard/claude-plugins-public](https://github.com/patrick-motard/claude-plugins-public). This can serve as a reference for creating your own plugin repositories.

### Separation of Concerns

- **Dotfiles repo (public)**: Global `CLAUDE.md` instructions, ansible tasks for plugin installation
- **Plugin repos (can be private)**: Actual plugin code, skills, commands, and sensitive workflows
- **Claude config**: Plugin cache, installation state, settings (`~/.claude/plugins/`)

This separation allows sharing dotfiles publicly while keeping custom workflows private.

## File Naming

Chezmoi uses the `private_` prefix for the `.claude` directory, which sets restrictive permissions (0600) on the synced files for security.
