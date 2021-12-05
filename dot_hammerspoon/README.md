# .hammerspoon
My Hammerspoon configuration

⌘ ⌥ ⇧ ⌃ ⇪ Fn ⟵ ⟶ ↑ ↓

Before running, open `init.lua` in your editor and commend/uncomment the modules that you want. Note, if you want to use `gcal`, it takes addition setup, outlined below.

You can launch Hammerspoon from spotlight. Once Hammerspoon is running, you can view a list of shortcuts by typing 'alt+h'.

## Install
Install hammerspoon:

```
brew install hammerspoon
```

clone the repo and symlink it to your hammerspoon configuration folder.

```
ln -s ~/code/dot-hammerspoon ~/.hammerspoon
```

## TODO
- [gcal menu](https://kevzheng.com/hammerspoon-karabiner)
-- DONE: implemented with personal calendar
-- request access with work calendar
-- convert to a spoon for better re-use
-- add ability to launch zoom if meeting has one
-- fix credentials needing to exist in two folders
-- fix hardcoded file paths
-- add install script for manual setup
-- add notify when meeting is starting
- [pomodoro](https://kevzheng.com/hammerspoon-karabiner)
- [seal](http://www.hammerspoon.org/Spoons/Seal.html)
-- [more seal](https://github.com/zzamboni/zzamboni.org/blob/491b3873c9ec632f54df5f363aecbbb49fb4103f/content/post/2018-01-08-my-hammerspoon-configuration-with-commentary.md#seal-seal)
- check out [menuhammer](https://github.com/FryJay/MenuHammer)
- check out [spacehammer](https://github.com/agzam/spacehammer)
- [universalarchive](http://www.hammerspoon.org/Spoons/UniversalArchive.html)
- clipboard manager
- a spoon for zdi that adds a menu displaying running apps/services and has reload/start/stop commands that can be bound to.

## Resources
- https://zzamboni.org/post/my-hammerspoon-configuration-with-commentary/
- https://github.com/zzamboni/zzamboni.org/blob/491b3873c9ec632f54df5f363aecbbb49fb4103f/content/post/2018-01-08-my-hammerspoon-configuration-with-commentary.md#seal-seal

 ctrl # will switch desktops

## Credits

- [gcal menu](https://kevzheng.com/hammerspoon-karabiner)

## gcal

menubar extension to interact with __Google Calendar__ events

![alt text](assets/gcal-preview.png)

**Installation**

1. Make sure you have python3 installed

2. Install python packages

```
pip3 install --upgrade google-api-python-client oauth2client python-dateutil httplib2
```

3. Set PYTHON_BINARY in init.lua to the output of `which python3`

4. Go to [Google Calendar Python
   Quickstart](https://developers.google.com/calendar/quickstart/python) and
   `Enable the Google Calendar API`

5. Download the credentials.json file and save it in the `gcal` folder

6. Run `python3 gcal/gcal.py -e` which should prompt you to log into your
   Google account

Other goodies...

Bookmarks: Set up your bookmarks in bookmarks/bookmarks.json
