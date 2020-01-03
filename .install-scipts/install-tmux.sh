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

exists wget || exit 1
exists tar  || exit 1
exists make || exit 1
exists gcc  || exit 1
exists g++  || exit 1
exists git  || exit 1

if [ ! -x "$(command -v tmux)" ] || [ $1 = "-f" ]; then
    mkdir $HOME/.local

    # Libevent
    wget https://github.com/libevent/libevent/releases/download/release-2.1.10-stable/libevent-2.1.10-stable.tar.gz
    tar xfv libevent-2.1.10-stable.tar.gz
    cd libevent-2.1.10-stable
    ./configure --prefix="$HOME/.local"
    make
    make install
    cd ..
    rm -rf libevent-2.1.10-stable libevent-2.1.10-stable.tar.gz

    # Ncurses
    wget https://invisible-mirror.net/archives/ncurses/ncurses-6.1.tar.gz
    tar xfv ncurses-6.1.tar.gz
    cd ncurses-6.1
    ./configure --prefix="$HOME/.local"
    make
    make install
    cd ..
    rm -rf ncurses-6.1 ncurses-6.1.tar.gz

    # Tmux
    wget https://github.com/tmux/tmux/releases/download/2.9/tmux-2.9.tar.gz
    tar xfv tmux-2.9.tar.gz
    cd tmux-2.9
    ./configure CFLAGS="-I$HOME/.local/include -I$HOME/.local/include/ncurses" LDFLAGS="-L$HOME/.local/lib -L$HOME/.local/include/ncurses -L$HOME/.local/include" --prefix="$HOME/.local"
    CPPFLAGS="-I$HOME/.local/include -I$HOME/.local/include/ncurses" LDFLAGS="-static -L$HOME/.local/include -L$HOME/.local/include/ncurses -L$HOME/.local/lib" make
    make install
    cd ..
    rm -rf tmux-2.9 tmux-2.9.tar.gz

    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    source ./dotfiles/bash/.bashrc
    ~/.tmux/plugins/tpm/bin/install_plugins
else
    echo "tmux is already installed use '-f' to force"
fi
