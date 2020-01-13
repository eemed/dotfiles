#!/bin/bash

for SINK in `pacmd list-sinks | grep 'index:' | cut -b12-`
do
    case $1 in
        "up")
            pactl set-sink-volume $SINK +5%
            ;;
        "down")
            pactl set-sink-volume $SINK -5%
            ;;
        "mute")
            pactl set-sink-mute $SINK toggle
            ;;
        "status")
            if pacmd list-sinks | grep "muted: yes" >/dev/null ; then
                echo ' 婢 muted '
            else
                echo "  $(amixer -D pulse get Master | grep -o -m 1 "\[[0-9]\+\%\]" | tr -d '[]') "
            fi
            exit
            ;;
    esac
done
