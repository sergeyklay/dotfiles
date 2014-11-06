# use ~/.bashrc
[[ -f ~/.bashrc ]] && . ~/.bashrc

# local run (per user) of mpd
[[ ! -s ~/.config/mpd/pid ]] && mpd

# default ruby binaries path, can be overridden interactive
export RUBY_BIN=$(which ruby | sed 's/ruby$//')

# vim:ft=sh:ts=8:sw=2:sts=2:tw=80:et
