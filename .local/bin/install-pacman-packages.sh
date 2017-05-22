# sudo required. will install all packages listed in ~/.config/pacman-packages
xargs -a pacman-packages pacman -S --noconfirm --needed
