#!/bin/sh

date=$(date '+%Y-%m-%d_%H:%M:%S')
filename=$(xdg-user-dir PICTURES)/screenshots/sway_screenshots/$date.png
activewindow=$(swaymsg -t get_tree | jq -j '.. | select(.type?) | select(.focused).rect | "\(.x),\(.y) \(.width)x\(.height)"')


grim -g "$activewindow" - | satty --filename - --fullscreen --output-filename $filename
