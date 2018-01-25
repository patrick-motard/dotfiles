
sudo pacman -S git

sudo pacman -S yaourt

yaourt -S yadm-git

yadm clone https://github.com/patrick-motard/dotfiles

cd ~/.local/bin/setup/install

./install

enter password twice

./install

enter password again

yadm reset --hard origin/master

reboot

when cloning yadm, replace ~/.yadm/encrypt with your own

wait for emacs to finish installing packages before rebooting (when it's time to reboot)

open firefox

install lastpass firefox extension

log in to lastpass

sync your firefox account by log into firefox using password from lastpass

log into dropbox:

  case: dropbox service successfully started, and opened a webpage in firefox to log into

    - use dropbox password from lastpass to log into dropbox, this will log the service into your account and initiate syncing

  case 2: your service didnt start, didnt open the webpage, or something is generally broke

    - pkill dropbox
    - open dropbox via rofi
    - log into dropbox via firefox

call decrypt alias (modified version of yadm decrypt) (decrypt ~/.yadm/files.gpg file contents to their appropriate file locations), use password from lastpass

cd ~

yadm clone -f git@github.com:patrick-motard/dotfiles.git (or your private fork)

follow instructions in readme for setting up fcrontab and desktop background (manual, annoying, i'll automate)

edit ~/.config/polybar/launch.sh to have your screens

restart i3 in place (alt+shift+r) (editing this file is annoying, ill make it more easily configurable)
