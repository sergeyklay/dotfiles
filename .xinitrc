# initial config
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# font setting
if [[ -d /usr/share/fonts ]]; then
  for d in /usr/share/fonts/*; do
    [[ -d $d ]] && xset +fp "$d";
  done
  xset fp rehash
fi

# update X resources db
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

# make the cursor move the right speed
xset mouse 2 9

# Disable PC Speaker
xset b off

# starts screensaver daemon
xscreensaver -no-splash &

# input
setxkbmap -layout "us,ru" -variant ",winkeys" \
    -option "grp:caps_toggle,grp_led:scroll,compose:ralt,terminate:ctrl_alt_bksp" &

# sets the cursor icon
xsetroot -cursor_name left_ptr & 

# urxvt daemon
urxvtd -q -f -o &

exec awesome

#  vim:ft=sh:ts=8:sw=2:sts=2:tw=78:fenc=utf-8:et
