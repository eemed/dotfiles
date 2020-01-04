#!/bin/bash
if [ -x "$(command -v rofi)" ] ; then
        theme=$(echo -ne "dark\nlight" | rofi -p "Switch to theme:" -dmenu -theme default)
else
        theme=$1
fi

current_theme=$(~/.scripts/pal_theme)

if [ $theme = "dark" ]; then
        if [ $current_theme = "light" ]; then
                killall -s 10 nvim
        fi
        paleta < $HOME/.colors/pal-dark

elif [ $theme = "light" ]; then
        if [ $current_theme = "dark" ]; then
                killall -s 10 nvim
        fi
        paleta < $HOME/.colors/pal-light
fi
