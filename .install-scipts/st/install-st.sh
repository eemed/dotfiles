#!/bin/bash
not_inst=0
function check_install() {
    if [ ! $(command -v "$1") ]; then
        echo "$1 not installed."
        export not_inst=1
    fi
}
check_install git
check_install gcc
check_install patch

if [ $not_inst -ne 0 ]; then
    exit 1
fi

# St
wget https://st.suckless.org/patches/scrollback/st-scrollback-0.8.2.diff
wget https://dl.suckless.org/st/st-0.8.2.tar.gz
tar xfv st-0.8.2.tar.gz
rm st-0.8.2.tar.gz

cd st-0.8.2
yes | cp ../config.def.h .
patch -p1 < ../st-scrollback-0.8.2.diff
rm ../st-scrollback-0.8.2.diff
make
mkdir -p ~/.local/bin
cp st ~/.local/bin
cd ..
rm -rf st-0.8.2
