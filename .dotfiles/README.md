# Setup

## Config

Clone repo create alias and and checkit out
```
git clone --bare <git-repo-url> $HOME/.cfg
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config checkout
config config --local status.showUntrackedFiles no
```

## Keys and pass

Plug usb and import gpg keys, public keys and sub private key.
```
gpg --import <key>
```

Log into github to add ssh key.
Initialize pass and add remote
```
pass git init
pass git remote add origin <url>
```

Passwords should now be usable.

## Bashrc

Edit ~/.bashrc
Install nvim and run `:Pluginstall` to install fzf.


## Gitconfig

link git config:
```
ln -s .dotfiles/gitconfig .gitconfig
```
