#!/bin/sh
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
    mkdir ~/.packages
    if ! test -f nvim.tar.gz ; then
      wget https://github.com/neovim/neovim/releases/download/v0.6.0/nvim-linux64.tar.gz -O nvim.tar.gz
    fi
    tar xfv nvim.tar.gz
    mkdir ~/.local
    cp -r $(pwd)/nvim-linux64/* ~/.local

    rm -rf nvim.tar.gz
    rm -rf nvim-linux64

    pip3 install --user pynvim
else
    echo "nvim already installed use '-f' to force"
fi
