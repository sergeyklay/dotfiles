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

# Setup GnuPG

# shellcheck shell=bash

# Sane defaults
GNUPGHOME="$HOME/.gnupg"

if command -v gpgconf >/dev/null 2>&1 ; then
  GPG_AGENT_SOCK="$(gpgconf --list-dirs agent-socket)"
  GNUPGHOME="$(gpgconf --list-dirs homedir)"
fi

# Update GPG_TTY
GPG_TTY="${TTY:-$(tty)}"
export GPG_TTY

# Enable gpg-agent if it is not running
if command -v gpg-agent >/dev/null 2>&1 ; then
  if [[ ! -S "$GPG_AGENT_SOCK" ]]; then
    gpg-agent --daemon --use-standard-socket &>/dev/null
  fi
fi

# Using a PGP key for SSH authentication if it's enabled.
#
# Once gpg-agent is running the list of approved keys
# should be stored in the $GNUPGHOME/sshcontrol file
# (unless you have your GPG key on a keycard).  Consider
# the following example to see the general idea:
#
#    $ rm ~/.gnupg/sshcontrol
#    $ ssh-add -l
#    The agent has no identities.
#    $ echo YOUR_KEYGRIP > ~/.gnupg/sshcontrol
#    $ ssh-add -l
#    4096 SHA256:YOUR_KEY_HERE (none) (RSA)
#
# Note: This feature requires a key with the Authentication
# capability.  To check key copability see:
#
#    $ grep '\[A]' <(gpg -K your@id.here)
#
GPG_AGENT_CONFIG="$GNUPGHOME/gpg-agent.conf"
if [ -r "$GPG_AGENT_CONFIG" ] && \
   [ -S "$GPG_AGENT_SOCK" ] && \
   command grep -q enable-ssh-support "$GPG_AGENT_CONFIG"
then
  SSH_AUTH_SOCK="$GPG_AGENT_SOCK.ssh"
  export SSH_AUTH_SOCK

  unset SSH_AGENT_PID
fi

# Local Variables:
# mode: sh
# flycheck-disabled-checkers: (sh-posix-dash sh-shellcheck)
# End:
