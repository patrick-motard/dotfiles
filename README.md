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

## Initial Setup

### New Machine Setup

1. **Install Chezmoi** and initialize with this repo:
   ```shell
   # Install chezmoi (macOS)
   brew install chezmoi

   # Initialize with your dotfiles repo
   chezmoi init https://github.com/YOUR_USERNAME/dotfiles.git
   ```

2. **Configure machine-specific settings**:

   After initialization, chezmoi will create `~/.config/chezmoi/chezmoi.toml` with default values. Edit this file to configure machine-specific settings:

   ```shell
   # Edit the config file
   vim ~/.config/chezmoi/chezmoi.toml
   ```

   **For Zendesk work machines**, set:
   ```toml
   [data]
       zendesk_machine = true
   ```

   **For personal machines**, keep the default:
   ```toml
   [data]
       zendesk_machine = false
   ```

   This variable controls whether Zendesk-specific configuration (zetup, zendesk tooling, ssh keys, etc.) is included in your shell configuration.

3. **Apply dotfiles**:
   ```shell
   # Apply all dotfiles
   chezmoi apply
   ```

4. **Install ZSH plugins**:
   ```shell
   # Install zplug plugins (including agnoster theme)
   zplug install
   ```

5. **Run Ansible** to install packages and configure system:
   ```shell
   # macOS
   ./ansible/mac-setup.sh  # First time only
   dotansible

   # Linux/Fedora
   ./ansible/fedora-setup.sh  # First time only
   ```

6. **Restart your terminal** to see the new theme and configuration take effect.

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
# Run full playbook
dotansible

# Run specific tasks only
dotansible_brew      # Install/update Homebrew packages
dotansible_packages  # Install all packages
dotansible_zsh       # Configure ZSH
dotansible_tmux      # Configure tmux
```

### Hammerspoon

- ansible
  - os: osx
  - role: hammerspoon
- config files managed by chezmoi
