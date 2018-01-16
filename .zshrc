# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#ZSH_THEME="robbyrussell"
#ZSH_THEME="gnzh"
ZSH_THEME="agnoster"
# ZSH_THEME="lambda-mod"
# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git docker)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

## NVM STUFF
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

autoload -U add-zsh-hook
load-nvmrc() {
    local node_version="$(nvm version)"
    local nvmrc_path="$(nvm_find_nvmrc)"

    if [ -n "$nvmrc_path" ]; then
        local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

        if [ "$nvmrc_node_version" = "N/A" ]; then
            nvm install
        elif [ "$nvmrc_node_version" != "$node_version" ]; then
            nvm use
        fi
    elif [ "$node_version" != "$(nvm version default)" ]; then
        echo "Reverting to nvm default version"
        nvm use default
    fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc
## END NVM STUFF

## VIM POWERLINE
if [[ -r ~/.local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh ]]; then
    source ~/.local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh
fi

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"
## add bitbucket and github keys to keychain so that i dont have run ssh-add every time
## i open shell
## https://wiki.archlinux.org/index.php/SSH_keys#Keychain
eval $(keychain --eval --quiet id_rsa id_rsa_bb)

## FUNCTIONS
function print-shortcuts {
    case $1 in
        "i3")
            missing_docs $1
            ;;
        "alias")
            cat << EOF
Name           Shortcut  Args    Descrption                         Example
edit config    ec        *       edit config file for given arg     ec polybar
EOF
            ;;
        *)
            missing_docs $1 "undefined"
            cat << EOF
Options:
i3
alias
EOF

            ;;
    esac
}

function missing_docs {
    echo "missing docs for ${1}"
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

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
alias h="print-shortcuts"
alias ec="edit-config"
alias ecp="ec polybar"
alias ez="vim ~/.zshrc"
alias sz="source ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias gs="git status"
alias gcm="git commit -m"
alias gp="git push"
alias gpp="quick-git-check-in"
alias pbcopy="xclip -selection clipboard"
alias pbpaste="xclip -selection clipboard -o"
alias restart="shutdown -r now"
## reload xresources
alias xrl="xrdb ~/.Xresources"
alias nr="node run.js"

alias y="yadm"
alias ya="yadm add"
alias yc="yadm commit"
alias ycm="yadm commit -m"
alias yp="yadm push"
alias ys="yadm status"
alias ye="yadm encrypt"
alias yd="yadm diff"
alias yaf="yadm add ~/.yadm/files.gpg"
alias token=~/.ssh/token
alias decrypt="yadm decrypt && rsync -a ~/home/$USER/ ~/ && rm -rf ~/home/$USER"

alias setup-run="bash ~/.local/bin/setup/install"
alias setup-edit="vim ~/.local/bin/setup/install"
alias update="bash ~/.local/bin/setup/update"
alias tools="cd ~/.local/bin/tools/ && ll"

alias cat="ccat"
alias ls="exa"
alias ll="exa -la"
alias gimme="sudo pacman -S"
alias bgf="~/.fehbg"

alias c="cd ~/code && ll"


#switch between different AWS accounts
alias work-mode="switch-aws-creds.sh work"
alias other-mode="switch-aws-creds.sh other"
alias check-mode="aws s3 ls"

## Robo3t -mongo-client-
export PATH=/usr/bin/robo3t/bin:$PATH

## RUST
export PATH=~/.cargo/bin:$PATH
RUST_SRC_PATH=~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src
## end RUST

## GOLANG
export GOPATH=~/code/go
# add go bin folder to path so that compiled bin files can be
# executed from anywhere using terminal
export PATH="$PATH:$GOPATH/bin"
## END GOLANG

## vimgolf
export PATH="$PATH:/home/han/.gem/ruby/2.5.0/gems/vimgolf-0.4.8/bin"
## end vimgolf

export PATH=~/.local/bin:$PATH
export PATH=~/.local/bin/tools:$PATH
export PATH=/opt/idea-IC-171.4424.56/bin:$PATH
export PATH=~/.cargo/bin:$PATH

## NPM TOKEN SETUP
export NPM_TOKEN=$NPM_TOKEN

export EDITOR=vim


# powerline recommended line to run
#powerline-daemon -q
#. /usr/share/zsh/site-contrib/powerline.zsh

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH=$PATH:/home/han/.local/bin

source '/home/han/.local/bin/azure-cli/az.completion'
