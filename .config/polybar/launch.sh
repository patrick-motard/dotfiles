#!/usr/bin/env bash
active_monitors=$(xrandr -q | grep "connected" | awk "{print $"${1:-1}"}")
echo $active_monitors
# source set-monitors

killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

MONITOR_MAIN="$active_monitors" polybar -r main &
polybar -r left &

echo "Bars launched..."
