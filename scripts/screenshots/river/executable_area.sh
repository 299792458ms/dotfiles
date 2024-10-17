#!/bin/sh

date=$(date '+%Y-%m-%d_%H:%M:%S')
filename=$(xdg-user-dir PICTURES)/screenshots/river_screenshots/$date.png

grim -g "$(slurp)" $filename;

if [ -e $filename ]; then
    notify-send "screenshot captured" "selected area" -i /usr/share/icons/Papirus-Dark/16x16/devices/camera-photo.svg -u low
fi
