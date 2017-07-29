## update pacman
pacman -Syu

for package_name (
  keychain  ## used for maintaining ssh-agent keys
  python-pip ## pip used for python packages
  emacs  
)
; pacman -S $package_name --needed --noconfirm

##  keychain,\
 ##   python-pip,\ 
 ##   emacs \
 ##   --noconfirm ## install without asking for confirmation
 ##   --needed ## dont re-install, install only

## Install wakatime
pip install wakatime

## Install Vundle
if [[ ! -d /home/han/.vim/bundle/ ]]; then
  git clone https://github.com/VundleVim/Vundle.vim.git /home/han/.vim/bundle/Vundle.vim
else
  cd /home/han/.vim/bundle/Vundle.vim && git pull && echo 'hello world'
fi

