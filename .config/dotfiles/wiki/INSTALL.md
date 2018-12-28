# Installation:

(screenshots coming soon)

run the following in your terminal:

`curl -L -o install goo.gl/FThZtR && chmod +x install && sh install --user {YOUR_GITHUB_ACCOUNT_NAME}` (optional: --full)

*--full will install all the aur packages i use, not just the essentials*

example:

`curl -L -o install goo.gl/FThZtR && chmod +x install && sh install --user patrick-motard`

The shortened url is for your convenience when typing. It links to [this gist](https://gist.githubusercontent.com/patrick-motard/0314ce77e1002443fdac0cca5a409e5c/raw). This command will download a gist that will start the install script for this project. NOTE: You will be prompted a few times for your root password while the script is running. You can view the install script [here](https://github.com/patrick-motard/dotfiles/blob/master/.local/bin/setup/install).

After the install script is done, the OS will reboot.

# First Login

(screenshots coming soon)

## Setting up Spacemacs, your main editor

When you are logged in for the first time, you will be in workspace 1. By default, Emacs (spacemacs) opens. When spacemacs opens, it loads `~/.spacemacs`, it's config file. `~/.spacemacs` is included as part of `dotfiles`. Within the file there are several settings. Spacemacs looks for a list of plugins from the `~/.spacemacs` file and will install them automatically. You will see spacemacs installing them. When spacemacs is done installing, it will look very ugly. Restart Spacemacs by pressing `SPC q r`. That's the space bar, then q, then r. Spacemacs will reload and will look great. 

## Install spacemacs font icons:

Like most editors, Spacemacs supports file tree view, which shows your files and folders of the current project or current buffers directory. `~/.spacemacs` is already configured to used Neotree with ['all-the-icons' by domtronn](https://github.com/domtronn/all-the-icons.el). The only thing you need to do is tell spacemacs to install the fonts it needs. You'll know that you need to install fonts if your projectile tree view (`SPC p t`) looks like this:

![](.config/dotfiles/screenshots/fonts-missing.png)

To install `all-the-icons` type: `SPC SPC all-the-icons-install-fonts` then press Enter.
Once installed, restart Spacemacs after install `SPC q r`. Once Spacemacs opens, you can open the file tree by pressing `SPC f t`, or if you have a project open using Projectile, you can open up the projects file tree using `SPC p t`. If the fonts were correctly installed, you should see something like this:

![](.config/dotfiles/screenshots/fonts-working.png)

## Install vundle plugins:

For quickly editing files in the terminal I prefer vim. I have configured vim to use a few plugins. These plugins are installed via a plugin manager. There are several to choose from. I have chosen Vundle. To install the plugins listed in `~/.vimrc`, do the following:

1. move to workspace 2, this is where i prefer my main terminals to go: `Alt 2`
2. open a terminal: `Alt Enter`
3. open vim: in terminal type: `vim` (enter)
4. in vim type: `:PluginInstall` (enter)

You should see a Vundle buffer open, in which a list of plugins will show install progress. Once the install is done, you can exit vim: `:q` (enter) x 2


## Desktop background image slideshow

This section will show you how to set up a desktop background image slideshow using `feh`, `fcron`.

### Technologies used:

**fcron**: cronjob utility

**feh**: command line utility for interacting with images

### First time setup:

Make sure fcron daemon is enabled (runs at startup):
   
`sudo systemctl enable fcron && sudo systemctl start fcron`

Load the preconfigured cronjobs for this repo:

`fcrontab ~/.config/fcron/my-fcrontab`

This will run set up a cron job that will call a tool script `update_background`. Every x minutes the background will change to a new image in the directory.

To change number of between image changes, edit `my-fcrontab` and reload the crontab (step 2).

To change where the cron job searches for images, edit the directory in 
`update_background`.

### Helpful background information:

- [how to reload cron jobs](https://askubuntu.com/questions/216692/where-is-the-user-crontab-stored)

- [cronjobs that run X.org related apps](https://wiki.archlinux.org/index.php/cron#Running_X.org_server-based_applications)

- [handling the annoying "email" issue in fcron (see "Example with msmtp")](https://wiki.archlinux.org/index.php/cron#Running_X.org_server-based_applications)

- [how to properly format a cronjob](https://stackoverflow.com/questions/5398014/using-crontab-to-execute-script-every-minute-and-another-every-24-hours)


## other steps (documentation will be improved soon)
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

TODO: improve decrypt/encrypt instructions
If this is based on your fork of dotfiles: call decrypt alias (modified version of yadm decrypt) (decrypt ~/.yadm/files.gpg file contents to their appropriate file locations), use password from lastpass
