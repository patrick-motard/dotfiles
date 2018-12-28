#!/bin/sh
# start virtualbox client scripts
#/usr/bin/VBoxClient-all

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# lock screen after 5min
xautolock -time 5 -locker '/home/$USER/.local/bin/tools/lock' &
# NOTE: This display timeout logic was moved to the lock tool.
# set display timeout to 10min
# xset dpms 0 0 1200

# lock screen after 5min
# xautolock -time 5 -locker '/home/$USER/.local/bin/tools/lock' &

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# this allows you to have both headphones and speakers plugged in and switch
# between the two using the polybar module. Auto-Mute mode is when alsa mutes
# speakers whenever headphones are plugged in.
/usr/bin/amixer -c 0 sset "Auto-Mute Mode" Disabled

exec i3
