```
              ▄▄                         ▄▄▄▄      ██     ▄▄▄▄                         
              ██              ██        ██▀▀▀      ▀▀     ▀▀██                         
         ▄███▄██   ▄████▄   ███████   ███████    ████       ██       ▄████▄   ▄▄█████▄ 
        ██▀  ▀██  ██▀  ▀██    ██        ██         ██       ██      ██▄▄▄▄██  ██▄▄▄▄ ▀ 
        ██    ██  ██    ██    ██        ██         ██       ██      ██▀▀▀▀▀▀   ▀▀▀▀██▄ 
        ▀██▄▄███  ▀██▄▄██▀    ██▄▄▄     ██      ▄▄▄██▄▄▄    ██▄▄▄   ▀██▄▄▄▄█  █▄▄▄▄▄██ 
          ▀▀▀ ▀▀    ▀▀▀▀       ▀▀▀▀     ▀▀      ▀▀▀▀▀▀▀▀     ▀▀▀▀     ▀▀▀▀▀    ▀▀▀▀▀▀  
```
![desktop-screenshot](https://i.imgur.com/mTvqTcQ.png)
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
- `polybar` status line & bar for i3
- `tumbler` enables thumbnail view of images for thunar
- `termite` terminal ([repo link](https://github.com/thestinger/termite/))
- `oh-my-zsh` & z shell
- `feh` terminal based image viewer, also used for desktop backgrounds
- `wakatime` for those interested in [quantifying code usage](https://wakatime.com/)
- `vim`
- `vundle` vim package manager
- `wakatime` helps you track how much time you code [see website]
- `ccat` colorized cat ([nixcraft](https://www.cyberciti.biz/howto/linux-unix-cat-command-with-colours/))
- `exa` colorized ls written in rust ([nixcraft](https://www.cyberciti.biz/open-source/command-line-hacks/exa-a-modern-replacement-for-ls-written-in-rust-for-linuxunix/))
- `tree` see tree folder/file structure from command line
- `task` "Taskwarrior", a terminal based TODO list manager [see website](https://taskwarrior.org/)
- `rtv` a terminal based reddit browser [see their github](https://github.com/michael-lazar/rtv)
- `gtop` pretty neat terminal based visual `top`
(many more undocumented)



# Installation

How you choose to install this repo will depend on the state of your linux system.

This dotfile repo is intended to be an entire environment, not just dotfiles. It includes scripts for setting up an entire operating system from scratch. In order for the full installation to work, there are a few assumptions:

1. Your operating system is a clean install of Arch, with no desktop environment, display server, nothing, just a terminal to interact with. 
2. You have git installed and are able to clone a fork of this repo.

I recommend installing Arch using Antergos because it gives a nice gui for installing Arch. It also has the option to install Arch without a desktop environment. I recommend that option because the setup scripts in this repo install your environment for you. Having an existing environment already will probably break these setup scripts.


Managing your dotfiles in source control is important. This project uses [YADM](https://thelocehiliosan.github.io/yadm/), a dotfile manager that employs git. With YADM you can start with a new repo, or clone an existing repo. Both approachs are explained in depth on the YADM website's [getting started](https://thelocehiliosan.github.io/yadm/docs/getting_started) section. 


1. Fork this repo (or clone this repo directly and change it's upstream to your fork after install is done)
2. Install Arch using Antergos, choose the "no desktop environment" option.
4. Follow the instructions outlined in [install.md](install.md)
5. report any bugs or manual steps as issues to this repo so that the install process can be improved.

Make sure to read the setup script before executing it. It installs my entire environment, tweak it to meet your needs.


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

# Commands & Aliases

## Aliases

All aliases are currently listed in `~/.zshrc`. This list is not comprehensive.

| alias      | Description                                                                                                              |
|------------|--------------------------------------------------------------------------------------------------------------------------|
| setup-edit | Run this command if you would like to edit the install(dotfiles installer). (i.e. you want to install new packages)      |
| decrypt    | Decrypts yadm files and makes sure they are placed in ~/. Use this instead of yadm's decrypt command.                    |
| tools      | cd to ~/.local/bin/tools directory in terminal                                                                           |
| sz         | source ~/.zshrc                                                                                                          |
| ez         | edit ~/.zshrc                                                                                                            |
| xrl        | reload changes to ~/.Xresources                                                                                          |
| bgf        | If you're in virtualbox and your desktop background is jank, this fixes it temporarily. I'm working on a better solution |
| kl         | kubectl                                                                                                                  |

## Tool Commands
Tools are scripts included as part of this repo that are used either in config files (like polybar & i3), or you can use directly.
Tools are located in `~/.local/bin/tools` & `~/.local/bin/setup`

| Action            | Command       | Location      | Description                                                                                                      |
|-------------------|---------------|---------------|------------------------------------------------------------------------------------------------------------------|
| update pacman/aur | update        | setup/update  | updates pacman and aur packages (there is an indicator in polybar that shows you if there are updates available) |
| install dotfiles  | setup-install | setup/install | installs everything included in this repository, see setup instructions for more context                         |
| take screenshot   | screenshot    |               | Places screenshot with data+time in `~/Dropbox/Screenshots/{YEAR}`, pass `-h` flag for additional options.       |

## Rofi Commands

| Action           | Command                 | Type           | Description                                                                |
|------------------|-------------------------|----------------|----------------------------------------------------------------------------|
| open rofi        | alt+d                   | key combo      | Opens rofi                                                                 |
| rofi switch view | alt+n/p (next/previous) | rofi key combo | Switches between views in rofi when rofi is open. Views: run, ssh, windows |


## Spacemacs

| Mode | Action                   | Command         | Description                                                                 |
|------|--------------------------|-----------------|-----------------------------------------------------------------------------|
| *    | open `.spacemacs`        | `SPC f e d`     | *spacemacs/find-dotfile* : opens `.spacemacs` in buffer                     |
|      | reload `.spacemacs`      | `SPC f e R`     | *dotspacemacs/sync-configuration-files* : reloads .spacemacs config changes |
|      | view major mode commands | `,`             | major mode leader key (quickest way to issue a major mode command)          |
| Org  | toggle TODO              | `t`             | toggle TODO item between TODO & DONE state in .org file                     |
|      | insert TODO              | `alt-shift-RET` | insert new TODO in .org file                                                |


## Other 3rd Party Commands

| Tool      | Command      | Description                                                                                                             |
|-----------|--------------|-------------------------------------------------------------------------------------------------------------------------|
| xbindkeys | xbindkeys -k | Uses xbindkeys to output key code of pressed key or mouse button. Useful for mapping key codes to commands in i3 config |


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
 - [noctuid](https://github.com/noctuid/dotfiles) Includes a more thorough explanation to all of this than I provide.

### dotfile galleries
 - [calou's](https://imgur.com/gallery/uFVFq)

### Blogs
 - [Howard Abrams](http://www.howardabrams.com/)
 - [Jeff Lindsay](http://progrium.com/blog/page2/)
 - [Ilya Grigorik - vimgolf creator](https://www.igvita.com/)
 - [Charles Leifer - Suffering for fashion: a glimpse into my Linux theming toolchain](http://charlesleifer.com/blog/suffering-for-fashion-a-glimpse-into-my-linux-theming-toolchain/)

# Future Ideas

1. rust lib for creating rules for windows and workspaces in i3

examples of problems it could solve:

   * when opening a terminal, make it open with a fixed or relative height and width 
   * configure and restore workspace layouts, beyond the functionality of i3 

2. a polybar extension or stand alone application like rofi that provides a gui with functionality like emacs helm (spacemacs variety), to make common tasks, scripts, and functions discoverable and callable using symantic keybinds. (would love to use rust for the engine and maybe a language like lua, lisp, or python for scripting it)

3. short of the system variety of helm, a cheatsheet overlay that behaves like rofi and can hook into my config files and scripts to generate and display a cheatsheet would be amazing.

4. look into using taskwarrior for task management

5. look into using oh-my-zsh custom plugins for better management of .zshrc [oh-my-zsh wiki "Customization" section](https://github.com/robbyrussell/oh-my-zsh/wiki/Customization)

# Unanswered Questions

Things I want to know but didn't have time to look into when I thought of it.

- i3wm: How to move a window below the window to the right or left of it without moving it below
the entire tree

- how to do snippets in emacs (per mode would be really nice)
  
Some things I'd like snippets for:

  - Javascript console logs (figured this out once then promptly forgot how i did it)
  - argument parsing template for bash scripts (i always end up copy pasting from other scripts)
  - documentation templates for bash scripts (they're inconsistent between my scripts right now)
    
