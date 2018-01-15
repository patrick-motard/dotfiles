#!/usr/bin/env bash

# description:
#   This script is useful for auto detection of multiple monitor layouts

#   This script inspects names of monitors connected to computer
#   and assigns them to right, left, and main monitor environment
#   variables, so that Polybar can properly put it's left/right/middle
#   bars in the right place.

#   If your monitors are in a different configuration, edit the
#   strings in the case statement.

# get list of connected monitors, space separated
active_monitors=$(xrandr -q | grep " connected" | awk "{print $"${1:-1}"}" ORS=" ")

# my monitor configurations
# replace with your own (based on the output above)
work="DVI-I-1 DVI-D-0 "
work_laptop="VGA-1 "


case "${active_monitors}" in
    $work )
        MONITOR_MAIN="DVI-I-1"
        MONITOR_RIGHT="DVI-D-0"
        MONITOR_LEFT=""
        mode="work"
        ;;
    $work_laptop )
        MONITOR_MAIN="VGA-1"
        MONITOR_RIGHT=""
        MONITOR_LEFT=""
        mode="work laptop"
        ;;
    * )
        notify-send "Polybar" "Monitor configuration not recognized. See ~/.config/polybar/launch.sh for details"
        ;;
esac

export MONITOR_MAIN=$MONITOR_MAIN
export MONITOR_RIGHT=$MONITOR_RIGHT
export MONITOR_LEFT=$MONITOR_LEFT

killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

polybar -r main &
polybar -r right &

notify-send "Polybar" "Bars initialized on ${mode} monitors."

echo "Bars launched..."
