# dotfiles
All my dotfiles & setup scripts used for linux. 


## Sites used for inspiration & information

### color schemes
 - [terminal sexy](http://terminal.sexy/)

### dotfile repositories
 - [unixporn](https://www.reddit.com/r/unixporn)
 - [dotshareit](http://dotshare.it/)


## Programs Used:

- `yadm` dotfile manager
- `nvm` node version manager, defaults to lts/boron
- `emacs` spacemacs
- `yadm` dotfile manager
- `i3-gaps` window manager
- `i3blocks` status line for i3-bar
- `tumbler` enables thumbnail view of images for thunar
- `termite` terminal ([repo link](https://github.com/thestinger/termite/))
- `oh-my-zsh` & z shell
- no display manager
- `feh` (for desktop backgrounds)
- `wakatime` for code usage tracking
- `vim`
-- `powerline`
-- `vundle`
-- `wakatime`
- `ccat` colorized cat ([nixcraft](https://www.cyberciti.biz/howto/linux-unix-cat-command-with-colours/))
- `exa` colorized ls written in rust ([nixcraft](https://www.cyberciti.biz/open-source/command-line-hacks/exa-a-modern-replacement-for-ls-written-in-rust-for-linuxunix/))
- `tree` see tree folder/file structure from command line

## Useful cmd line tools

### xbindkeys

`xbindkeys -k` : gives you key code fora  pressed key or mouse button

## Useful Aliases

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

### decrypt
decrypts encrypted yadm files and makes sure they are placed
correctly in ~/

### bgf
if you're in virtualbox and your desktop background is jank, this fixes it temporarily
i'm working on a better solution


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

### AUR pkg `python-powerline-git`

This package gives you a nice powerline styled command line for zsh
as well as a powerline for vim. However it's setup requires a few 
extra steps when installing. The package build instructions includes
dependencies for both the python2 version and the python3 version. 
If you dont remove all the dependencies and build instructions for 
the version of python you're not using the install will fail. Make 
sure to take note of what version of python you are running
(pip --version). I'm running python3.

When the install asks to "Edit PKGBUILD" type "y" 

Assuming you are running python3 remove python2-powerline-git, 
python2-setuptools, python2-sphinx (needs to be python-sphinx),
and `make man SPHINXBUILD=sphinx-build2` needs to be `make man SPHINXBUILD=sphinx-build`

### spacemacs:

Currently using [neotree icons](https://github.com/domtronn/all-the-icons.el). 
Install using `M-x all-the-icons-install-fonts`
Restart after install `SPC q r`



## Helpful Commands:

### spacemacs:

`SPC f e d` *spacemacs/find-dotfile* : opens `.spacemacs` in buffer

`SPC f e R` *dotspacemacs/sync-configuration-files* : reloads .spacemacs config changes

`,` : major mode leader key (quickest way to issue a major mode command)


### Org Mode (spacemacs)

`t` toggle TODO item between TODO and DONE state

`alt-shift-RET` insert new TODO

## Helpful file locations:

### Themes

#### GTK

Custom themes are downloaded to `/usr/share/themes/`

Instructions for setting the GTK 2 & 3 themes can be found on the [arch wiki](https://wiki.archlinux.org/index.php/GTK%2B#Themes)

Settings for gtk 3:
`~/.config/gtk-3.0/settings.ini`

Settings for gtk 2:
`~/.gtkrc-2.0`


# General Ricing Info

How to edit cursor styles [link](https://www.xaprb.com/blog/2006/04/24/beautiful-x11-cursors/)
