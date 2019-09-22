#!/usr/bin/env bash
# This script gets the current displays and sets them
# as Xresources that can be referenced at load and reload of i3.

# This way, if you unplug a monitor, or you change your display configuration
# with xrandr or some other tool, and you reload i3, i3 will know which monitors
# are on the left, right or middle. I use that to determine which monitor i want
# a specific workspace to go on.

# The method i'm using below is the only way to set variables dyanmically that is supported
# natively in i3 wm. 

# Resources:
# - https://i3wm.org/docs/userguide.html#xresources
# - https://github.com/i3/i3/issues/1197
# - https://github.com/i3/i3/issues/2387

# Remove our temp file that may exist from a previous call.
rm /tmp/x.tmp

# We want to build a temporary Xresources file, line by line.
# Each line describes a variable we want to use in i3.

# i3wm*display-left is a variable I made up.
# "i3wm" is the program the variable is for.
# This calls my "dot" CLI to get a display by position (left, right, primary).
# For more information on dot, see it's github: https://github.com/patrick-motard/dot
l=$(dot displays -l)
r=$(dot displays -r)
p=$(dot displays -p)
echo "i3wm*display-left: $l" >> /tmp/x.tmp
echo "i3wm*display-right: $r" >> /tmp/x.tmp
echo "i3wm*display-primary: $p" >> /tmp/x.tmp

# Once we have created the temp file, we can merge it into the existing Xresources.
xrdb -merge /tmp/x.tmp
# You can confirm that this worked by calling xrdb -query, and verifying that you see the
# three variables listed above in the output.

# This is for debugging purposes.
# notify-send "displays" "left: $l right: $r primary: $p"
