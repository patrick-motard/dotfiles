#!/usr/bin/env bash

options=$(find ~/.config/polybar/themes -mindepth 1 -maxdepth 1 -type d -and -not -name '*global*' -printf '%f\n')
rofi_theme=${1:-$HOME/.config/rofi/config.rasi}
theme=$(echo -e "${options}" | rofi -dmenu -config $rofi_theme)

# make sure to not kill polybar theme didn't change (or wasnt chosen)
if [[ -z $theme ]]; then
    exit 1
fi
if [[ $theme == 'nord' ]]; then

    i3-msg gaps top all set 80
else

    i3-msg gaps top all set 10
fi

polybar_theme=~/.config/polybar/themes/$theme/config sh ~/.config/polybar/launch.sh
