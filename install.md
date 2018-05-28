run the following in your terminal:

`curl -L -o install goo.gl/FThZtR && chmod +x install && sh install --user {YOUR_GITHUB_ACCOUNT_NAME}`

example:

`curl -L -o install goo.gl/FThZtR && chmod +x install && sh install --user patrick-motard`

The shortened url is for your convenience when typing. It links to [this gist](https://gist.githubusercontent.com/patrick-motard/0314ce77e1002443fdac0cca5a409e5c/raw). After the install script is done running, you should now see X start up and you'll see
a GUI similar to the screenshot in this repo. Spacemacs will startup and astart installing its packages.

wait for (spac)emacs to finish installing packages before rebooting (when it's time to reboot)

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
