#!/bin/sh
batt_path=/sys/class/power_supply/BAT1

if ! test -d $batt_path ; then
    exit 1
fi

now=$(cat $batt_path/energy_now)
full=$(cat $batt_path/energy_full)
percentage=$((100 * $now / $full))

status=$(cat $batt_path/status)

if [ $status = "Discharging" ]; then
    icon=''
else
    icon=''
fi

echo " $icon $percentage% "
