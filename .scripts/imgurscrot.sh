#!/bin/bash
#
# Upload scrot images straight to imgur
# ~/.imgur-key.sh should define client_id and client_secret used
#
if test -f ~/.imgur-key.sh; then
  source ~/.imgur-key.sh
else
  echo 'Cant find `client_id` and `client_secret` in ~/.imgur-key.sh'
  exit 1
fi

gnome-screenshot -a -f "shot.png"
json=$(curl -s --request POST --url https://api.imgur.com/3/image \
  --header "authorization: Client-ID $client_id" \
  --header "content-type: multipart/form-data;" -F "image=@shot.png")

success=$(echo $json | jq '.success')

if [ "$success" == "true" ]; then
  link=$(echo $json | jq '.data.link' | tr -d \")

  echo $link | xsel --clipboard

  # Open in browser
  #gio open $link

  # Notify upload
  notify-send "Image uploaded to $link" -i "viewimage"
fi

rm "shot.png"
