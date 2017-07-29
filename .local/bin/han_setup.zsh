## update pacman
sudo pacman -Syu

for package_name (
  keychain  ## used for maintaining ssh-agent keys
  python-pip ## pip used for python packages
  emacs  
)
; sudo pacman -S $package_name --needed --noconfirm

for yaourt_package (
  ttf-font-awesome
)
; yaourt $yaourt_package --noconfirm

## Python package installs
## Install wakatime
pip install wakatime

## Install Vundle
if [[ ! -d /home/han/.vim/bundle/Vundle.vim ]]; then
  git clone https://github.com/VundleVim/Vundle.vim.git /home/han/.vim/bundle/Vundle.vim
else
  cd /home/han/.vim/bundle/Vundle.vim && git pull && echo 'hello world'
fi

