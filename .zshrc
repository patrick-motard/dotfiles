PROMPT_EOL_MARK=''
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# auto load .nvmrc and apply when cd into a directory that has an .nvmrc
# this must be loaded before the zsh-nvm plugin
export NVM_AUTO_USE=true

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"
# hide user@host in agnoster theme on mac
# https://stackoverflow.com/questions/28491458/zsh-agnoster-theme-showing-machine-name
export DEFAULT_USER=$USER

[[ "uname 2> /dev/null)" == "Linux" ]] && isLinux=0 || isLinux=1

# plugins=(
#     git
#     docker
#     vi-mode
#     zsh-autosuggestions
#     # custom plugins #
#     # https://github.com/lukechilds/zsh-nvm
#     zsh-nvm
#     z)
plugins=(
    vi-mode
    zsh-autosuggestions
    z
    )

# include linux plugins
[[ $isLinux == 0 ]] && plugins+=(archlinux)
# include mac plugins
[[ $isLinux == 0 ]] && plugins+=()

source $ZSH/oh-my-zsh.sh

#############################
#     USER CONFIGURATION    #
#############################

# Export these user specific environment variables in your ~/.zshenv
# in order for these aliases to work:
    # export GITHUB_ACCOUNT=
    # export BITBUCKET_ACCOUNT=
    # export NPM_TOKEN=

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
export ARCHFLAGS="-arch x86_64"

function pe() {
    echo "ERROR: $1" >&2
    exit 1
}

function edit-config {
    config_file=~/.config/${1}/config
    if [[ -f "${config_file}" ]]; then
        vim $config_file
    else
        echo "${config_file}"
        echo "no config file found for ${1}" >&2
    fi
}

function grep_i3_keybinds {
    cat "${HOME}"/.config/i3/config | awk '/^bindsym/ { print }' | grep "\$mod+$1 "
}


# start-emacs will create a symlink to whichever emacs folder you want to use.
# Each of your emacs folders should be ~/.emacs.d.{name} where {name} is the name
# of the configuration you want to launch. I have ~/.emacs.d.spacemacs and ~/.emacs.d.han.
# ~/.emacs.d.spacemacs is what would typically be in ~/.emacs.d if you were using spacemacs normally.
# ~/.emacs.d.han is my own personal emacs configuration that I use when I don't want to use spacemacs.
# Note: This does not allow switching between multiple spacemacs configurations. It
# also assumes that for non spacemacs configurations you are using init.el instead of ~/.emacs.
# Note: If spacemacs, or your own personal configuration is on your system already, copy it to
# a an ~/.emacs.d.{name} folder before calling this. Otherwise the symlink will fail.
#
# Usage: start-emacs spacemacs
#        start-emacs han
#        start-emacs {name of your configuration}
function start-emacs {
    [[ -d ~/.emacs.d && ! -L ~/.emacs.d ]] && {
        echo -e "ERROR: ~/.emacs.d already exists and is a directory.\nCopy it to ~/.emacs.d.{name} before calling this command."
        return 1
    }
    # remove any existing symlink
    unlink ~/.emacs.d 2&>/dev/null
    ln -s ~/.emacs.d.$1 ~/.emacs.d
    emacs &
}

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# linux specific
if [[ $isLinux == 0 ]]; then
    alias pbcopy="xclip -selection clipboard"
    alias pbpaste="xclip -selection clipboard -o"
    alias sctl="sudo systemctl"
    alias ecp="ec polybar"
    alias gi3=grep_i3_keybinds
    alias xrl="xrdb ~/.Xresources"
    alias restart="shutdown -r now"
    alias cat="ccat"
    # alias ls="exa"
    # alias ll="exa -la"
    alias gimme="sudo pacman -S"
    alias bgf="~/.fehbg"
    alias bgn="update_background"
fi

alias vim="nvim"
alias h="cd ~"
alias ec="edit-config"
alias ez="vim ~/.zshrc"
alias vz="vim ~/.zshrc"
alias sz="source ~/.zshrc"
alias gs="git status"
alias gau="git add -u" # git add unstaged only
alias gaa="git add -A" # git add all
alias gcm="git commit -m"
alias gca="git commit --amend"
alias gb="git branch"
alias gd="git diff"
alias gds="git diff --staged"
alias gcb="git checkout -b"
alias gc="git commit --verbose"
alias gbl="git branch -l"
alias gp="git push"
alias gpf="git push --force-with-lease"
alias gpp="quick-git-check-in"
alias glv="git log | vim -"
alias gl="git log"
# git push and set upstream to current branch
function push_upstream () {
    git push -u origin $(git branch | grep "*" | awk -F " " '{print $NF}')
}
alias gpu=push_upstream

alias nr="node run.js"
alias kl="kubectl"
alias pacman="sudo pacman"
alias x="chmod +x"

alias y="yadm"
alias ya="yadm add"
alias yaa="yadm add -u" # add only unstaged files
alias yau="yadm add -u" # add only unstaged files

function yadm_add_tool () {
   yadm add ~/.local/bin/tools/$1
}
alias yat=yadm_add_tool
alias yc="yadm commit --verbose"
alias yca="yadm commit --amend"
alias ycm="yadm commit -m"
alias yp="yadm push"
alias ypf="yadm push -f"
alias ys="yadm status"
alias ye="yadm encrypt"
alias yd="yadm diff"
alias yds="yadm diff --staged"
alias yaf="yadm add ~/.yadm/files.gpg"
alias yafp="yadm add ~/.yadm/files.gpg ~/.yadm/encrypt && yadm commit -m 'encrypt' && yadm push"
alias token=~/.ssh/token

if [[ $isLinux == 0 ]]; then
    dot_playbook="main.yml"
    dot_flags="--ask-become-pass"
else
    dot_playbook="mac.yml"
    dot_flags=""
fi

alias update="ansible-playbook ~/code/dot-ansible/${dot_playbook} -i ~/code/dot-ansible/inventory/$(hostname).yml ${dot_flags}"
alias tools="cd ~/.local/bin/tools/ && ll"

alias npmis="npm install --save"
alias npmisd="npm install --save-dev"

alias c="cd ~/code && ll"
alias cgbb="cd ~/code/go/src/bitbucket.org/wtsdevops && ll"
alias cggh="cd $GOPATH/src/github.com/$GITHUB_ACCOUNT && ll"
alias vssh="vim ~/.ssh/config"
alias lssh="ls ~/.ssh"
alias rmrf="rm -rfi"
alias update-emacs="cd $HOME/.emacs.d && git pull --rebase && cd $HOME"
alias ns="new_script --path . --name"
alias nt="new_script --name"
alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
alias v='vim'

update_golang() {
    # update golang pacman package
    echo "\nUpdating golang...\n"
    sudo pacman -Sy --needed go
    echo "\nUpdating golang packages...\n"
    go get -u all
}

update_pacman_mirrorlist() {
    sudo reflector --verbose --protocol https --age 8 --sort rate --save /etc/pacman.d/mirrorlist
}

# leave this function with the _ prefix and aliased below without
# the prefix. Without them zsh errors on sourcing because grep
# is referencing an alias in this function. ( my grep is grep plus some
# formatting flags)
_sshg() {
    cat ~/.ssh/config | grep "Host $1"
}
# quickly grep ssh hosts from config file
alias grepssh=_sshg

#switch between different AWS accounts
alias work-mode="switch-aws-creds.sh work"
alias other-mode="switch-aws-creds.sh other"
alias check-mode="aws s3 ls"

alias dotfiles="cd ~/.config/dotfiles/"
alias dot-src="cd $GOPATH/src/github.com/patrick-motard/dot"
alias copy-monitors='xrandr -q | grep " connected" | awk "{print $"${1:-1}"}" ORS=" " | pbcopy'

alias homelab-up="docker stack deploy -c ~/code/homelab/docker-compose.yml homelab"
alias homelab-down="docker stack rm homelab"
alias homelab-status="docker service ls | grep homelab"


function generate_password() {
    if [[ $isLinux == 0 ]]; then
       password=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c 32; echo;)
    else
        password=$(env LC_CTYPE=C tr -dc "a-zA-Z0-9-_\$\?" < /dev/urandom | head -c 32)
    fi

    echo $password | pbcopy
    echo "New password copied to clipboard."
}

alias passgen=generate_password


# Use 'bashman` alias to view man page for shell builtins.
# Example: bashman set
# https://unix.stackexchange.com/a/18092/104661
bashman () { man bash | less -p "^       $1 "; }

#function _update-aur-pkglist() {
#    trizen -Qeqm > ~/code/dot-ansible/roles/pacman/files/aur-pkgs \
#            && yadm diff ~/.config/dotfiles/arch-packages/aur
#}
#
#function _update-pac-pkglist() {
#    pacman -Qqen > ~/code/dot-ansible/roles/pacman/files/pacman-pkgs \
#        && yadm diff ~/.config/dotfiles/arch-packages/pacman
#}
#alias update-aur-pkglist=_update-aur-pkglist
#alias update-pac-pkglist=_update-pac-pkglist
#

## CUSTOM KEY BINDINGS ##
## zsh vi-mode settings
# remaps ESC to fd
bindkey -M viins 'fd' vi-cmd-mode
bindkey 'lk' autosuggest-accept

## VIM POWERLINE
if [[ -r ~/.local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh ]]; then
    source ~/.local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh
fi
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/code/dot-ansible

# Flutter & Android
export PATH=$PATH:~/Downloads/flutter/bin


# export ANDROID_SDK_ROOT="/usr/local/share/android-sdk/"
# export ANDROID_HOME=/usr/local/share/android-sdk/
# export ANT_HOME=/usr/local/opt/ant
# export MAVEN_HOME=/usr/local/opt/maven
# export GRADLE_HOME=/usr/local/opt/gradle
# export ANDROID_NDK_HOME=/usr/local/opt/android-ndk


# export PATH=$ANT_HOME/bin:$PATH
# export PATH=$MAVEN_HOME/bin:$PATH
# export PATH=$GRADLE_HOME/bin:$PATH
# export PATH=$ANDROID_HOME/tools:$PATH
# export PATH=$ANDROID_HOME/platform-tools:$PATH
# export PATH=$ANDROID_HOME/build-tools/19.1.0:$PATH

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
## BEGIN -- managed by dot-ansible:zendesk -- ##
# export PLUGINS=$plugins
[[ -f ~/.local/bin/zendesk_zshrc.sh ]] && source ~/.local/bin/zendesk_zshrc.sh
## END -- managed by dot-ansible:zendesk -- ##
# BEGIN ZDI
source /Users/pmotard/Code/zendesk/zdi/dockmaster/zdi.sh
# END ZDI
