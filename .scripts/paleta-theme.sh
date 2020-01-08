#!/bin/bash
if [ $# -eq 0 ] && [ -x "$(command -v rofi)" ] ; then
    theme=$(echo -ne "dark\nlight" | rofi -p "Switch to theme:" -dmenu -theme default)
else
    theme=$1
fi

current_theme=$(~/.scripts/paleta-current-theme.sh)
if [ $theme = "dark" ]; then
    if [ $current_theme = "light" ]; then
        killall -s 10 nvim >/dev/null
    fi
    paleta < $HOME/.colors/pal-dark

elif [ $theme = "light" ]; then
    if [ $current_theme = "dark" ]; then
        killall -s 10 nvim >/dev/null
    fi
    paleta < $HOME/.colors/pal-light
fi
