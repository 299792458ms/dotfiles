#!/bin/sh

check=$(bluetoothctl show | rg Powered | cut -d " " -f2)

if [ "$check" = "yes" ]; then
  bluetoothctl power off
elif [ "$check" = "no" ]; then
  bluetoothctl power on
fi
