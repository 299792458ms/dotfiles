#!/bin/sh

date=$(date '+%Y-%m-%d_%H:%M:%S')
filename=$(xdg-user-dir PICTURES)/screenshots/sway_screenshots/$date.png
activemonitor=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')

grim -o "$activemonitor" $filename

if [ -e $filename ]; then
    notify-send "screenshot captured" "active monitor" -i /usr/share/icons/Papirus-Dark/16x16/devices/camera-photo.svg -u low
fi
