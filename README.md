# dotfiles
All my dotfiles used for linux and osx. Uses YADM. 

## scripts
~/.local/bin 

Two scripts below found at [this article](https://wiki.archlinux.org/index.php/migrate_installation_to_new_hardware)

- `installed-packages.sh` : documented, read them

- `install-pacman-packages.sh` : installs packages for pacman listed from `installed-packages.sh` 

- `switch-aws-creds.sh` 
switch which AWS credentials are default
store your configs in `~/.aws/`.
make each set of credentials it's own file starting with `credentials-`
e.g. `credentials-my-work-creds`
e.g. `credentials-my-personal-creds`

Existing aliases:
`work-mode`: switch to work credentials
`other-mode`: switch to other credentials


## Helpful Commands:

### spacemacs:

`SPC f e d` *spacemacs/find-dotfile* : opens `.spacemacs` in buffer

`SPC f e R` *dotspacemacs/sync-configuration-files* : reloads .spacemacs config changes

