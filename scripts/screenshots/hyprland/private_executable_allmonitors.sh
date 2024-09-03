#!/bin/sh

date=$(date '+%Y-%m-%d_%H:%M:%S')
filename=$(xdg-user-dir PICTURES)/screenshots/hyprland_screenshots/$date.png

grim $filename

if [ -e $filename ]; then
    notify-send "screenshot captured" "all monitors" -i /usr/share/icons/Papirus-Dark/16x16/devices/camera-photo.svg -u low
fi
