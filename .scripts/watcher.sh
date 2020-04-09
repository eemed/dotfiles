#!/usr/bin/env sh
#
# $1 filenames to be watched
# $2 command to run
#
# This >/dev/null 2&1 makes the script magically work in vim

ls $1 | entr -n $2 >/dev/null 2>&1
