#!/usr/bin/env bash
#'/home/$USER/.local/bin/tools/lock' &
xautolock -time 1 -locker <(
    scrot /tmp/screen.png
    convert /tmp/screen.png -scale 10% -scale 1000% /tmp/screen.png
    [[ -f $1 ]] && convert /tmp/screen.png $1 -gravity center -composite -matte /tmp/screen.png
    # pause spotify
    dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Stop
    (i3lock -n -i /tmp/screen.png) &

    # DPMS (monitor standby) stuff.
    # Some stuff like maybe playing music interferes with dpms,
    # so we can't do the "normal" way of sleeping a monitor,
    # which is `xset dpms 0 0 1200` (set a timeout of 1200 seconds)
    # I'm doing it manually here.
    (while :
     do
         # Turn the screen off every 10 minutes (do it forever
         # so that the screen will turn back off if we have a case
         # where the user wakes the screen up, but then gets distracted
         # and doesn't enter their password).
         sleep 1200
         # Only turn the screen off if we've been idle for more than
         # a minute (to avoid turning it off right as the user is
         # entering their password).
         if [ $(xprintidle) -gt 60000 ]; then
             xset dpms force off
         fi
     done) &

    # Wait for i3lock to finish
    wait %1

    # Once i3lock finishes, we can kill the DPMS loop. We only
    # want to do DPMS while i3lock is active.
    kill %2
    rm /tmp/screen.png
)




# #!/usr/bin/env bash

# scrot /tmp/screen.png
# convert /tmp/screen.png -scale 10% -scale 1000% /tmp/screen.png
# [[ -f $1 ]] && convert /tmp/screen.png $1 -gravity center -composite -matte /tmp/screen.png
# # pause spotify
# dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Stop
# (i3lock -n -i /tmp/screen.png) &

# # DPMS (monitor standby) stuff.
# # Some stuff like maybe playing music interferes with dpms,
# # so we can't do the "normal" way of sleeping a monitor,
# # which is `xset dpms 0 0 1200` (set a timeout of 1200 seconds)
# # I'm doing it manually here.
# (while :
# do
#     # Turn the screen off every 10 minutes (do it forever
#     # so that the screen will turn back off if we have a case
#     # where the user wakes the screen up, but then gets distracted
#     # and doesn't enter their password).
#     sleep 1200
#     # Only turn the screen off if we've been idle for more than
#     # a minute (to avoid turning it off right as the user is
#     # entering their password).
#     if [ $(xprintidle) -gt 60000 ]; then
#         xset dpms force off
#     fi
# done) &

# # Wait for i3lock to finish
# wait %1

# # Once i3lock finishes, we can kill the DPMS loop. We only
# # want to do DPMS while i3lock is active.
# kill %2
# rm /tmp/screen.png
