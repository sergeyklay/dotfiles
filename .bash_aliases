# This file contains the definition of aliases.

# Color support for grep
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'

# Wget will use the supplied file as the HSTS database
if command -v wget >/dev/null 2>&1; then
  alias wget="wget --hsts-file=${XDG_CACHE_HOME:-~/.cache}/wget-hsts"
fi

if command -v docker >/dev/null 2>&1; then
  alias dps="docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}'"
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

case $OS in
  Darwin)
    # brew install coreutils
    if command -v gls >/dev/null 2>&1; then
      # GNU's ls uses --color to enable colorized output.
      # For LC_ALL see URL https://superuser.com/a/448294/280737 .
      alias ll='LC_ALL="C.UTF-8" gls --color=auto -alF --group-directories-first'
      alias la='gls --color=auto -A'
      alias l='gls --color=auto -CF'
    else
      # BSD's ls uses -G to enable colorized output.
      # For LC_ALL see URL https://superuser.com/a/448294/280737 .
      alias ll='LC_ALL="C.UTF-8" ls -G -alF'
      alias la='ls -G -A'
      alias l='ls -G -CF'
    fi

    # macOS uses too outdated make.   I prefer install a frew one using
    # brew and alias it here.
    if command -v gmake >/dev/null 2>&1; then
      alias make='gmake'
    fi
    ;;
  *Linux)
    # GNU's ls uses --color to enable colorized output.
    # For LC_ALL see URL https://superuser.com/a/448294/280737 .
    alias ll='LC_ALL="C.UTF-8" ls --color=auto -alF --group-directories-first'
    alias la='ls --color=auto -A'
    alias l='ls --color=auto -CF'

    if command -v xdg-open >/dev/null 2>&1; then
      open() {
        (xdg-open $@ &)
      }
    fi

    # Miscellaneous aliases
    alias remax="systemctl --user restart emacs"
    ;;
esac

# Local Variables:
# mode: sh
# End:
