# Usage

Notes for myself because I forget a lot.

## Chezmoi

- edit = open chezmoi dir in editor
- ma = chezmoi apply + source zsh files
- moi = chezmoi
- moi cd = go to chezmoi dir

## Ansible

Call from anywhere. Uses hostname-specific inventory if available.

```shell
# Run full playbook
dotansible

# Interactive tag selection with fzf
dotansible -i

# Run specific tasks by tag
dotansible brew      # Install/update Homebrew packages
dotansible packages  # Install all packages
dotansible zsh       # Configure ZSH
dotansible tmux      # Configure tmux

# List available tags
dotansible tags

# For WSL (prompts for sudo password)
dotansible --ask-become
```
