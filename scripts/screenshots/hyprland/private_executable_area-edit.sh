#!/bin/sh

date=$(date '+%Y-%m-%d_%H:%M:%S')
filename=$(xdg-user-dir PICTURES)/screenshots/hyprland_screenshots/$date.png

grim -g "$(slurp)" - | satty --filename - --output-filename $filename
