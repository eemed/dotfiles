# include .bashrc if it exists
if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/go/bin" ]; then
  PATH=$PATH:~/go/bin
fi

if [ -d "$HOME/.node/bin" ]; then
  PATH=$PATH:~/.node/bin
fi

if [ -d "$HOME/.apache/bin" ]; then
    PATH=$PATH:~/.apache/bin
fi

export GOPATH=$HOME/go

# Keyboard
xset r rate 200 30
