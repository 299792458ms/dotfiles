#!/bin/sh

if swaymsg -t get_tree | rg geary; then
    swaymsg workspace mail
  else
    swaymsg workspace mail
    geary
fi
