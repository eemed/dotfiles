#!/bin/bash
if test -d ~/.themes ; then
    mkdir ~/.themes
fi

git clone --signle-branch --branch mars https://github.com/EliverLara/Sweet.git
git clone https://github.com/eemed/mingreen.git
