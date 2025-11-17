# Tmux Session Management

This document explains how tmux session management and layouts work in this dotfiles setup.

## Overview

This setup uses a combination of tools to provide powerful tmux session management with predefined layouts:

- **tmux** - Terminal multiplexer
- **TPM (Tmux Plugin Manager)** - Plugin management
- **Tmuxinator** - Session layout configurations
- **sesh** - Smart session selector that integrates everything
- **fzf** - Fuzzy finder for interactive selection

## How It Works Together

### 1. Tmux Configuration

The main tmux configuration is in `dot_tmux.conf` with:

- **Prefix key**: `Ctrl+t`
- **Custom keybindings** for pane navigation using `mnei` (Colemak-inspired)
- **Sesh integration** bound to `Ctrl+t + s`
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

### 3. Tmuxinator

Tmuxinator manages complex session layouts with multiple windows, panes, and startup commands. Configs are stored in `dot_config/tmuxinator/`:

**Example**: `growth-engine.yml` defines a development environment with 7 panes:
1. Devspace sync
2. Rails console
3. Bash shell
4. Neovim (startup pane)
5. Empty pane
6. Empty pane
7. System monitor (btop)

### 4. Sesh - The Session Selector

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

When you select a tmuxinator config from the sesh picker, it automatically runs `tmuxinator start <name>` to launch your predefined layout.

## Creating New Layouts

### Option 1: Using Tmuxinator (Recommended for Complex Layouts)

1. **Create a new tmuxinator config**:
   ```bash
   # Navigate to tmuxinator configs in chezmoi
   cd ~/.local/share/chezmoi/dot_config/tmuxinator

   # Create new config (or copy existing one)
   cp growth-engine.yml my-project.yml
   ```

2. **Edit the configuration**:
   ```yaml
   name: my-project
   root: ~/code/my-project

   windows:
     - my-project:
         panes:
           - nvim
           - npm run dev
           - git status
   ```

3. **Apply changes**:
   ```bash
   chezmoi apply
   ```

4. **Launch the session**:
   - Press `Ctrl+t + s` in tmux
   - Type to filter for "my-project"
   - Press Enter to launch

### Option 2: Manual Layout with Tmux Built-ins

For simpler layouts, you can use tmux's built-in commands:

1. **Create panes**:
   - `Ctrl+t + /` - Split vertically
   - `Ctrl+t + -` - Split horizontally

2. **Navigate panes**:
   - `Alt+m/n/e/i` - Move between panes (no prefix needed)

3. **Resize panes**:
   - `Ctrl+t + Ctrl+Arrow` - Resize by 5 pixels
   - `Ctrl+t + Alt+m/n/e/i` - Resize by 1 pixel

4. **Cycle layouts**:
   - `Ctrl+t + Space` - Cycle through built-in layouts (even-horizontal, even-vertical, main-horizontal, main-vertical, tiled)

5. **Save current layout** (for tmuxinator):
   ```bash
   # Display current layout string
   tmux list-windows -F "#{window_layout}"

   # Copy the output and paste into tmuxinator config under 'layout:'
   ```

### Option 3: Using Sesh Configs

For simple session definitions without complex layouts:

1. **Create/edit sesh config**:
   ```bash
   vim ~/.config/sesh/sesh.toml
   ```

2. **Add a session**:
   ```toml
   [[session]]
   name = "my-project"
   path = "~/code/my-project"
   startup_command = "nvim"
   ```

3. **Access via sesh**:
   - Press `Ctrl+t + s`
   - Press `Ctrl+g` to show config sessions
   - Select your session

## Quick Reference

### Common Tmux Commands

| Command | Description |
|---------|-------------|
| `Ctrl+t + s` | Open sesh session picker |
| `Ctrl+t + t` | Switch to last session (via sesh) |
| `Ctrl+t + c` | Create new window |
| `Ctrl+t + /` | Split pane vertically |
| `Ctrl+t + -` | Split pane horizontally |
| `Alt+m/n/e/i` | Navigate panes |
| `Alt+M/I` | Navigate windows |
| `Ctrl+t + r` | Reload tmux config |

### Tmuxinator Commands

```bash
# Start a session
tmuxinator start growth-engine
# or shorthand
mux start growth-engine

# Edit a config
tmuxinator edit growth-engine
mux e growth-engine

# List all configs
tmuxinator list
mux list

# Stop a session
tmuxinator stop growth-engine
```

### Sesh Commands

```bash
# List all sessions
sesh list

# List only tmux sessions
sesh list -t

# List only configs
sesh list -c

# List only zoxide directories
sesh list -z

# Connect to a session
sesh connect <session-name>

# Connect to last session
sesh last
```

## Tips

1. **Sesh is the main entry point** - Use `Ctrl+t + s` to access all your sessions, tmuxinator configs, and directories in one place

2. **Tmuxinator for complex projects** - Use tmuxinator when you need multiple panes with specific commands running at startup

3. **Save your layouts** - After manually arranging panes, save the layout with `tmux list-windows -F "#{window_layout}"` and add it to your tmuxinator config

4. **Don't forget to apply** - After editing tmuxinator configs in the chezmoi source directory, run `ma` (chezmoi apply + source shell) to sync changes

5. **Session switching** - `Ctrl+t + t` quickly toggles between your last two sessions (great for switching between code and monitoring)

## Troubleshooting

**Tmuxinator config not showing in sesh**:
- Ensure config is in `~/.config/tmuxinator/`
- Check that the config has a valid `name:` field
- Restart tmux or reload: `tmux source ~/.tmux.conf`

**Plugins not working**:
- Install TPM: `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`
- Press `Ctrl+t + I` to install plugins
- Restart tmux

**Layout not loading correctly**:
- Verify tmuxinator YAML syntax
- Check that paths in the config exist
- Test manually: `tmuxinator start <config-name>`
