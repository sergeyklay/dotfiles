#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# update x resources db
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

# make the cursor move the right speed
xset mouse 2 9

# starts screensaver daemon
xscreensaver -no-splash &

# input
setxkbmap -model "pc105" -layout "us,ru" -variant ",winkeys" -option "grp:caps_toggle,grp_led:scroll,compose:ralt,terminate:ctrl_alt_bksp" &

# sets the cursor icon
xsetroot -cursor_name left_ptr & 

# urxvt daemon
urxvtd -q -f -o &

exec awesome

