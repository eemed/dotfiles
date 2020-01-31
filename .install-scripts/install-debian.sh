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
      stow \
      curl \
      gawk \
      git \
      tree \
      inotify-tools \
      wget \
      tcpdump \
      traceroute \
      mpv \
      feh \
      sxiv \
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
      mupdf \
      python-pip \
      python3-pip \
      openbox \
      obconf \
      xfce4-terminal \
      xserver-xorg \
      x11-xserver-utils \
      libxft-dev \
      firefox-esr \
      thunar \
      rofi \
      compton \
      libnotify-bin \
      nitrogen \
      network-manager-gnome \
      network-manager-openvpn-gnome \
      blueman \
      lxappearance \
      gtk2-engines-murrine \
      pulseaudio \
      dunst \
      sddm \
      tint2 \
      i3lock \
      alsa-utils \
      xsel \
      xclip \
      urlview \
      psmisc \
      xdg-utils \
      libglib2.0-dev \
      arc-theme \
      numix-icon-theme-circle \
      breeze-cursor-theme \
      redshift


./mk-defaultdir.sh
./install-nvim.sh
./install-tmux.sh
./install-tags.sh
./install-font.sh
./install-desktop.sh
./install-greenclip.sh
./install-wallpapers.sh
./relink.sh
