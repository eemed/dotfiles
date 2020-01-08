#!/bin/bash
if [ $# -eq 0 ]; then
        page=$(man -k . | awk '{print $1;}' | rofi -dmenu -theme default)
else
        page=$1
fi

if man $page > /dev/null 2>&1 ; then
        man -Tpdf $page | zathura -
else
        echo "No manual entry for $page"
fi
