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

# macOS-wide Bash environment configuration

# shellcheck shell=bash

# See: https://stackoverflow.com/q/7165108/1661465
LC_ALL=en_US.UTF-8
LANG=en_US.UTF-8

export LC_ALL LANG

# Disable homebrew auto update in macOs
# whenever I run a brew command.
if command -v brew >/dev/null 2>&1 ; then
  HOMEBREW_NO_AUTO_UPDATE=1
  export HOMEBREW_NO_AUTO_UPDATE
fi

if [ -d "$HOME/Library/Caches/Coursier/jvm" ]; then
  JAVA_HOME=$(cd "$HOME/Library/Caches/Coursier/jvm/adopt@"*/Contents/Home; pwd)
  export JAVA_HOME
fi

# Local Variables:
# mode: sh
# End:
