#!/usr/bin/env bash
DISPLAY=":0"
files=({{background_images_dir}}/*)
{% raw %}
WALLPAPER=$(printf "%s\n" "${files[RANDOM % ${#files[@]}]}")
WALLPAPER2=$(printf "%s\n" "${files[RANDOM % ${#files[@]}]}")
{% endraw %}
feh -B white --bg-fill $WALLPAPER --bg-fill $WALLPAPER2
