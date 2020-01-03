#!/bin/sh

echo "" | rofi -dmenu -p "DuckDuckGo:" -theme search | xargs -I{} gio open https://duckduckgo.com/?q={}
