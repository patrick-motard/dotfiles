#!/usr/bin/env bash

# From: https://github.com/davatorium/rofi/wiki/Script-Launcher
# Takes a list of commands and runs the selected command.

WORKINGDIR="$HOME/.config/rofi/"
MAP="$WORKINGDIR/cmd.csv"

cat "$MAP" \
    | cut -d ',' -f 1 \
    | rofi -dmenu -p "Script: " \
    | head -n 1 \
    | xargs -i --no-run-if-empty grep "{}" "$MAP" \
    | cut -d ',' -f 2 \
    | head -n 1 \
    | xargs -i --no-run-if-empty /bin/bash -c "{}"

exit 0
