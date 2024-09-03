#!/bin/sh

date=$(date '+%Y-%m-%d_%H:%M:%S')
filename=$(xdg-user-dir PICTURES)/screenshots/sway_screenshots/$date.png

grim - | satty --filename - --fullscreen --output-filename $filename
