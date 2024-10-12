#!/bin/bash

# Get the current Wi-Fi ESSID
essid=$(nmcli -t -f active,ssid dev wifi | awk -F: '/^yes/ {print $2}')

interface=""
ip_address=""

# If no ESSID is found, set a default value
if [ -z "$essid" ]; then
  echo "No Connection"
else
  interface=$(ip route | grep '^default' | awk '{print $5}')
  ip_address=$(ip addr show "$interface" | grep 'inet ' | awk '{print $2}')

  echo "${essid}: ${ip_address}"
fi
