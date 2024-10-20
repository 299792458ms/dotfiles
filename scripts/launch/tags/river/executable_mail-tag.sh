#!/bin/sh

if lswt | rg mail80085; then
  riverctl set-focused-tags $((1 << 11))
  else
  riverctl set-focused-tags $((1 << 11))
  footclient -a mail80085 -e aerc
  # geary
fi
