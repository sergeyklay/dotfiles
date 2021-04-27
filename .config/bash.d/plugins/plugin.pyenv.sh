# Copyright (C) 2014-2021 Serghei Iakovlev <egrep@protonmail.ch>
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

autoload pathmunge

# See: https://github.com/pyenv/pyenv-installer
_plugin_pyenv() {


  if [ -z ${PYENV_ROOT+x} ] && [ -d "$HOME/.pyenv" ]; then
    PYENV_ROOT="$HOME/.pyenv"
    export PYENV_ROOT
  fi

  if [ -n "$PYENV_ROOT" ] && [ -d "$PYENV_ROOT/bin" ]; then
    pathmunge "$PYENV_ROOT/bin"
  fi

  if [ -z ${PYENV_SHELL+x} ]; then
    if command -v pyenv >/dev/null 2>&1; then
      eval "$(pyenv init -)"

      if pyenv commands | grep -q virtualenv-init ; then
        eval "$(pyenv virtualenv-init -)"
      fi
    else
      >&2 echo "command pyenv not found"
      return 1
    fi
  fi
}

# Local Variables:
# mode: sh
# End:
