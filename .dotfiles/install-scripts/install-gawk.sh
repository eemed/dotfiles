#!/bin/sh

wget https://ftp.gnu.org/gnu/gawk/gawk-5.0.1.tar.xz
tar xfv gawk-5.0.1.tar.xz
cd gawk-5.0.1
./configure
make
sudo make install

cd ..
rm -rf gawk-*
