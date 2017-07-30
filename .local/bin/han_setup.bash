## update pacman
sudo pacman -Syu

export pacman_packages="
  xorg-server
  xorg-xinit
  vim
  zsh 
  keychain
  python-pip
  firefox
  termite
  rofi
"

for package_name in $pacman_packages; do
  sudo pacman -S $package_name --needed --noconfirm
done

## set zsh to default shell
if [[ "$(echo $SHELL)" != "/usr/bin/zsh" ]]; then
	chsh -s $(which zsh)
	echo "shell set to zsh"
fi

export yaourt_packages="
  ttf-font-awesome
  i3-gaps-git
  i3-blocks
"
for yaourt_package in $yaourt_packages; do
  yaourt $yaourt_package --noconfirm
done

## Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

## Python package installs
## Install wakatime
sudo pip install wakatime

## Install Vundle
if [[ ! -d /home/han/.vim/bundle/Vundle.vim ]]; then
  git clone https://github.com/VundleVim/Vundle.vim.git /home/han/.vim/bundle/Vundle.vim
fi

## Set yadm remote to .ssh
yadm remote set-url origin git@github.com:patrick-motard/dotfiles.git
