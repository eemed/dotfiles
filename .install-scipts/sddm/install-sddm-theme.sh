#!/bin/sh
wget https://www.opencode.net/marianarlt/sddm-sugar-candy/-/archive/master/sddm-sugar-candy-master.tar.gz -O sugar.tar.gz

mkdir -p /usr/share/sddm/themes

tar xzf sugar.tar.gz -C /usr/share/sddm/themes

cp theme.conf /usr/share/sddm/themes/sddm-sugar-candy-master/theme.conf
cp sddm.conf /etc/sddm.conf

rm sugar.tar.gz

rm -rf sddm-sugar-candy-master
