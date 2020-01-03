sock="unix:$(mktemp -u --suffix ".kitty")"
kitty -o allow_remote_control=yes --listen-on $sock
