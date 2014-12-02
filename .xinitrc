#!/usr/bin/env sh
#
# Executed by startx (run your window manager from here)

# Aditional config
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# Fonts setting
if [[ -d /usr/share/fonts ]]; then
  for d in /usr/share/fonts/*; do
    [[ -d $d ]] && xset +fp "$d";
  done
  xset fp rehash
fi

# Update X resources db
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

# Use xpofile (if any)
[[ -f /etc/xprofile ]] && source /etc/xprofile
[[ -f ~/.xprofile ]] && source ~/.xprofile

# make the cursor move the right speed
xset mouse 2 9

# Disable PC Speaker
xset b off

# Starts screensaver daemon
xscreensaver -log ~/log/xscreensaver -no-splash &

# Input
setxkbmap -layout "us,ru" -variant ",winkeys" \
    -option "grp:caps_toggle,grp_led:scroll,compose:ralt,terminate:ctrl_alt_bksp" &

# Sets the cursor icon
xsetroot -cursor_name left_ptr &

# urxvt daemon
urxvtd -q -f -o &

exec awesome >> ~/log/awesome/stdout 2>> ~/log/awesome/stderr

#  vim:ft=sh:ts=4:sw=2:sts=2:tw=78:fenc=utf-8:et
