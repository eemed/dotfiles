#!/bin/sh
chosen=$(echo "lock|logout|reboot|poweroff|hibernate" | rofi -dmenu -p "Powermenu" -sep "|" -i -theme default)

case $chosen in
    lock)
        ~/.scripts/lock.sh
        ;;
    logout)
        openbox --exit
        ;;
    reboot)
        systemctl reboot
        ;;
    poweroff)
        systemctl poweroff
        ;;
    hibernate)
        systemctl hibernate
        ;;
    *)
        ;;
esac
