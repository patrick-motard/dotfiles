```
              ▄▄                         ▄▄▄▄      ██     ▄▄▄▄
              ██              ██        ██▀▀▀      ▀▀     ▀▀██
         ▄███▄██   ▄████▄   ███████   ███████    ████       ██       ▄████▄   ▄▄█████▄
        ██▀  ▀██  ██▀  ▀██    ██        ██         ██       ██      ██▄▄▄▄██  ██▄▄▄▄ ▀
        ██    ██  ██    ██    ██        ██         ██       ██      ██▀▀▀▀▀▀   ▀▀▀▀██▄
        ▀██▄▄███  ▀██▄▄██▀    ██▄▄▄     ██      ▄▄▄██▄▄▄    ██▄▄▄   ▀██▄▄▄▄█  █▄▄▄▄▄██
          ▀▀▀ ▀▀    ▀▀▀▀       ▀▀▀▀     ▀▀      ▀▀▀▀▀▀▀▀     ▀▀▀▀     ▀▀▀▀▀    ▀▀▀▀▀▀
```
![desktop-screenshot3](https://i.imgur.com/muFsylw.png)
![desktop-screenshot2](https://i.imgur.com/VyHzgFz.png)
![desktop-screenshot](https://i.imgur.com/mTvqTcQ.png)

Please see [the wiki](https://github.com/patrick-motard/dotfiles/wiki) for documentation on specific features.

# Description

A keyboard based desktop environment that features:

- Automatic installation & setup.
- A full featured i3wm desktop environment.

# Installation

This project uses [YADM](https://thelocehiliosan.github.io/yadm/), a dotfile manager that employs git. With YADM you can start with a new repo, or clone an existing repo. Both approachs are explained in depth on the YADM website's [getting started](https://thelocehiliosan.github.io/yadm/docs/getting_started) section.

**NOTICE:** Antergos was previously recommended as the easiest base install of Arch linux for this project. Antergos is no longer being maintained. For now, installing Arch from scratch is recommend. It's not that bad. :)

1. Fork this repo (or clone this repo directly and change it's upstream to your fork after install is done)
2. Install Arch linux ([here's a good tutorial video](https://www.youtube.com/watch?v=iF7Y8IH5A3M&list=PL5IqGaS7KgO1XKpQhoValBSmRbO4s16rI&index=5&t=0s) that gives you a working system in < 20 min. Stop following along before he installs KDE. You don't need a desktop environment.)
4. Follow the instructions outlined in the [Installation Page](https://github.com/patrick-motard/dotfiles/wiki/Installation) in the wiki.
5. report any bugs or manual steps as issues to this repo so that the install process can be improved.

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
    * when opening a terminal, make it open with a fixed or relative height and width
    * configure and restore workspace layouts, beyond the functionality of i3

2. a polybar extension or stand alone application like rofi that provides a gui with functionality like emacs helm (spacemacs variety), to make common tasks, scripts, and functions discoverable and callable using symantic keybinds. (would love to use rust for the engine and maybe a language like lua, lisp, or python for scripting it)

3. short of the system variety of helm, a cheatsheet overlay that behaves like rofi and can hook into my config files and scripts to generate and display a cheatsheet would be amazing.

4. look into using taskwarrior for task management

5. look into using oh-my-zsh custom plugins for better management of .zshrc [oh-my-zsh wiki "Customization" section](https://github.com/robbyrussell/oh-my-zsh/wiki/Customization)

6. +1 script to create issues in github repo for dotfiles from commandline using vim buffer (or maybe emacs plugin if i'm feeling ambitious.)

7. rofi menu for selecting screen layout. Or maybe something other than rofi. My current i3 method is starting to reach it's limits.

8. refactor install script to be written in another language
probably python. move dependencies to list files. have core packages and non core packages. have commands to add and remove packages from both list files and os.

# TODO

- [ ] conky + i3gaps (left/right/bottom/etc)
- [ ] better titles for rofi modes
- [ ] better/other rofi nord themes
- [ ] different zsh themes
- [ ] dynamicly load/set width of nord polybar i3 bar
- [ ] custom firefox home page
- [ ] album of screenshots/gifs showing features/workflows/appearance of desktop and applications
- [ ] load polybar theme via dot cli


# Unanswered Questions

Things I want to know but didn't have time to look into when I thought of it.

- i3wm: How to move a window below the window to the right or left of it without moving it below
the entire tree

- how to do snippets in emacs (per mode would be really nice)

 - cli for browsing remote repos on account, as well as cloning and such

- cli based wiki for commands (manpage for dotfiles/dot)

- rofi based login/shutdown/restart menu

- custom homepage for firefox

- framework for rofi menus

- rofi based password manager for lastpass

- script for adding and removing packages from ~/.config/dotfiles/arch-packages/pacman


Some things I'd like snippets for:

  - Javascript console logs (figured this out once then promptly forgot how i did it)
  - argument parsing template for bash scripts (i always end up copy pasting from other scripts)
  - documentation templates for bash scripts (they're inconsistent between my scripts right now)


## TODO

* Tasks
** TODO learn Org Mode basics
** TODO configure polybar
** TODO setup weechat to auto-join server/channels
** TODO checkout py-wal
** TODO make website
** TODO learn qutebrowser
** TODO learn ranger
