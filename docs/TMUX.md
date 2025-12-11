# Tmux Session Management

This document explains how tmux session management and layouts work in this dotfiles setup.

## Overview

This setup uses a combination of tools to provide powerful tmux session management with predefined layouts:

- **tmux** - Terminal multiplexer
- **TPM (Tmux Plugin Manager)** - Plugin management
- **Tmux Layouts** - Quick layout switching for existing panes (`~/.config/tmux-layouts/`)
- **Tmuxinator** - Full session configurations with commands (`~/.config/tmuxinator/`)
- **sesh** - Smart session selector that integrates everything
- **fzf** - Fuzzy finder for interactive selection

## Two Layout Systems

### 1. Tmux Layouts (Rearrange Existing Panes)

**Location**: `~/.config/tmux-layouts/*.layout`

Simple layout files that rearrange your existing panes without killing processes. Use these when you want to quickly reorganize your workspace.

**Keybind**: `Ctrl+t + L` - Opens layout picker

**Available layouts**:
| Layout | Description |
|--------|-------------|
| `4-wide` | 4 panes side-by-side (main-vertical) |
| `3-wide` | 3 equal panes side-by-side |
| `2-wide` | 2 equal panes side-by-side |
| `2-stack` | 2 panes stacked vertically |
| `grid` | Tiled grid layout |

### 2. Tmuxinator (Full Session Setup)

**Location**: `~/.config/tmuxinator/*.yml`

Full session configurations that create new windows/panes with specific commands. Use these when starting fresh on a project.

**Available configs**:
| Config | Description |
|--------|-------------|
| `growth-engine` | Devspace dev environment with 7 panes |

Access via sesh (`Ctrl+t + s`) or `tmuxinator start <name>`.

## Switching Layouts On-the-Fly

Press `Ctrl+t + L` to open the layout picker. This:
- Shows all available layouts with descriptions
- Previews the layout file
- Applies the selected layout to your **current window**
- **Does not kill any processes** - just rearranges panes

## Creating New Layouts

### Save Your Current Arrangement

1. Manually arrange your panes how you want them
2. Run `layout-new my-layout-name`
3. Enter a description when prompted
4. The layout is saved and immediately available via `Ctrl+t + L`

```bash
# Example: create a layout from your current pane arrangement
layout-new dev-custom
```

### Create a Layout Manually

Create a file in `~/.config/tmux-layouts/`:

```bash
# ~/.config/tmux-layouts/my-layout.layout
# Description of this layout
main-vertical
```

Layout strings can be:
- Built-in names: `main-vertical`, `main-horizontal`, `even-horizontal`, `even-vertical`, `tiled`
- Custom strings from `tmux list-windows -F "#{window_layout}"`

### Sync to Dotfiles

After creating layouts, add them to chezmoi:

```bash
chezmoi add ~/.config/tmux-layouts/
ma  # apply and reload
```

## How It Works Together

### 1. Tmux Configuration

The main tmux configuration is in `dot_tmux.conf` with:

- **Prefix key**: `Ctrl+t`
- **Custom keybindings** for pane navigation using `mnei` (Colemak-inspired)
- **Sesh integration** bound to `Ctrl+t + s`
- **Layout picker** bound to `Ctrl+t + L`
- **Theme**: Gruvbox (via tmux-gruvbox plugin)

### 2. TPM (Tmux Plugin Manager)

TPM manages tmux plugins. Installed plugins are defined in `dot_tmux.conf`:

```tmux
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'z3z1ma/tmux-gruvbox'
```

**Installing plugins**:
- Press `Ctrl+t + I` (capital I) to install plugins
- Press `Ctrl+t + U` to update plugins
- Press `Ctrl+t + Alt+u` to uninstall removed plugins

### 3. Sesh - The Session Selector

Sesh is a smart session manager that aggregates sessions from multiple sources:

- **tmux sessions** - Currently active tmux sessions
- **tmuxinator configs** - Predefined layouts from `~/.config/tmuxinator/`
- **sesh configs** - Custom session configs from `~/.config/sesh/sesh.toml`
- **zoxide** - Frequently visited directories

**Keybinding**: `Ctrl+t + s` opens the sesh fuzzy finder

**Within the sesh picker**:
- `Ctrl+a` - Show **all** sources (tmux + configs + tmuxinator + zoxide)
- `Ctrl+t` - Show only **tmux** sessions
- `Ctrl+g` - Show only **sesh config** sessions
- `Ctrl+x` - Show only **zoxide** directories
- `Ctrl+f` - Find directories with fd
- `Ctrl+d` - Kill selected tmux session

## Manual Layout with Tmux Built-ins

For quick one-off layouts without saving:

1. **Create panes**:
   - `Ctrl+t + /` - Split vertically
   - `Ctrl+t + -` - Split horizontally

2. **Navigate panes**:
   - `Alt+m/n/e/i` - Move between panes (no prefix needed)

3. **Resize panes**:
   - `Ctrl+t + Ctrl+Arrow` - Resize by 5 pixels
   - `Ctrl+t + Alt+m/n/e/i` - Resize by 1 pixel

4. **Cycle layouts**:
   - `Ctrl+t + Space` - Cycle through built-in layouts

## Quick Reference

### Common Tmux Commands

| Command | Description |
|---------|-------------|
| `Ctrl+t + s` | Open sesh session picker |
| `Ctrl+t + L` | Open layout picker (rearrange panes) |
| `Ctrl+t + t` | Switch to last session (via sesh) |
| `Ctrl+t + c` | Create new window |
| `Ctrl+t + /` | Split pane vertically |
| `Ctrl+t + -` | Split pane horizontally |
| `Ctrl+t + Space` | Cycle through built-in layouts |
| `Alt+m/n/e/i` | Navigate panes |
| `Alt+M/I` | Navigate windows |
| `Ctrl+t + r` | Reload tmux config |

### Layout Commands

```bash
# Apply a layout interactively
# Press Ctrl+t + L

# List available layouts
layout-picker -l

# Save current pane arrangement as a new layout
layout-new my-layout
```

### Tmuxinator Commands

```bash
# Start a session with full setup
tmuxinator start growth-engine
mux start growth-engine

# Edit a config
tmuxinator edit growth-engine
mux e growth-engine

# List all configs
tmuxinator list
```

### Sesh Commands

```bash
# List all sessions
sesh list

# List only tmux sessions
sesh list -t

# Connect to a session
sesh connect <session-name>

# Connect to last session
sesh last
```

## Tips

1. **Use `Ctrl+t + L` for quick rearrangement** - When you need to reorganize existing panes without losing running processes

2. **Use tmuxinator for fresh starts** - When you need specific commands running in specific panes

3. **Save layouts you like** - After manually arranging panes, run `layout-new name` to save for later

4. **Sesh is the main entry point** - Use `Ctrl+t + s` to access sessions, tmuxinator configs, and directories

5. **Session switching** - `Ctrl+t + t` quickly toggles between your last two sessions

## Troubleshooting

**Layout picker not working**:
- Ensure `~/.config/tmux-layouts/` exists and has `.layout` files
- Run `layout-picker -l` to verify layouts are found
- Reload tmux config: `Ctrl+t + r`

**Tmuxinator config not showing in sesh**:
- Ensure config is in `~/.config/tmuxinator/`
- Check that the config has a valid `name:` field
- Restart tmux or reload: `tmux source ~/.tmux.conf`

**Plugins not working**:
- Install TPM: `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`
- Press `Ctrl+t + I` to install plugins
- Restart tmux
