# output list of installed packages via pacman to the a file
pacman -Qqe | grep -vx "$(pacman -Qqm)" > ~/.config/pacman-packages

# same for packages installed via yaourt
pacman -Qqm > ~/.config/yaourt-packages
