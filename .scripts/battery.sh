#!/bin/sh
batt_path=/sys/class/power_supply/BAT1

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
