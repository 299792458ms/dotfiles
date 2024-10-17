#!/bin/sh

if swaymsg -t get_tree | rg music420; then
  swaymsg workspace µ
  else
  swaymsg workspace µ
  footclient -a music420 -e ncmpcpp
fi
