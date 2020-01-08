#!/usr/bin/env sh

git clone https://github.com/dylanaraps/paleta
cd paleta
sudo make install
cd ..
rm -rf paleta
