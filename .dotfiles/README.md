# Setup

## Config

Clone repo create alias and and checkit out
```
git clone --bare <git-repo-url> $HOME/.cfg
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config checkout
config config --local status.showUntrackedFiles no
```

## Gitconfig

link git config:
```
ln -s .dotfiles/gitconfig .gitconfig
```
