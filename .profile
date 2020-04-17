# ~/.profile
#
# User wide environment and startup programs, for login setup.
#
# This file is sourced by the first for login shells.

# Editor to fallback to if the server is not running.  If this
# variable is empty, then start GNU Emacs in daemon mode and try
# connecting again.
export ALTERNATE_EDITOR=''

# See:
# https://github.com/sergeyklay/.emacs.d/blob/master/bin/emacsclient.wrapper
export EDITOR=emacsclient.wrapper
export VISUAL=$EDITOR

alias ec=$EDITOR

# A workaround to get OS name on Linux and macOS systems
export OS="$(uname -o 2>/dev/null || uname -s)"

# HOSTNAME contains name of the machine, as known to applications
# that run locally
if [ x$HOSTNAME = x ]; then
  if command -v hostname >/dev/null 2>&1; then
    export HOSTNAME=$(hostname -s)
  else
    export HOSTHAME=localhost
  fi
fi

# HOST contains long host name (FQDN)
if [ x$HOST = x ]; then
  if command -v hostname >/dev/null 2>&1; then
    export HOST=$(hostname -f)
  else
    export HOST="${HOSTNAME}.localdomain"
  fi
fi

case $OS in
  Darwin)
    # See: https://stackoverflow.com/q/7165108/1661465
    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8
    ;;
  *Linux)
    [ -r ${XDG_CONFIG_HOME:-~/.config}/xdg-dirs ] && {
      . ${XDG_CONFIG_HOME:-~/.config}/xdg-dirs
    }
    ;;
esac

# This file is accessible not only by Bash, thus we need make
# sure we're in Bash
if [ -n "$BASH_VERSION" ]; then
  # Include '.bashrc' if it exists
  [ -r ~/.bashrc ] && . ~/.bashrc
fi

# Local Variables:
# mode: sh
# End:
