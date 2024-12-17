#!/bin/sh

date=$(date '+%Y-%m-%d_%H:%M:%S')
filename=$(xdg-user-dir PICTURES)/screenshots/satty_edits/$date.png

grim -g "$(slurp -o)" - | satty --filename - --output-filename $filename


