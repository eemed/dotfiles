#!/bin/bash

sudo apt update && sudo apt upgrade -y && sudo apt full-upgrade -y

sudo apt install -y \
      build-essential \
      dh-autoreconf

# Applications
sudo apt install -y \
      nfs-common \
      jq \
      fontconfig \
      zip \
      tar \
      mlocate \
      htop \
      atop \
      iftop \
      mc \
      curl \
      gawk \
      git \
      tree \
      inotify-tools \
      wget \
      tcpdump \
      traceroute \
      mpv \
      pavucontrol \
      weechat \
      neofetch \
      scrot \
      ffmpeg \
      zathura \
      zathura-djvu \
      zathura-pdf-poppler \
      gftp \
      vlc \
      pandoc \
      youtube-dl \
      transmission-gtk \
      groff \
      python-pip \
      python3-pip \
      libxft-dev \
      firefox-esr \
      libnotify-bin \
      network-manager-gnome \
      network-manager-openvpn-gnome \
      gnome \
      urlview \
      psmisc \
      xdg-utils \
      libglib2.0-dev \
      arc-theme \
      entr \
      numix-icon-theme-circle \
      breeze-cursor-theme


./mk-defaultdir.sh
./install-nvim.sh
./install-tmux.sh
./install-tags.sh
./install-font.sh
./install-desktop.sh
./install-greenclip.sh
