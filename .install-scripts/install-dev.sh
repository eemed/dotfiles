#!/usr/bin/env bash


# These must be installed
# sudo apt install -y \
#       build-essential \
#       dh-autoreconf

./install-nvim.sh
./install-tmux.sh
./install-tags.sh
./install-font.sh
./install-scripts.sh
./relink.sh
