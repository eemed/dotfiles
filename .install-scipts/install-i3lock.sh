#!/bin/sh

if ! [ -x $(command -v i3lock) ]; then
    if ! test -d i3lock; then
        git clone https://github.com/PandorasFox/i3lock-color.git i3lock
    fi

    cd i3lock

    autoreconf --force --install

    rm -rf build/
    mkdir -p build && cd build/

    ../configure \
        --prefix=$HOME/.local \
        --sysconfdir=/etc \
        --disable-sanitizers

    make

    cp i3lock ~/.local/bin

    cd ../..

    rm -rf i3lock
fi

if ! test -d better; then
    git clone https://github.com/pavanjadhaw/betterlockscreen.git better
fi

cd better
git checkout multi-monitor
cp betterlockscreen ~/.local/bin
cd ..

rm -rf better
