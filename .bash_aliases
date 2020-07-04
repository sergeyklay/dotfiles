# ~/.bash_aliases
#
# This file contains the definition of aliases.

# Setting alias for emacsclient.  See '.bash_profile' for more.
# shellcheck disable=SC2139
alias ec="$EDITOR"

# Color support for grep
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'

# Wget will use the supplied file as the HSTS database
if command -v wget >/dev/null 2>&1; then
  # shellcheck disable=SC2139
  alias wget="wget --hsts-file='${XDG_CACHE_HOME:-~/.cache}/wget-hsts'"
fi

if command -v docker >/dev/null 2>&1; then
  alias dps="docker ps --format 'table {{.ID}}\\t{{.Names}}\\t{{.Status}}'"
fi

if command -v kubectl >/dev/null 2>&1; then
  alias k='kubectl'
  alias kcd='k config set-context $(k config current-context) --namespace '
fi

if command -v clojure >/dev/null 2>&1; then
  alias rebel='clojure -A:rebel'
fi

if command -v colordiff >/dev/null 2>&1; then
  alias diff='colordiff -Nuar'
else
  alias diff='diff -Nuar'
fi

if command -v transmission-daemon >/dev/null 2>&1; then
  alias t-start='sudo service transmission-daemon start'
  alias t-stop='sudo service transmission-daemon stop'
  alias t-reload='sudo service transmission-daemon reload'
  alias t-list='transmission-remote -n 'transmission:transmission' -l'
  alias t-basicstats='transmission-remote -n 'transmission:transmission' -st'
  alias t-fullstats='transmission-remote -n 'transmission:transmission' -si'
fi

case $OS in
  Darwin)
    # brew install coreutils
    if command -v gls >/dev/null 2>&1; then
      # GNU's ls uses --color to enable colorized output.
      # For LC_ALL see URL https://superuser.com/a/448294/280737
      alias ll='LC_ALL="C.UTF-8" gls --color=auto -alF --group-directories-first'
      alias la='gls --color=auto -A'
      alias l='gls --color=auto -CF'
    else
      # BSD's ls uses -G to enable colorized output.
      # For LC_ALL see URL https://superuser.com/a/448294/280737
      alias ll='LC_ALL="C.UTF-8" ls -G -alF'
      alias la='ls -G -A'
      alias l='ls -G -CF'
    fi

    # macOS uses too outdated make.  I prefer install a fresh one
    # using brew and alias it here.
    if command -v gmake >/dev/null 2>&1; then
      alias make='gmake'
    fi
    ;;
  *Linux)
    # GNU's ls uses --color to enable colorized output.
    # For LC_ALL see URL https://superuser.com/a/448294/280737
    alias ll='LC_ALL="C.UTF-8" ls --color=auto -alF --group-directories-first'
    alias la='ls --color=auto -A'
    alias l='ls --color=auto -CF'

    if command -v xdg-open >/dev/null 2>&1; then
      open() {
        (xdg-open "$@" &)
      }
    fi

    # Miscellaneous aliases
    alias remax="systemctl --user restart emacs"
    ;;
esac

# Local Variables:
# mode: sh
# flycheck-disabled-checkers: (sh-posix-dash sh-shellcheck)
# End:
