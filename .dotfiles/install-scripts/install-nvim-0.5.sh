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
exists pip3  || exit 1
exists tar   || exit 1


if [ ! -x "$(command -v nvim)" ] || [ "$1" = "-f" ]; then
    mkdir build
    cd build

    if ! test -f nvim.tar.gz ; then
      wget https://github.com/neovim/neovim/releases/download/v0.5.0/nvim-linux64.tar.gz -O nvim.tar.gz
    fi
    tar xfv nvim.tar.gz
    mkdir ~/.local
    cp -r nvim-linux64/* ~/.local

    pip3 install --user pynvim

    cd ..
    rm -rf build
else
    echo "nvim already installed use '-f' to force"
fi

