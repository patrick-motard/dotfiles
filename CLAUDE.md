# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a dotfiles repository managed by [Chezmoi](https://www.chezmoi.io/). It contains personal configuration files for a cross-platform development environment (macOS, Linux/WSL) with automated setup via Ansible.

## Key Technologies

- **Chezmoi**: Dotfile manager with templating support (.tmpl files)
- **Ansible**: Automated system setup and package installation
- **ZSH**: Shell with Zplug for plugin management
- **Neovim**: Terminal editor using kickstart.nvim (nvim-custom) and LazyVim (nvim-lazyvim)
- **Tmux**: Terminal multiplexer with TPM for plugins
- **Hammerspoon**: macOS desktop automation (Lua-based)

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

### Ansible Playbook

```bash
# Run full ansible playbook to configure system (macOS)
dotansible

# For WSL (prompts for sudo password)
dotansible_wsl

# Run specific ansible tasks by tag
dotansible_brew      # Install/update Homebrew packages only
dotansible_packages  # Install all packages (brew or apt)
dotansible_zsh       # Configure ZSH only
dotansible_tmux      # Configure tmux only

# First-time setup scripts
./ansible/mac-setup.sh      # macOS
./ansible/fedora-setup.sh   # Fedora Linux
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
nvim-custom  # kickstart.nvim based
nvim-lazyvim # LazyVim distribution
```

### Tmux

```bash
# Session manager (uses sesh + fzf)
# Bound to Alt+s in tmux
```

## Architecture

### Chezmoi Template System

Files with `.tmpl` extension are processed as Go templates. Key variables:
- `{{ .chezmoi.os }}` - OS detection ("darwin" or "linux")
- `{{ .chezmoi.hostname }}` - Machine hostname
- Conditional blocks enable OS-specific configuration

Example from dot_gitconfig.tmpl:
```
{{ if eq .chezmoi.os "darwin" -}}
# macOS specific git config
{{ end -}}
```

### Ansible Structure

**Main playbook**: `ansible/main.yml`
- Targets: localhost (127.0.0.1)
- Roles: zsh, hammerspoon (macOS only)
- Tasks: apt/homebrew package management, nodenv, tmux, vundle

**Inventory files**: `ansible/inventory/`
- Machine-specific configs named by hostname
- `main.yml` is the default inventory

**Tasks**: `ansible/tasks/`
- apt.yml - Debian/Ubuntu packages
- homebrew.yml - macOS packages
- nodenv.yml - Node.js version management
- tmux.yml - Tmux plugin manager setup
- vundle.yml - Vim plugin setup

**Roles**: `ansible/roles/`
- zsh/ - ZSH installation and configuration
- hammerspoon/ - macOS window management (macOS only)
- Additional roles: desktop-background, emacs, lastpass, lock-screen, music, pacman

### ZSH Configuration

**Structure**:
- `.zshenv` - Environment variables, sourced first
- `.zprofile` - Login shell configuration
- `.zshrc` - Interactive shell setup, sources aliases.zsh
- `aliases.zsh` - All shell aliases and functions

**Plugin management**: Zplug
- Plugins: vi-mode, agnoster theme, zsh-autosuggestions, zsh-syntax-highlighting
- Custom keybinds: `fd` for vi command mode, `lk` to accept suggestions

**Key integrations**:
- fzf - fuzzy finder
- zoxide - smart directory jumping
- sesh - tmux session manager (Alt+s keybind)

### Neovim Configurations

**nvim-custom**: Kickstart.nvim fork
- Single-file init.lua with extensive documentation
- Uses lazy.nvim for plugin management
- Located: `dot_config/nvim-custom/`

**nvim-lazyvim**: LazyVim distribution
- More opinionated, feature-complete setup
- Located: `dot_config/nvim-lazyvim/`

Switch between configs using the `vv` function or by setting `NVIM_APPNAME`.

### Hammerspoon (macOS)

**Structure**:
- `init.lua` - Main configuration, loads modules
- `src/` - Custom modules (application, window, help)
- `Spoons/` - Hammerspoon plugins
- `bookmarks/` - Custom bookmarks configuration

**Key features**:
- Application launching/focusing keybinds
- Window management and tiling
- Google Calendar integration (requires setup)
- Modifiers defined: hyper (cmd+alt), meh (alt+shift+ctrl), leader (alt)

**Reload**: Bound to cmd+alt+r

## Development Workflow

### Making Changes to Dotfiles

1. Navigate to chezmoi source: `moicd` or `edit`
2. Edit files in the source directory
3. For templated files, edit the `.tmpl` version
4. Apply changes: `ma` (applies and reloads shell)
5. Commit changes: `gmoi add .` and `gmoi commit`

### Adding New Configuration Files

```bash
# Add a file to chezmoi management
chezmoi add ~/.config/newapp/config.yml

# Add with auto-template generation
chezmoi add --autotemplate ~/.gitconfig
```

### Ansible Customization

Create machine-specific inventory:
```bash
cp ansible/inventory/main.yml ansible/inventory/$(hostname).yml
```

Edit the new inventory file, then run:
```bash
ansible-playbook ansible/main.yml -i ansible/inventory/$(hostname).yml
```

### Machine-Specific Configuration

Chezmoi supports custom data variables via `~/.config/chezmoi/chezmoi.toml`. This repo includes a template at `dot_config/chezmoi/chezmoi.toml.tmpl` with:

```toml
[data]
    zendesk_machine = false  # Set to true on Zendesk work machines
```

**To configure a Zendesk machine**: After applying chezmoi, manually edit `~/.config/chezmoi/chezmoi.toml` and set `zendesk_machine = true`. This file is NOT tracked by git (it's applied from the template but overrides persist locally).

**Using in templates**: Reference the variable with `{{ .zendesk_machine }}`:
```
{{ if .zendesk_machine -}}
# Zendesk-specific configuration
{{ end -}}
```

This allows separating Zendesk-specific config (like zetup, zendesk tooling) from general macOS config.

### Platform-Specific Notes

**macOS**:
- Homebrew packages managed via `ansible/tasks/homebrew.yml`
- Hammerspoon requires manual first-time setup
- rbenv path: `~/.rbenv/versions/3.3.3/bin`

**Linux/WSL**:
- APT packages managed via `ansible/tasks/apt.yml`
- Alacritty settings in Windows: `C:\Users\Patrick\AppData\Roaming\Alacritty\`
- Use `alacritty_settings_update` to sync config to Windows (WSL only)
- rbenv path: `~/.rbenv/versions/3.3.4/bin`

## File Naming Conventions

Chezmoi uses special prefixes in the source directory:
- `dot_` → `.` at any level (e.g., `dot_zshrc` → `.zshrc`, `dot_config/` → `.config/`)
- `.tmpl` suffix → Go template processing
- `executable_` → Make file executable
- `private_` → Set file permissions to 0600

Examples of the directory structure mapping:
- `dot_config/nvim/init.lua` → `~/.config/nvim/init.lua`
- `dot_zsh/dot_zprofile.tmpl` → `~/.zsh/.zprofile` (templated)
- `dot_config/chezmoi/chezmoi.toml.tmpl` → `~/.config/chezmoi/chezmoi.toml` (templated)
- `dot_tmux.conf` → `~/.tmux.conf`

The `dot_` prefix is used every time a dot is needed in the path, whether for directories or files.

## Important Paths

- Chezmoi source: `$HOME/.local/share/chezmoi`
- Config files: `~/.config/`
- Local binaries: `~/.local/bin`
- ZSH configs: `$ZDOTDIR` (usually `~/.zsh/`)
- Tmux plugins: `~/.tmux/plugins/`
- Node versions: `~/.nodenv/versions/`
- never use emojis in commit messages, nor co-authoring from claude, nor mentions of it being generated by claude