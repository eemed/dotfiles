#!/bin/sh
col=$(xcolor)
echo -n $col | xsel --clipboard
notify-send "Copied '$col'" -i "gpick"
