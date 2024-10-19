#!/bin/sh

if lswt | rg geary; then
  riverctl set-focused-tags $((1 << 11))
  else
  riverctl set-focused-tags $((1 << 11))
  # footclient -a mail80085 -e aerc
  geary
fi
