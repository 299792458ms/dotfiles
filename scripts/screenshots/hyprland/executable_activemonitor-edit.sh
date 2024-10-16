#!/bin/sh

date=$(date '+%Y-%m-%d_%H:%M:%S')
filename=$(xdg-user-dir PICTURES)/screenshots/satty_edits/$date.png
activemonitor=$(hyprctl -j activeworkspace | jq -r '(.monitor)')

grim -o $activemonitor - | satty --filename - --fullscreen --output-filename $filename
