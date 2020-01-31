#!/bin/bash
if man $1 > /dev/null 2>&1 ; then
        man -Tpdf $1 | zathura -
else
        echo "No manual entry for $1"
fi
