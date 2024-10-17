#!/bin/sh

if lswt | rg music420; then
  riverctl set-focused-tags $((1 << 10))
  else
  riverctl set-focused-tags $((1 << 10))
  footclient -a music420 -e ncmpcpp
fi
