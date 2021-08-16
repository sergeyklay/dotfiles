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

autoload pathmunge

# At some point here there may be several Python versions here.
# I need only the latest one
test -d $HOME/Library/Python && {
  _d="$HOME/Library/Python"
  _latest="$(find "$_d" -type d -depth 1 | sort -nr | head -n 1)"

  if [[ -n "$_latest" ]] && [[ -d $_latest/bin ]]; then
    pathmunge "$_latest/bin"
  fi

  unset _d _latest
}

# LLVM
if [ -d /usr/local/opt/llvm/bin ]; then
  pathmunge /usr/local/opt/llvm/bin
elif [ -d /opt/homebrew/opt/llvm/bin ]; then
  pathmunge /opt/homebrew/opt/llvm/bin
fi

# QT
if [ -d /usr/local/opt/qt/bin ]; then
  pathmunge /usr/local/opt/qt/bin
elif [ -d /opt/homebrew/opt/qt/bin ]; then
  pathmunge /opt/homebrew/opt/qt/bin
fi

# kubectl
if [ -d /usr/local/opt/kubernetes-cli/bin ]; then
  pathmunge /usr/local/opt/kubernetes-cli/bin
elif [ -d /opt/homebrew/opt/kubernetes-cli/bin ]; then
  pathmunge /opt/homebrew/opt/kubernetes-cli/bin
fi

# brew install texinfo
if [ -d /usr/local/opt/texinfo/bin ]; then
  pathmunge /usr/local/opt/texinfo/bin
elif [ -d /opt/homebrew/opt/texinfo/bin ]; then
  pathmunge /opt/homebrew/opt/texinfo/bin
fi

# Coursier binaries
if [ -d "$HOME/Library/Application Support/Coursier/bin" ]; then
  pathmunge "$HOME/Library/Application Support/Coursier/bin"
fi

# Local Variables:
# mode: sh
# End:
