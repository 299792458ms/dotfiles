#!/bin/sh

date=$(date '+%Y-%m-%d_%H:%M:%S')
filename=$(xdg-user-dir PICTURES)/screenshots/hyprland_screenshots/$date.png
activemonitor=$(hyprctl -j activeworkspace | jq -r '(.monitor)')

grim -o $activemonitor $filename

if [ -e $filename ]; then
    notify-send "screenshot captured" "active monitor" -i /usr/share/icons/Papirus-Dark/16x16/devices/camera-photo.svg -u low
fi
