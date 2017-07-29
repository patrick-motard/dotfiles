# dotfiles
All my dotfiles used for linux and osx. Uses YADM. 

## Important Aliases

### setup-run
This will run `.local/bin/han_setup.zsh`, which includes several installation commands. Use
this command to install pacman & AUR packages required by the dotfiles. This command also
updates your pacman.

### setup-edit
Run this command if you would like to edit the setup file. (i.e. you want to install new packages)

### sz
sources ~/.zshrc

### rc-edit
edit `~/.zshrc`

### xrl
reload changes to ~/.Xresources


## scripts
~/.local/bin 

Two scripts below found at [this article](https://wiki.archlinux.org/index.php/migrate_installation_to_new_hardware)

- `switch-aws-creds.sh` 
switch which AWS credentials are default
store your configs in `~/.aws/`.
make each set of credentials it's own file starting with `credentials-`
e.g. `credentials-my-work-creds`
e.g. `credentials-my-personal-creds`

Existing aliases:
`work-mode`: switch to work credentials
`other-mode`: switch to other credentials


## Additional Setup Steps:

### spacemacs:

Currently using [neotree icons](https://github.com/domtronn/all-the-icons.el). 
Install using `M-x all-the-icons-install-fonts`
Restart after install `SPC q r`



## Helpful Commands:

### spacemacs:

`SPC f e d` *spacemacs/find-dotfile* : opens `.spacemacs` in buffer

`SPC f e R` *dotspacemacs/sync-configuration-files* : reloads .spacemacs config changes

