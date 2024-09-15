#!/bin/sh

date=$(date '+%Y-%m-%d_%H:%M:%S')
filename=$(xdg-user-dir PICTURES)/screenshots/hyprland_screenshots/$date.png

hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | grim -g - $filename

if [ -e $filename ]; then
    notify-send "screenshot captured" "active window" -i /usr/share/icons/Papirus-Dark/16x16/devices/camera-photo.svg -u low
fi
