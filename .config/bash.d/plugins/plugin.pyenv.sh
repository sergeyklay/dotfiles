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

# Pyenv configuration plugin.
#
# Links:
# * https://github.com/pyenv/pyenv
# * https://github.com/pyenv/pyenv-installer

autoload pathmunge
autoload warn

# Meant for non-interactive login shells.
_plugin_pyenv_login() {
  for dir in ~/.pyenv /opt/homebrew/opt/pyenv /usr/local/opt/pyenv
  do
    if [[ -d "$dir" ]]; then
      PYENV_ROOT="$dir"
      export PYENV_ROOT

      if [[ -d "$dir/bin" ]]; then
        pathmunge "$dir/bin"
      fi

      break
    fi
  done

  if [ -z ${PYENV_SHELL+x} ]; then
    if command -v pyenv >/dev/null 2>&1; then
      eval "$(pyenv init --path)"

      PYENV_VIRTUALENV_DISABLE_PROMPT=1
      export PYENV_VIRTUALENV_DISABLE_PROMPT

      # Automatically activate a Python virtualenv environment
      # based on current pyenv version.
      if pyenv commands | grep -q virtualenv-init ; then
        eval "$(pyenv virtualenv-init -)"
      fi
    else
      warn "command pyenv not found"
      return 1
    fi
  fi
}

# Meant for interactive shells.
_plugin_pyenv() {
  if [ -z ${PYENV_ROOT+x} ] || ! command -v pyenv >/dev/null 2>&1
  then
    warn "pyenv plugin is not configured"
    return 1
  fi

  eval "$(pyenv init -)"
}

# Local Variables:
# mode: shell-script
# End:
