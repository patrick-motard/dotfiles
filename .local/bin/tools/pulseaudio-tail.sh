#!/bin/sh

volume_up() {
    sink=$(pacmd list | grep '*' | awk 'NR==1{print $3}')
    pactl set-sink-volume $sink +1%
}

volume_down() {
    sink=$(pacmd list | grep '*' | awk 'NR==1{print $3}')
    pactl set-sink-volume $sink -1%
}

volume_mute() {
    sink=$(pacmd list | grep '*' | awk 'NR==1{print $3}')
    pactl set-sink-mute $sink toggle
}

volume_print() {
    sink=$(pacmd list | grep '*' | awk 'NR==1{print $3}')
    volume=$(pamixer --sink $sink --get-volume)
    echo $volume

    # if [ "$muted" = true ]; then
    #     echo "#1 --"
    # else
        # volume=$(pamixer --sink $sink --get-volume)
        # echo $volume

        # if [ "$volume" -lt 50 ]; then
        #     echo "#2 $volume %"
        # else
        #     echo "#3 $volume %"
        # fi
    # fi
}

listen() {
    volume_print
    pactl subscribe | while read -r event; do
        if echo "$event" | grep -q "#$sink"; then
            volume_print
        fi
    done
}

case "$1" in
    --up)
        volume_up;;
    --down)
        volume_down;;
    --mute)
        volume_mute;;
    *)
        listen;;
esac
