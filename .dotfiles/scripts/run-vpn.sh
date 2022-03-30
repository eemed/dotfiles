#!/bin/bash

if test "$#" -ne 1; then
    echo "usage: run-vpn.sh <.ovpn config>"
    exit 1
fi

if ! grep "up /etc/openvpn/update-resolv-conf"; then
    echo "up /etc/openvpn/update-resolv-conf" >> $1
    echo "down /etc/openvpn/update-resolv-conf" >>  $1
fi

sudo openvpn --config $1
