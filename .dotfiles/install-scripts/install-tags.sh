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

exists make || exit 1
exists gcc  || exit 1
exists g++  || exit 1
exists git  || exit 1


if [ ! -x "$(command -v ctags)" ] || [ $1 = "-f" ]; then
    mkdir build
    cd build

    git clone https://github.com/universal-ctags/ctags.git
    cd ctags
    ./autogen.sh 
    ./configure --prefix ~/.local
    make
    make install
    cd ..

    cd ..
    rm -rf build
else
    echo "universal ctags is already installed use '-f' to force"
fi

