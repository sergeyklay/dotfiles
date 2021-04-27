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

_find_python() {
  local keyword
  local -i total

  if [ $# -eq 0 ]; then
    keyword=python3
  else
    keyword="$1"
  fi

  # First try to search python using pyenv
  if command -v pyenv >/dev/null 2>&1 ; then
    pyenv which "$keyword" 2>/dev/null
    return 0
  fi

  # The `type's arguments are used for:
  #
  #   -f    suppress shell function lookup
  #   -p    returns the name of the disk file that would be executed
  #   -a    display all locations containing python
  total="$(type -f -p -a "$keyword" | grep -c -v shims)"

  # Only shims?
  if [ "$total" -eq 0 ]; then
    command -v "$keyword" 2>/dev/null
    return 0
  fi

  # Build a list of all installed Python versions and echo the
  # return one.
  #
  # Example of the output in the 'for' loop:
  #
  #   Python 3.8.2|/usr/bin/python3
  #   Python 3.9.4|/opt/homebrew/bin/python3
  #
  for p in $(type -f -p -a "$keyword" | grep -v shims); do
    echo "$($p --version)|$p"
  done | sort -n | tail -n 1 | awk -F'|' '{print $2}'
}

_plugin_venv() {
  # The variable WORKON_HOME tells virtualenvwrapper where to place
  # your virtual environments. If the directory does not exist when
  # virtualenvwrapper is loaded, it will be created automatically.
  if [ -z ${WORKON_HOME+x} ]; then
    if [ -d ~/.virtualenvs ]; then
      WORKON_HOME="$HOME/.virtualenvs"
      export WORKON_HOME
    fi
  fi

  # The variable PROJECT_HOME tells virtualenvwrapper where to place
  # your project working directories. The variable PROJECT_HOME tells
  # virtualenvwrapper where to place your project working directories.
  if [ -z ${PROJECT_HOME+x} ]; then
    if [ -d ~/work ]; then
      PROJECT_HOME="$HOME/work"
      export PROJECT_HOME
    fi
  fi

  # Provide a way to override VIRTUALENVWRAPPER_PYTHON variable
  if [ -z ${VIRTUALENVWRAPPER_PYTHON+x} ]; then
    # The variable VIRTUALENVWRAPPER_PYTHON tells virtualenvwrapper
    # the full path of the interpreter to use.
    if command -v python3 >/dev/null 2>&1 && [ -n "$WORKON_HOME" ]
    then
      VIRTUALENVWRAPPER_PYTHON="$(_find_python python3)"
      export VIRTUALENVWRAPPER_PYTHON
    elif command -v python >/dev/null 2>&1; then
      VIRTUALENVWRAPPER_PYTHON="$(_find_python python)"
      export VIRTUALENVWRAPPER_PYTHON
    fi
  fi

  if [ -n "$WORKON_HOME" ] && \
       command -v virtualenvwrapper_lazy.sh >/dev/null 2>&1 ; then
    # shellcheck disable=SC1090
    . "$(command -v virtualenvwrapper_lazy.sh 2>/dev/null)"
  fi
}

# Local Variables:
# mode: sh
# End:
