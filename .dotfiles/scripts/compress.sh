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
        convert "$file" -format dds -define dd:mipmaps=1 -define dds:compression=dxt5 "DDS:$out/$filename.dds"
    else
        echo "Skipping '$filename.$extension'."
    fi
done
