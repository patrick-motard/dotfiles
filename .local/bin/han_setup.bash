## update pacman
sudo pacman -Syu --noconfirm
## rank mirrors by speed and filter out out of date mirrors
##sudo pacman-mirrors -g
sudo pacman-optimize && sync

export pacman_packages="
  xorg-server
  jq
  xorg-xinit
  virtualbox-guest-utils
  virtualbox-guest-modules-arch
  vim
  zsh
  keychain
  xclip
  python-pip
  firefox
  termite
  rofi
  dropbox
  emacs
  compton
  pulseaudio
  pamixer
  feh
  docker
  docker-compose
  thunar
  htop
"

for package_name in $pacman_packages; do
  sudo pacman -S $package_name --needed --noconfirm
done


## if the docker daemon isn't active, set it up
if [ ! $(systemctl -q is-active docker ) ] ; then
    echo "Docker isn't running"
    ## refer to docker daemon documentation for further details:
    ## https://docs.docker.com/engine/installation/linux/linux-postinstall/
    ## create a group for docker
    sudo groupadd docker
    ## add current user to it so that you dont have to issue sudo everytime
    sudo usermod -aG docker $USER
    ## make sure the docker daemon starts on boot
    sudo systemctl enable docker
    ## start the docker daemon
    sudo systemctl start docker
    echo "Docker now running and set to run on boot. User added to group"
fi

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
pip install --upgrade --user awscli

## Install Vundle
if [[ ! -d /home/han/.vim/bundle/Vundle.vim ]]; then
  git clone https://github.com/VundleVim/Vundle.vim.git /home/han/.vim/bundle/Vundle.vim
fi

## Install NVM if nvm shell sript not downloaded
if [[ ! -f .nvm/nvm.sh ]]; then
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
  . ~/.nvm/nvm.sh ## source nvm
  nvm install lts/boron
  npm i -g tern ## tern is used for the javascript layer in emacs
fi

mkdir -p $HOME/code

## Set yadm remote to .ssh
yadm remote set-url origin git@github.com:patrick-motard/dotfiles.git

## Install Spacemacs
if [[ ! -d ~/.emacs.d/.git ]]; then
  git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
fi

## use vmware setupscript (works with virtualbox)
if [[ ! -d ~/Downloads/vmware-tools/.git ]]; then
  git clone https://github.com/rasa/vmware-tools-patches.git ~/Downloads/vmware-tools/
  sudo sh /home/han/Downloads/vmware-tools/patched-open-vm-tools.sh
fi

## install yaourt packages
export yaourt_packages="
  ttf-font-awesome
  i3-gaps-git
  i3blocks-gaps-git
  python-powerline-git
  xorg-xprop
  hipchat
  gtk-theme-arc-git
"


for yaourt_package in $yaourt_packages; do
  yaourt $yaourt_package --noconfirm
done
