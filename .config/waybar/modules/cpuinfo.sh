#!/usr/bin/env sh

# CPU model
model=$(cat /proc/cpuinfo | grep 'model name' | head -n 1 | awk -F ': ' '{print $2}' | sed 's/@.*//' | sed 's/(R)//g' | sed 's/(TM)//g')

# CPU utilization
utilization=$(top -bn1 | awk '/^%Cpu/ {print 100 - $8}')

# Clock speed
freqlist=$(cat /proc/cpuinfo | grep "cpu MHz" | awk '{ print $4 }')
maxfreq=$(cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq | sed 's/...$//')
frequency=$(echo $freqlist | tr ' ' '\n' | awk "{ sum+=\$1 } END {printf \"%.0f/$maxfreq MHz\", sum/NR}")

# CPU temp
temp="N/A"
for hwmon in /sys/class/hwmon/*; do
  if [ "$(cat "$hwmon/name")" = "coretemp" ]; then
    temp_raw=$(cat "$hwmon/temp1_input")
    temp_celsius=$((temp_raw / 1000))
    temp="$temp_celsius"
    break
  fi
done

# map icons
set_ico="{\"thermo\":{\"0\":\"󱃃\",\"45\":\"󰔏\",\"65\":\"󱃂\",\"85\":\"󰸁\"},\"util\":{\"0\":\"󰾆\",\"30\":\"󰾅\",\"60\":\"󰓅\",\"90\":\"󰀪\"}}"
eval_ico() {
    map_ico=$(echo "${set_ico}" | jq -r --arg aky "$1" --argjson avl "$2" '.[$aky] | keys_unsorted | map(tonumber) | map(select(. <= $avl)) | max')
    echo "${set_ico}" | jq -r --arg aky "$1" --arg avl "$map_ico" '.[$aky] | .[$avl]'
}

# Ensure temp is a number for jq
if [ "$temp" = "N/A" ]; then
    temp_num="0"
else
    temp_num=$(echo "$temp" | grep -o '[0-9]*' || echo "0")
fi

thermo=$(eval_ico thermo $temp_num)
speedo=$(eval_ico util $utilization)

# Print cpu info (json)
echo "{\"text\":\"${thermo} ${temp}°C\", \"tooltip\":\"${model}\nTemperature: ${temp}°C\nUtilization: ${utilization}%\nClock Speed: ${frequency}\"}"
