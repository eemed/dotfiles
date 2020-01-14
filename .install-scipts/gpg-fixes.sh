#!/bin/sh
# Makes tmux use correct window for pinentry
echo 'Match host * exec "gpg-connect-agent UPDATESTARTUPTTY /bye"' >> ~/.ssh/config

gpg --with-keygrip -k
echo 'Give keygrip (the one with Authentication rights):'
read keygrip
echo $keygrip >> ~/.gnupg/sshcontrol
