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
work_desktop="DVI-I-1 DVI-D-0 "
work_desktop_4k="DVI-I-1 "
work_laptop="VGA-1 "
#home_desktop="HDMI-0 DP-4 "
home_desktop="DVI-D-0 HDMI-0 DP-4 "

function export_monitor_vars() {
    export MONITOR_MAIN=$1
    export MONITOR_RIGHT=$2
    export MONITOR_LEFT=$3
}

function set_monitor_vars() {
    case "${active_monitors}" in
        $work_desktop )
            export_monitor_vars "DVI-I-1" ""  "" #"DVI-D-0"
            mode="work"
            ;;
        $work_desktop_4k )
            export_monitor_vars "DVI-I-1" "" ""
            mode="work"
            ;;
        $work_laptop )
            export_monitor_vars "VGA-1" "" ""
            mode="work laptop"
            ;;
        $home_desktop )
            export_monitor_vars "DP-4" "DVI-D-0" "HDMI-0"
            mode="home desktop"
            ;;
        * )
            notify-send "Polybar" "Monitor configuration not recognized. See ~/.config/polybar/launch.sh for details"
            ;;
    esac
}

set_monitor_vars
notify-send "Polybar" "Bars initialized on ${mode} monitors."

killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

polybar -r main &
polybar -r right &
polybar -r left &
polybar -r main.bottom &
polybar -r left.bottom &

echo "Bars launched..."
