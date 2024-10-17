#!/bin/sh

if swaymsg -t get_tree | rg mail80085; then
  swaymsg workspace κ
  else
  swaymsg workspace κ
  footclient -a mail80085 -e aerc
fi
