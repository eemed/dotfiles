#!/bin/sh
# For cronjobs

export XDG_RUNTIME_DIR=/run/user/$(id -u)
export DISPLAY=:0.0

batt_path=/sys/class/power_supply/BAT1

if ! test -d $batt_path ; then
    exit 1
fi

now=$(cat $batt_path/energy_now)
full=$(cat $batt_path/energy_full)
percentage=$((100 * $now / $full))

status=$(cat $batt_path/status)

if [ $status = "Discharging" ] && [ $percentage -lt 15 ]; then
# if [ $status = "Discharging" ]; then
    /usr/bin/notify-send -u critical "Battery @ $percentage%!"
fi
