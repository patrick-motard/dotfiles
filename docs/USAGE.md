# Usage

Notes for myself because I forget a lot.

## Chezmoi

- edit = open chezmoi dir in editor
- ma = chezmoi apply + source zsh files
- moi = chezmoi
- moi cd = go to chezmoi dir

## Ansible

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
