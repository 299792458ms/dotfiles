#!/bin/sh

date=$(date '+%Y-%m-%d_%H:%M:%S')
filename=$(xdg-user-dir PICTURES)/screenshots/satty_edits/$date.png
activemonitor=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')

grim -o "$activemonitor" - | satty --filename - --fullscreen --output-filename $filename

