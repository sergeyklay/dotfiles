#!/bin/bash

# Get the current Wi-Fi ESSID
essid=$(nmcli -t -f active,ssid dev wifi | awk -F: '/^yes/ {print $2}')

# If no ESSID is found, set a default value
if [ -z "$essid" ]; then
  echo "No Connection"
else
  ip_address="127.0.0.1"
  active_device=$(nmcli -t -f DEVICE,STATE device status | \
    grep -w "connected" | \
    grep -v -E "^(dummy|lo:)" | \
    awk -F: '{print $1}')

  if [ -n "$active_device" ]; then
    ip_address=$(nmcli -g IP4.ADDRESS device show $active_device)
  fi

  echo "${essid}: ${ip_address}"
fi
