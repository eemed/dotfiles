#!/usr/bin/env sh

out="compressed"

if ! test -d "$out" ; then
    mkdir $out
fi

for file in "$@"; do
    filename=$(basename -- "$file")
    extension="${filename##*.}"
    filename="${filename%.*}"
    if [ "$extension" = "png" ]; then
        echo "Converting '$filename.$extension'."
        convert -format dds -define dds:compression=dxt1 $file $out/$filename.dds
    else
        echo "Skipping '$filename.$extension'."
    fi
done
