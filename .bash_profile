# use ~/.bashrc
[[ -f ~/.bashrc ]] && . ~/.bashrc

# Load RVM into a shell session *as a function*
[[ -s ~/.rvm/scripts/rvm ]] && . ~/.rvm/scripts/rvm

# Adjust the mouse scroll speed
xinput --set-prop 8 'Device Accel Constant Deceleration' 1.7
