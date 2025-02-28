# Copyright (C) 2014-2024 Serghei Iakovlev <gnu@serghei.pl>
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

# shellcheck shell=bash

# Setting alias for emacsclient.
# shellcheck disable=SC2139
alias ec="$EDITOR"

# Color support for grep
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'

if command -v colordiff >/dev/null 2>&1; then
  alias diff='colordiff -Nuar'
else
  alias diff='diff -Nuar'
fi

if [ "$(uname)" = "Darwin" ]; then
  # brew install coreutils
  if command -v gls >/dev/null 2>&1; then
    # GNU's ls uses --color to enable colorized output.  For LC_ALL
    # see URL https://superuser.com/a/448294/280737 .
    alias ll='LC_ALL="C.UTF-8" gls --color=auto -alF --group-directories-first'
    alias la='gls --color=auto -A'
    alias l='gls --color=auto -CF'
    alias ls=gls
  else
    # BSD's ls uses -G to enable colorized output.  For LC_ALL see URL
    # https://superuser.com/a/448294/280737 .
    alias ll='LC_ALL="C.UTF-8" ls -G -alF'
    alias la='ls -G -A'
    alias l='ls -G -CF'
  fi

  # brew install make
  if command -v gmake >/dev/null 2>&1; then
    alias make='gmake'
  fi

  # brew install gawk
  if command -v gawk >/dev/null 2>&1; then
    alias awk='gawk'
  fi

  # brew install gnu-tar
  if command -v gtar >/dev/null 2>&1; then
    alias tar='gtar'
  fi

  # brew install gnu-sed
  if command -v gsed >/dev/null 2>&1; then
    alias sed='gsed'
  fi

  # brew install gnu-time
  if command -v gtime >/dev/null 2>&1; then
    alias time='gtime'
  fi

  # brew install coreutils
  if command -v gcp >/dev/null 2>&1; then
    alias cp='gcp'
  fi

  # brew install coreutils
  if command -v gdd >/dev/null 2>&1; then
    alias dd='gdd'
  fi

  # brew install coreutils
  if command -v gdate >/dev/null 2>&1; then
    alias date='gdate'
  fi

  # brew install m4
  if [[ -x /opt/homebrew/opt/m4/bin/m4 ]]; then
    alias m4='/opt/homebrew/opt/m4/bin/m4'
  fi
else
  # For LC_ALL see URL https://superuser.com/a/448294/280737 .
  alias ll='LC_ALL="C.UTF-8" ls --color=auto -alF --group-directories-first'
  alias la='ls --color=auto -A'
  alias l='ls --color=auto -CF'
  alias ls='ls --color=auto'

  if command -v xdg-open >/dev/null 2>&1; then
    open() {
      (xdg-open "$@" &)
    }
  fi
fi

# Color support for ripgrep
if command -v rg >/dev/null 2>&1; then
  alias rg='rg --color=auto'
fi

# Add alias to colorify commands
if tty -s && [ -n "$TERM" ] && [ "$TERM" != dumb ] && command -v grc >/dev/null 2>&1; then
  alias colorify="grc -es"
fi

# Wget will use the supplied file as the HSTS database
if command -v wget >/dev/null 2>&1; then
  alias wget="wget --hsts-file=${XDG_CACHE_HOME:-$HOME/.cache}/wget-hsts"
fi

if command -v clojure >/dev/null 2>&1; then
  alias rebel='clojure -A:rebel'
fi

if command -v nerdctl >/dev/null 2>&1; then
  alias nps="nerdctl ps --format '{{.ID}}    {{.Names}}    {{.Status}}'"
fi

if command -v docker >/dev/null 2>&1; then
  alias dps="docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}'"
fi

# Define kubectl aliases and functions if kubectl is available
command -v kubectl >/dev/null 2>&1 && {
  alias k='kubectl'
  alias kcd='k config set-context $(k config current-context) --namespace '

  # Aliases for context and namespace management
  alias kx='kubectl config use-context ${1:-$(kubectl config current-context)}'
  alias kn='kubectl config set-context --current --namespace ${1:-$(kubectl config view --minify | grep namespace | cut -d" " -f6)}'
}

# 1password plugin for GitHub CLI
if command -v op >/dev/null 2>&1; then
  OP_PLUGIN_ALIASES_SOURCED=1
  export OP_PLUGIN_ALIASES_SOURCED
  alias gh='op plugin run -- gh'
fi

alias memtop="ps aux --sort=-%mem | awk 'NR==1 || NR<=11 {print \$2, \$4, \$11}' | column -t"

# Local Variables:
# mode: sh
# End:
