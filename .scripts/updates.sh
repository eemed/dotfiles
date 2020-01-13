#!/bin/sh
upgrade=$(apt-get upgrade -s |grep -P '^\d+ upgraded'|cut -d" " -f1)
if [ $upgrade -gt 0 ]; then
    echo " $upgrade"
fi
