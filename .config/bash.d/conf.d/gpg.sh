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
#
# This script assumes you have installed GnuPG >= 2.0 and gpgconf,
# gpg-agent and gpg-connect-agent are present in your PATH.

# shellcheck shell=bash

GNUPGHOME="$HOME/.gnupg"
export GNUPGHOME

# Enable gpg-agent if it is not running
if [ ! -S "$(gpgconf --list-dirs agent-socket)" ]; then
  gpg-agent --homedir "$GNUPGHOME" --daemon --use-standard-socket &>/dev/null
fi

# Update GPG_TTY.  See 'man 1 gpg-agen'.
GPG_TTY="${TTY:-$(tty)}"
export GPG_TTY

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
if [ -n "$(gpgconf --list-options gpg-agent | \
   awk -F: '/^enable-ssh-support:/{ print $10 }')" ]; then
  gpg-connect-agent updatestartuptty /bye > /dev/null
  unset SSH_AGENT_PID

  SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
  export SSH_AUTH_SOCK
fi

# Local Variables:
# mode: sh
# End:
