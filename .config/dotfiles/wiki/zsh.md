# ZSH

## Terminal

Dotfiles uses [termite](https://github.com/thestinger/termite) as it's terminal. I chose termite because it is one of the most keyboard driven terminals. It supports vim-like keybinds. It is also easy to configure via config files. See the termite projects readme for keybinds.

## Shell

### Files

Dotfiles uses `zsh` as the default shell and [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) to customize zsh.
##
Below are a list of files and directories that are important for `zsh`

#### ~/.profile
This is where non-sensitive environment variable and $PATH exports are. ~/.profile is loaded by both zsh and other apps that rely on environment variables being set.

#### ~/.zshenv
Where sensitive environment variables are exported. Examples: npm login tokens, api keys, etc.

#### ~/.zshrc
Currently where aliases and functions are stored. There are a bunch of things in there right now. It's kindof messy.

#### ~/.zprofile
Loaded by `zsh` in `termite`. `~/.zprofile` loads `~/.profile`. Some applications need environment variables, but those applications don't respect the default shell and load `sh` or `bash` (which would load `~/.bash_profile`) instead. In order to ensure that both `zsh` and GUI applications like `emacs` get the environment variables, they are set in `~/.profile` and then `zsh` loads `~/.zprofile`. This is a common way of fixing this issue.

### Helpful Commands
The `oh-my-zsh` [wiki](https://github.com/robbyrussell/oh-my-zsh/wiki) includes a [cheatsheet](https://github.com/robbyrussell/oh-my-zsh/wiki/Cheatsheet) that is super helpful for learning the awesome features that come out of the box.

## Resources

- terminal.sexy: terminal color scheme designer
- [terminals are sexy](https://github.com/k4m4/terminals-are-sexy): currated list of terminal frameworks, plugins, and resources


