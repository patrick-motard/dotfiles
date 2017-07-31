## update pacman
sudo pacman -Syu --noconfirm
## rank mirrors by speed and filter out out of date mirrors
##sudo pacman-mirrors -g
sudo pacman-optimize && sync

export pacman_packages="
  xorg-server
  xorg-xinit
  virtualbox-guest-utils
  virtualbox-guest-modules-arch
  vim
  zsh
  keychain
  python-pip
  firefox
  termite
  rofi
  dropbox
  emacs
  nitrogen
  compton
  pulseaudio
  pamixer
"

for package_name in $pacman_packages; do
  sudo pacman -S $package_name --needed --noconfirm
done

## set zsh to default shell
if [[ "$(echo $SHELL)" != "/usr/bin/zsh" ]]; then
  chsh -s $(which zsh)
  echo "shell set to zsh"
fi

## Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

## Python package installs
## Install wakatime
sudo pip install wakatime

## Install Vundle
if [[ ! -d /home/han/.vim/bundle/Vundle.vim ]]; then
  git clone https://github.com/VundleVim/Vundle.vim.git /home/han/.vim/bundle/Vundle.vim
fi

## Install NVM if nvm command not recognized
if ! type nvm > /dev/null; then
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
  . ~/.nvm/nvm.sh ## source nvm
  nvm install lts/boron
  npm i -g tern ## tern is used for the javascript layer in emacs
fi

## Set yadm remote to .ssh
yadm remote set-url origin git@github.com:patrick-motard/dotfiles.git

## Install Spacemacs
if [[ ! -d ~/.emacs.d/.git ]]; then
  git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
fi

## use vmware setupscript (works with virtualbox)
if [[ ! -d ~/downloads/vmware-tools/.git ]]; then
  git clone https://github.com/rasa/vmware-tools-patches.git ~/downloads/vmware-tools/
  sudo sh /home/han/downloads/vmware-tools/patched-open-vm-tools.sh
fi

## install yaourt packages
export yaourt_packages="
  ttf-font-awesome
  i3-gaps-git
  i3blocks-gaps-git
"

for yaourt_package in $yaourt_packages; do
  yaourt $yaourt_package --noconfirm
done


