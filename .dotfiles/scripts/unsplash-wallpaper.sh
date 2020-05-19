#!/usr/bin/env sh
#
# Change wallpaper to a random one
#
# $1 width
# $2 height
# $3 search term

width=$1
height=$2
search_term="minimal"
[[ $# -ge 3 ]]  && search_term=$3

url="https://source.unsplash.com/random"
download_dir="$HOME/.wallpaper"
wallpaper="${download_dir}/wallpaper"

test -d $download_dir || mkdir -p $download_dir
test -f "$wallpaper" && rm "$wallpaper"

wget "${url}/${width}x${height}/?${search_term}" -O "$wallpaper"
gsettings set org.gnome.desktop.background picture-uri "file://${wallpaper}"
