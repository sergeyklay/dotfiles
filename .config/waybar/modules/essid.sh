#!/bin/bash

# Get the current Wi-Fi ESSID
essid=$(nmcli -t -f active,ssid dev wifi | awk -F: '/^yes/ {print $2}')

# If no ESSID is found, set a default value
if [ -z "$essid" ]; then
  echo "{\"text\": \"󰤨 WiFi\", \"tooltip\": \"No Connection\"}"
else
  # Some defaults
  ip_address="127.0.0.1"
  gateway="127.0.0.1"
  mac_address="N/A"
  bssid="N/A"
  chan="N/A"
  signal="N/A"
  rx_bitrate=""
  tx_bitrate=""

  active_device=$(nmcli -t -f DEVICE,STATE device status | \
    grep -w "connected" | \
    grep -v -E "^(dummy|lo:)" | \
    awk -F: '{print $1}')

  if [ -n "$active_device" ]; then
    output=$(nmcli -e no -g IP4.ADDRESS,IP4.GATEWAY,GENERAL.HWADDR device show $active_device)

    ip_address=$(echo "$output" | sed -n '1p')
    gateway=$(echo "$output" | sed -n '2p')
    mac_address=$(echo "$output" | sed -n '3p')

    line=$(nmcli -e no -t -f ACTIVE,BSSID,CHAN,FREQ device wifi | grep "^yes")

    bssid=$(echo "$line" | awk -F':' '{print $2":"$3":"$4":"$5":"$6":"$7}')
    chan=$(echo "$line" | awk -F':' '{print $8}')
    freq=$(echo "$line" | awk -F':' '{print $9}')
    chan="$chan ($freq)"

    iw_output=$(iw dev "$active_device" station dump)
    signal=$(echo "$iw_output" | grep "signal:" | awk '{print $2 " dBm"}')

    # Upload speed
    rx_bitrate=$(echo "$iw_output" | grep "rx bitrate:" | awk '{print $3 " " $4}')

    # Download speed
    tx_bitrate=$(echo "$iw_output" | grep "tx bitrate:" | awk '{print $3 " " $4}')
  fi

  tooltip="$essid\n"
  tooltip+="\nIP Address:  ${ip_address}"
  tooltip+="\nRouter:      ${gateway}"
  tooltip+="\nMAC Address: ${mac_address}"
  tooltip+="\nBSSID:       ${bssid}"
  tooltip+="\nChannel:     ${chan}"
  tooltip+="\nSignal:      ${signal}"

  if [ -n "$rx_bitrate" ]; then
    tooltip+="\nRx Rate:     ${rx_bitrate}"
  fi

  if [ -n "$tx_bitrate" ]; then
    tooltip+="\nTx Rate:     ${tx_bitrate}"
  fi

  declare -A myarray=(
    ["text"]="󰤨 WiFi"
    ["tooltip"]=$tooltip
  )

  json="{"

  for key in "${!myarray[@]}"; do
    value=${myarray[$key]}
    json+="\"$key\":\"$value\","
  done

  json="${json%,}}"
  echo "$json"
fi
