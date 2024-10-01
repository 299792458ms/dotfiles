#!/bin/sh

if swaymsg -t get_tree | rg mail80085; then
    swaymsg workspace mail
  else
    swaymsg workspace mail
    footclient -a mail80085 -e aerc
fi
