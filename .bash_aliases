# Copyright (C) 2014-2020 Serghei Iakovlev <egrep@protonmail.ch>
#
# This file is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 3
# of the License, or (at your option) any later version.
#
# This file is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this file.  If not, see <https://www.gnu.org/licenses/>.

# This file contains the definition of aliases.

# shellcheck shell=bash

# Setting alias for emacsclient.  See '.bash_profile' for more.
if [ -n "$EDITOR" ]; then
  # shellcheck disable=SC2139
  alias ec="$EDITOR"
fi

# Color support for grep
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'

# Color support for ripgrep
if command -v rg >/dev/null 2>&1; then
  alias rg='rg --color=auto'
fi

# Wget will use the supplied file as the HSTS database
if command -v wget >/dev/null 2>&1; then
  # shellcheck disable=SC2139
  alias wget="wget --hsts-file=${XDG_CACHE_HOME:-$HOME/.cache}/wget-hsts"
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

if command -v todoman >/dev/null 2>&1; then
  alias t="todoman"
elif command -v todo >/dev/null 2>&1; then
  alias t="todo"
fi

# Local Variables:
# mode: sh
# End:
