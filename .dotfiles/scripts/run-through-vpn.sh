#!/bin/bash

if test "$#" -ne 1; then
    echo "usage: run-through-vpn.sh <program>"
    exit 1
fi

# Create group
if ! getent group vpnonly; then
    echo "Adding group vpnonly"
    sudo groupadd vpnonly
fi

# Create iptable rule
if ! sudo iptables -L | grep -i "owner GID match vpnonly reject-with icmp-port-unreachable"; then
    echo "Adding vpnonly iptables rule"
    sudo iptables -A OUTPUT -m owner --gid-owner vpnonly \! -o tun0 -j REJECT
fi

# start as user
sudo -g vpnonly $1 &
