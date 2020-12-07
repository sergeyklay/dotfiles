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

# Python's Virtualenv configuration

# shellcheck shell=bash

# The variable WORKON_HOME tells virtualenvwrapper where to place
# your virtual environments. If the directory does not exist when
# virtualenvwrapper is loaded, it will be created automatically.
if [ -z ${WORKON_HOME+x} ]; then
  if [ -d "$HOME/.virtualenvs" ]; then
    WORKON_HOME=~/.virtualenvs
    export WORKON_HOME
  fi
fi

# The variable PROJECT_HOME tells virtualenvwrapper where to place
# your project working directories. The variable PROJECT_HOME tells
# virtualenvwrapper where to place your project working directories.
if [ -z ${PROJECT_HOME+x} ]; then
  if [ -d "$HOME/work" ]; then
    PROJECT_HOME=~/work
    export PROJECT_HOME
  fi
fi

# The variable VIRTUALENVWRAPPER_PYTHON tells virtualenvwrapper the
# full path of the interpreter to use.
if command -v python3 >/dev/null 2>&1 && [ -n "${WORKON_HOME+x}" ]
then
  VIRTUALENVWRAPPER_PYTHON="$(command -v python3 2>/dev/null)"
  export VIRTUALENVWRAPPER_PYTHON
elif command -v python >/dev/null 2>&1; then
  VIRTUALENVWRAPPER_PYTHON="$(command -v python 2>/dev/null)"
  export VIRTUALENVWRAPPER_PYTHON
fi

if [ -n "${WORKON_HOME+x}" ] && \
     command -v virtualenvwrapper_lazy.sh >/dev/null 2>&1 ; then
  # shellcheck disable=SC1090
  . "$(command -v virtualenvwrapper_lazy.sh 2>/dev/null)"
fi

# Local Variables:
# mode: sh
# End:
