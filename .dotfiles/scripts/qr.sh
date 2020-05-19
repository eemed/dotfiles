#!/bin/bash
temp="$(mktemp).png"
qrencode -l L -v 1 -s 10 -o $temp $1
sxiv $temp
rm $temp
