#!/bin/sh

date=$(date '+%Y-%m-%d_%H:%M:%S')
filename=$(xdg-user-dir PICTURES)/screenshots/sway_screenshots/$date.png
activewindow=$(swaymsg -t get_tree | jq -j '.. | select(.type?) | select(.focused).rect | "\(.x),\(.y) \(.width)x\(.height)"') 

grim -g "$activewindow" $filename;

if [ -e $filename ]; then
    notify-send "screenshot captured" "active window" -i /usr/share/icons/Papirus-Dark/16x16/devices/camera-photo.svg -u low
fi
