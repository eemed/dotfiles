#!/usr/bin/env bash
if test -f ~/.cache/pal/colors ; then
    bg_hex=$(grep -o "#[a-fA-F0-9]\{6\}" ~/.cache/paleta/colors | head -n1 | tr -d '#')
    r=$(printf "%d" 0x${bg_hex:0:2})
    g=$(printf "%d" 0x${bg_hex:2:2})
    b=$(printf "%d" 0x${bg_hex:4:2})

    # 382 = (255 + 255 + 255) / 2
    if [ $(($r + $g + $b)) -gt 382 ]; then
        echo "light"
    else
        echo "dark"
    fi

    exit $?
else
    exit 1
fi
