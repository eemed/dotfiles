#!/usr/bin/bash
# Layouts as parameters $1 and $2
if [ $# -ne 2 ]; then
    echo "layout.sh - switch between two keyboard layouts"
    echo "Usage: layout.sh <keymap> <keymap>"
    echo "  Example: layout.sh us fi"
    exit 1
fi

current_layout=$(setxkbmap -query | grep -i layout | cut -d ' ' -f 6)
if [ $current_layout = "$1" ]; then
    setxkbmap "$2"
else
    setxkbmap "$1"
fi
