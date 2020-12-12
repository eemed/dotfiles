#!/usr/bin/env bash

# Icons, systray, tweaks
sudo apt install papirus-icon-theme gnome-shell-extension-appindicator gnome-tweaks breeze-cursor-theme

# Juno theme
wget https://github.com/EliverLara/Juno/archive/master.zip
mkdir -p ~/.themes
mv master.zip ~/.themes
cd ~/.themes
unzip master.zip
mv Juno-master Juno
rm -rf master.zip

# Open tweaks -> Extensions and enable
# Userthemes
# Systray

# Open Appearance and set correct themes
