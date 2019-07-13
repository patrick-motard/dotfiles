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


listen() {
    while true
    do
        # the extra space on the right acts like a 'pad-right: 1'
        echo "$(volume get)$padright"
        sleep 0.1 &
        wait
    done
}
while test $# -gt -1; do
	  case "$1" in
        --up)
            volume_up;;
        --down)
            volume_down;;
        --mute)
            volume_mute;;
        --padright)
            padright=$2
            shift;;
        *)
            if [[ -z $padright ]]; then
                padright=""
            fi
            listen;;
    esac
    shift
done
