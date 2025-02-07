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

## Usage

Notes for myself because I forget a lot.

### Chezmoi

- edit = open chezmoi dir in editor
- ma = chezmoi apply + source zsh files
- moi = chezmoi
- moi cd = go to chezmoi dir

### Ansible

Call from anywhere (osx only)

```shell
dotansible
```

### Hammerspoon

- ansible
  - os: osx
  - role: hammerspoon
- config files managed by chezmoi
