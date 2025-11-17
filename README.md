```
              ▄▄                         ▄▄▄▄      ██     ▄▄▄▄
              ██              ██        ██▀▀▀      ▀▀     ▀▀██
         ▄███▄██   ▄████▄   ███████   ███████    ████       ██       ▄████▄   ▄▄█████▄
        ██▀  ▀██  ██▀  ▀██    ██        ██         ██       ██      ██▄▄▄▄██  ██▄▄▄▄ ▀
        ██    ██  ██    ██    ██        ██         ██       ██      ██▀▀▀▀▀▀   ▀▀▀▀██▄
        ▀██▄▄███  ▀██▄▄██▀    ██▄▄▄     ██      ▄▄▄██▄▄▄    ██▄▄▄   ▀██▄▄▄▄█  █▄▄▄▄▄██
          ▀▀▀ ▀▀    ▀▀▀▀       ▀▀▀▀     ▀▀      ▀▀▀▀▀▀▀▀     ▀▀▀▀     ▀▀▀▀▀    ▀▀▀▀▀▀
```

Welcome to my dotfile repo! More documentation to come.

### Where did the tiling wm desktop dotfiles go?

The dotfiles pertaining to the keyboard driven desktop environment have moved locations! Read more about that on my website [here](https://www.patrickmotard.com/posts/where-did-the-dotfiles-desktop-environment-go/). Going forward, this repo will contain dotfiles agnostic of any specific desktop environment.

## A 10,000 ft view

These dotfiles provide a reproducible, cross-platform development environment that can be set up on any new machine in minutes. Whether you're switching between macOS and Linux, setting up a new work laptop, or just want a solid foundation for your terminal workflow, these configurations give you:

- **Reproducibility**: Identical setup across all your machines
- **Automation**: One command to install and configure everything
- **Flexibility**: Machine profiles for different contexts (personal, work, etc.)
- **Power**: Keyboard-driven workflow with tmux, vim, and modern shell tools
- **Speed**: Optimized for fast shell startup and efficient terminal navigation

**Key technologies:**

- [Chezmoi](https://www.chezmoi.io/) dotfile manager
- [Ansible](https://www.ansible.com/) to automate setup
- [Hammerspoon](https://www.hammerspoon.org/) on mac for desktop automation
- [VsCode](https://code.visualstudio.com/) with vim keybinds is my main editor, I no longer use emacs.
- [Neovim](https://neovim.io/) is my terminal editor
- [lazy.nvim](https://github.com/folke/lazy.nvim) for vim plugin management
- [tmux]() for terminal multiplexing
  - [tmux-tea]() for tmux session management
- [ZSH](https://zsh.sourceforge.io/) for my shell
- [Zplug](https://github.com/zplug/zplug) for ZSH plugins

## Table of Contents

- [Initial Setup](docs/SETUP.md) - New machine setup and configuration
- [Usage](docs/USAGE.md) - Common commands and daily usage
- [Claude Code Configuration](docs/CLAUDE.md) - Managing Claude Code global configuration
- [Tmux Session Management](docs/TMUX.md) - How tmux, tmuxinator, sesh, and fzf work together to provide powerful session management and layouts
- [Performance Testing](docs/PERFORMANCE.md) - Benchmarking shell startup time
