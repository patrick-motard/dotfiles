```
              ▄▄                         ▄▄▄▄      ██     ▄▄▄▄                         
              ██              ██        ██▀▀▀      ▀▀     ▀▀██                         
         ▄███▄██   ▄████▄   ███████   ███████    ████       ██       ▄████▄   ▄▄█████▄ 
        ██▀  ▀██  ██▀  ▀██    ██        ██         ██       ██      ██▄▄▄▄██  ██▄▄▄▄ ▀ 
        ██    ██  ██    ██    ██        ██         ██       ██      ██▀▀▀▀▀▀   ▀▀▀▀██▄ 
        ▀██▄▄███  ▀██▄▄██▀    ██▄▄▄     ██      ▄▄▄██▄▄▄    ██▄▄▄   ▀██▄▄▄▄█  █▄▄▄▄▄██ 
          ▀▀▀ ▀▀    ▀▀▀▀       ▀▀▀▀     ▀▀      ▀▀▀▀▀▀▀▀     ▀▀▀▀     ▀▀▀▀▀    ▀▀▀▀▀▀  
```

# Description

- Bar: `polybar` (or i3blocks)
- Browser: `firefox` (or qutebrowser)
- Compositor: `compton`
- IRC Client: `weechat`
- File Manager: `thunar` & `ranger`
- Font: `Hack`
- Program Launcher: `rofi`
- Text Editor: `spacemacs` & `vim`
- Terminal Emulator: `termite` & `oh-my-zsh`
- Window Manager: `i3-gaps`


# Package List (not comprehensive) 

- `yadm` dotfile manager
- `nvm` node version manager, defaults to lts/boron
- `emacs` spacemacs
- `yadm` dotfile manager
- `i3-gaps` window manager
- `i3blocks` status line for i3-bar
- `tumbler` enables thumbnail view of images for thunar
- `termite` terminal ([repo link](https://github.com/thestinger/termite/))
- `oh-my-zsh` & z shell
- `feh` (for desktop backgrounds)
- `wakatime` for code usage tracking
- `vim`
- `vundle`
- `wakatime`
- `ccat` colorized cat ([nixcraft](https://www.cyberciti.biz/howto/linux-unix-cat-command-with-colours/))
- `exa` colorized ls written in rust ([nixcraft](https://www.cyberciti.biz/open-source/command-line-hacks/exa-a-modern-replacement-for-ls-written-in-rust-for-linuxunix/))
- `tree` see tree folder/file structure from command line
(many more undocumented)

# Installation

Execute `~/.local/bin/tools/setup/install` in terminal:
`setup-run`

Make sure to read the script before executing it. It installs my entire environment, tweak it to meet your needs.


## Install spacemacs font icons:

Currently using [neotree icons](https://github.com/domtronn/all-the-icons.el). 
Install using `M-x all-the-icons-install-fonts`
Restart after install `SPC q r`

## Install vundle plugins:

in vim: `:PluginInstall`


## Desktop background image slideshow

### Technologies used:

**fcron**: cronjob utility

**feh**: command line utility for interacting with images

### First time setup:

Make sure fcron daemon is enabled (runs at startup):
   
`sudo systemctl enable fcron && sudo systemctl start fcron`

Load the preconfigured cronjobs for this repo:

`fcrontab ~/.config/fcron/my-fcrontab`

This will run set up a cron job that will call a tool script `update_background`. Every x minutes the background will change to a new image in the directory.

To change number of between image changes, edit `my-fcrontab` and reload the crontab (step 2).

To change where the cron job searches for images, edit the directory in 
`update_background`.

### Helpful background information:

- [how to reload cron jobs](https://askubuntu.com/questions/216692/where-is-the-user-crontab-stored)

- [cronjobs that run X.org related apps](https://wiki.archlinux.org/index.php/cron#Running_X.org_server-based_applications)

- [handling the annoying "email" issue in fcron (see "Example with msmtp")](https://wiki.archlinux.org/index.php/cron#Running_X.org_server-based_applications)

- [how to properly format a cronjob](https://stackoverflow.com/questions/5398014/using-crontab-to-execute-script-every-minute-and-another-every-24-hours)



# Commands

## Screenshot

`Print or PrtScr`

places screenshot with data+time in `~/Dropbox/Screenshots/2017`
([source](https://github.com/villasv/rice/blob/master/i3/config#L134))

## Launch Application

This will open the rofi menu, which you can use to launch apps. This shortcut can be run from any workspace with any application in focus.

`Alt+d`

## xbindkeys

`xbindkeys -k` : gives you key code for a pressed key or mouse button

## spacemacs:

`SPC f e d` *spacemacs/find-dotfile* : opens `.spacemacs` in buffer

`SPC f e R` *dotspacemacs/sync-configuration-files* : reloads .spacemacs config changes

`,` : major mode leader key (quickest way to issue a major mode command)

## Org Mode (spacemacs)

`t` toggle TODO item between TODO and DONE state

`alt-shift-RET` insert new TODO



# Aliases

## setup-run
This will run `.local/bin/setup/install`, which includes several installation commands. Use
this command to install pacman & AUR packages required by the dotfiles. This command also
updates your pacman.

## setup-edit
Run this command if you would like to edit the setup file. (i.e. you want to install new packages)

## sz
sources ~/.zshrc

## rc-edit
edit `~/.zshrc`

## xrl
reload changes to ~/.Xresources

## decrypt
decrypts encrypted yadm files and makes sure they are placed
correctly in ~/

## bgf
if you're in virtualbox and your desktop background is jank, this fixes it temporarily
i'm working on a better solution



# General Ricing Info

## How to edit cursor styles 

[link](https://www.xaprb.com/blog/2006/04/24/beautiful-x11-cursors/)

## Debugging chron jobs

add "2>&1 |logger" to end of script: 

`* * * * * echo "test message" 2>&1 |logger`

then view the output:
`sudo systemctl status fcron`

more info [here](https://www.allcloud.io/how-to/how-to-debug-cron-jobs/)

## GTK

Custom themes are downloaded to `/usr/share/themes/`

Instructions for setting the GTK 2 & 3 themes can be found on the [arch wiki](https://wiki.archlinux.org/index.php/GTK%2B#Themes)

Settings for gtk 3:
`~/.config/gtk-3.0/settings.ini`

Settings for gtk 2:
`~/.gtkrc-2.0`

## Cron Jobs

[how to import & export cron jobs](https://askubuntu.com/questions/216692/where-is-the-user-crontab-stored)


# Inspiration & Information Sources

### desktop backgrounds
 - [unsplash](https://unsplash.com/)
 - [wallhaven](https://alpha.wallhaven.cc/)

### color schemes
 - [terminal sexy](http://terminal.sexy/)

### dotfile repositories
 - [unixporn](https://www.reddit.com/r/unixporn)
 - [dotshareit](http://dotshare.it/)
 
### other people's dotfiles
 - [demure](https://notabug.org/demure/dotfiles/src/master/i3/config)

### dotfile galleries
 - [calou's](https://imgur.com/gallery/uFVFq)

