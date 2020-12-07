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
#
# For $OSSHORT, $BASHD_ROOT and other variables see '.bash_profile'.

# shellcheck shell=bash

# Color support for grep
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'

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

if command -v todoman >/dev/null 2>&1; then
  alias t="todoman"
elif command -v todo >/dev/null 2>&1; then
  alias t="todo"
fi

# OS specific aliases
if [ -r "$BASHD_ROOT/conf.d/OS/$OSSHORT/aliases.sh" ]; then
  # shellcheck disable=SC1090
  . "$BASHD_ROOT/conf.d/OS/$OSSHORT/aliases.sh"
fi

# Local Variables:
# mode: sh
# End:
