# ~/.bash_aliases
#
# This file contains the definition of aliases.

ca=""
if [ "$colors_support" = true ]; then
  ca="--color=auto"
fi

# emacsclient
alias ec=$EDITOR

# Color support for grep
alias grep="grep $ca"
alias egrep="egrep $ca"

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
      # For LC_ALL see URL https://superuser.com/a/448294/280737
      alias ll="LC_ALL='C.UTF-8' gls $ca -alF --group-directories-first"
      alias la="gls $ca -A"
      alias l="gls $ca -CF"
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
    alias ll="LC_ALL='C.UTF-8' ls $ca -alF --group-directories-first"
    alias la="ls $ca -A"
    alias l="ls $ca -CF"

    if command -v xdg-open >/dev/null 2>&1; then
      open() {
        (xdg-open $@ &)
      }
    fi

    # Miscellaneous aliases
    alias remax="systemctl --user restart emacs"
    ;;
esac

unset ca

# Local Variables:
# mode: sh
# End:
