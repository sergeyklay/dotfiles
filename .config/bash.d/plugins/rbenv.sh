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

# shellcheck shell=bash

autoload pathmunge

function _plugin_rbenv {
  for dir in ~/.rbenv "/usr/local/opt/rbenv"; do
    if [[ -d "$dir/bin" ]]; then
      pathmunge "$dir/bin"
      break
    fi
  done

  if [ -z ${RBENV_SHELL+x} ]; then
    if command -v rbenv >/dev/null 2>&1; then
      eval "$(rbenv init -)"
    else
      >&2 echo "command rbenv not found"
      return 1
    fi
  fi
}

# Local Variables:
# mode: sh
# End:
