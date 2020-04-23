# ~/.bash_aliases
#
# This file contains the definition of aliases.

# Setting alias for emacsclient.
# See '.bash_profile' for more.
alias ec="$EDITOR"

# Color support for grep
alias grep='--color=auto'
alias egrep='egrep --color=auto'

# Wget will use the supplied file as the HSTS database
if command -v wget >/dev/null 2>&1; then
  alias wget="wget --hsts-file="${XDG_CACHE_HOME:-~/.cache}"/wget-hsts"
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

# The Directory Stack Functions \ Aliases.

# Save the current directory on the top of the directory stack
# and then cd to dir.
#
# Meant for 'cd' (see bellow).
function pushd() {
  local dir
  local ssize

  ssize="$(printf '%d' "${DIRSTACKSIZE:-20}")"

  # if $1 is not supplied, the value of the $HOME
  # shell variable is the default
  if [ $# -eq 0 ]; then
    dir="${HOME}"
  else
    dir="$1"

    # This reverts the +/- operators
    if [[ "$dir" =~ ^-([[:digit:]]+)$ ]]; then
      dir="+${BASH_REMATCH[1]}"
    elif [[ "$dir" =~ ^\+([[:digit:]]+)$ ]]; then
      dir="-${BASH_REMATCH[1]}"
    fi

  fi

  # Do not print the directory stack after pushd
  builtin pushd "${dir}" 1>/dev/null || return

  # Limit $DIRSTACK size up to $DIRSTACKSIZE
  if [ "$ssize" -gt 0 ]; then
    while [ ${#DIRSTACK[*]} -gt "$ssize" ]; do
      # Remove last element
      builtin popd -n -0 1>/dev/null || true
    done
  fi
}

# Silently removes the top directory from the stack
# and performs a cd to the new top directory.
#
# Meant for 'back' (see bellow).
function popd() {
  # Do not print the directory stack after popd
  builtin popd 1> /dev/null || return
}

# Move between the current and previous directories
# without popping them from the directory stack.
#
#   $ cd /usr  # We're at /usr now
#   $ cd /tmp  # We're at /tmp now
#   $ flip     # We're at /usr now
function flip() {
  # Do not print the directory stack after pushd
  builtin pushd 1> /dev/null || return
}

# Keep track of visited directories.
#
#   $ dirs -v # See the directores stack
#   $ cd -N   # Go back to a visited folder N
alias cd='pushd'

# Goes to the previous directory that you 'cd'-ed from.
#
#   $ cd ~/ ; cd /tmp # We're at /tmp now
#   $ back            # We're at $HOME now
alias back='popd'

# Local Variables:
# mode: sh
# End:
