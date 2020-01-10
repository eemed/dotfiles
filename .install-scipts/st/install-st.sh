#!/bin/bash
exists()
{
    command -v "$1" >/dev/null 2>&1
    res=$?
    if [ $res -ne 0 ]; then
        echo "Please install $1."
    fi
    return $res
}

exists wget  || exit 1
exists git  || exit 1
exists gcc  || exit 1
exists patch   || exit 1

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
