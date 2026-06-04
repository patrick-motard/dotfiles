# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working in this repository.

## Repository Overview

This is a public dotfiles repository managed by [Chezmoi](https://www.chezmoi.io/). It contains shell, editor, terminal, and desktop configuration intended to be safe to keep in a public repo.

## Key Technologies

- **Chezmoi**: Dotfile manager with templating support (`.tmpl`)
- **ZSH**: Shell configuration and aliases
- **Neovim**: `nvim-custom` and `nvim-lazyvim`
- **Tmux**: Terminal multiplexer and theme config
- **Hammerspoon**: macOS desktop automation

## Common Commands

### Chezmoi Operations

```bash
# Apply changes and reload shell
ma

# Edit dotfiles (opens chezmoi source dir in editor)
edit

# Navigate to chezmoi source directory
moicd
# or
cd ~/.local/share/chezmoi

# Run git commands on dotfiles repo from anywhere
gmoi <git-command>

# Add nvim config to chezmoi (removes lazy-lock.json)
moi_add_nvim
```

### Shell Management

```bash
# Reload zsh configuration
sz

# View zsh configuration
catrc
```

### Neovim Configurations

```bash
# Switch between neovim configs interactively
vv

# Current default config (set via NVIM_APPNAME)
nvim-custom
nvim-lazyvim
```

## Architecture

### Chezmoi Template System

Files with `.tmpl` extension are processed as Go templates. Key variables:
- `{{ .chezmoi.os }}` - OS detection (`darwin` or `linux`)
- `{{ .chezmoi.hostname }}` - Machine hostname for machine-specific configuration

Example:
```tmpl
{{ if eq .chezmoi.os "darwin" -}}
# macOS specific configuration
{{ end -}}

{{ if eq .chezmoi.hostname "GVXPDWWKWG" -}}
# Work machine configuration
{{ end -}}
```

### ZSH Configuration

- `.zshenv` - environment variables, sourced first
- `.zprofile` - login shell configuration
- `.zshrc` - interactive shell setup
- `aliases.zsh` - shell aliases and functions

### Neovim Configurations

- `dot_config/nvim-custom/` - kickstart.nvim-based setup
- `dot_config/nvim-lazyvim/` - LazyVim setup

## Development Workflow

1. Navigate to the chezmoi source: `moicd` or `edit`
2. Edit files in the source directory
3. For templated files, edit the `.tmpl` source file
4. Apply changes: `ma`
5. Commit changes: `gmoi add . && gmoi commit`

## File Naming Conventions

Chezmoi uses special prefixes in the source directory:
- `dot_` → `.` at any level
- `.tmpl` suffix → Go template processing
- `executable_` → make file executable
- `private_` → set file permissions to `0600`

## Important Paths

- Chezmoi source: `$HOME/.local/share/chezmoi`
- Config files: `~/.config/`
- Local binaries: `~/.local/bin`
- ZSH configs: `$ZDOTDIR` (usually `~/.zsh/`)
- Tmux plugins: `~/.tmux/plugins/`
- Global Claude instructions source: `~/code/dotfiles-private/dot_claude/CLAUDE.md`

## Repo Rules

- Never use emojis in commit messages or mention Claude authorship
- Always update links in the README table of contents when adding/removing docs
- Never create dotfiles directly in `~/.config`, `~/.zsh`, `~/.emacs.d`, etc. Always create them in the chezmoi source directory and deploy via `chezmoi apply`
