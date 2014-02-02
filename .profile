# First, get a list of devices plugged in:
# $ xinput list
# Take note of the ID
#
# Get a list of available properties and their current values:
# xinput list-props <ID>
#
# Adjust the mouse scroll speed
xinput --set-prop 8 'Device Accel Constant Deceleration' 1.7
