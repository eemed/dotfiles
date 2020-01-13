#!/bin/bash
if [ ! -d ~/.fonts ]; then
    mkdir ~/.fonts
fi

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/Hack.zip
unzip Hack.zip -d ~/.fonts
rm Hack.zip

# wget https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.tar.gz -O hack.tar.gz
# tar xfv hack.tar.gz 
# cp -r ttf/* ~/.fonts
# rm -rf hack.tar.gz ttf

fc-cache -fv
