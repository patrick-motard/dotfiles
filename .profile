## put exports here so that applications *and* terminals get these
## environment variables
## This file is sourced in .zprofile so th at zsh gets these variables as well

## GOLANG
export GOPATH=~/code/go
# add go bin folder to path so that compiled bin files can be
# executed from anywhere using terminal
export PATH="$GOPATH/bin:$PATH"
## END GOLANG
## RUST export PATH=~/.cargo/bin:$PATH
RUST_SRC_PATH=~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src
## end RUST

## Robo3t -mongo-client-
export PATH=/usr/bin/robo3t/bin:$PATH

## vimgolf
export PATH="$PATH:/home/$USER/.gem/ruby/2.5.0/gems/vimgolf-0.4.8/bin"
## end vimgolf

export PATH=~/.local/bin/work:$PATH
export PATH=~/.local/bin:$PATH
export PATH=~/.local/bin/tools:$PATH
export PATH=/opt/idea-IC-171.4424.56/bin:$PATH
export PATH=~/.cargo/bin:$PATH

## NPM TOKEN SETUP
export NPM_TOKEN=$NPM_TOKEN

export EDITOR=vim

export MANPAGER="/bin/sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH=$PATH:/home/$USER/.local/bin
export BROWSER=/usr/bin/firefox

export TOOLS="$HOME/.local/bin/tools"
# used by tools/wifi
export WIFI_DEVICE="wlp4s0"
export WIFI_PROFILE="wts-wifi"
