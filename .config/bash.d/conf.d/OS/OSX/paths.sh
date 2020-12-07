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

# Definition of the macOs-wide paths

# shellcheck shell=bash

for dir in "$HOME/Library/Python/"* ; do
  if [ -d "$dir/bin" ]; then
    pathmunge "$dir/bin"
  fi
done

# LLVM
if [ -d /usr/local/opt/llvm/bin ]; then
  pathmunge /usr/local/opt/llvm/bin
fi

# QT
if [ -d /usr/local/opt/qt/bin ]; then
  pathmunge /usr/local/opt/qt/bin
fi

# kubectl
if [ -d /usr/local/opt/kubernetes-cli/bin ]; then
  pathmunge /usr/local/opt/kubernetes-cli/bin
fi

# Local Variables:
# mode: sh
# End:
