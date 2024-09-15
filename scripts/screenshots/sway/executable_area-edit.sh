#!/bin/sh

date=$(date '+%Y-%m-%d_%H:%M:%S')

grim -g "$(slurp)" -| satty --filename - --output-filename ~/Pictures/screenshots/edits/satty-$date.png


