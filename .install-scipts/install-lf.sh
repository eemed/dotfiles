#!/bin/bash

wget https://github.com/gokcehan/lf/releases/download/r13/lf-linux-amd64.tar.gz -O lf.tar.gz
tar xfv lf.tar.gz
rm -f lf.tar.gz
mv lf $HOME/.local/bin
