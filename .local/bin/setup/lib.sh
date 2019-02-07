#!/usr/bin/env bash

# lib.sh is shared functionality between setup and install scripts.

# code may be ported to here from  install as update starts to catch
# up with install in functionality. Long term I would like to
# combine install and update as commands in the dot golang CLI.

# ~/.config/dotfiles/arch-packages/pacman is a list of packages
# for the dotfiles repo (arch packages, not AUR). This function
# installs all of the packages from that list.
function install_pacman_packages() {
    common_pacman_packages=$(cat ~/.config/dotfiles/arch-packages/pacman)
    for package_name in $common_pacman_packages; do
        sudo pacman -S $package_name --needed --noconfirm --quiet
    done
}
