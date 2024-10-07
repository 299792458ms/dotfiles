#!/bin/sh

cliphist list | fuzzel --dmenu --config ~/.config/fuzzel/fuzzel_wlc.ini | cliphist delete
