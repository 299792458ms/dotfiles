#!/bin/sh

if swaymsg -t get_tree | rg music420; then
    swaymsg workspace music
  else
    swaymsg workspace music
    footclient -a music420 -e ncmpcpp;
fi
