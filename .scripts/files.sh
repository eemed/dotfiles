#!/bin/bash
# $1 amount of files
# $2 size in bytes

for n in $( eval echo {1..$1} ); do
        echo $n
        dd if=/dev/urandom of=file$( printf %03d "$n" ) bs=1 count=$2
done
