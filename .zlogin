#!/usr/bin/env zsh
#
# Executes commands at login post-zshrc.

# rbenv
[ ! -z "$(command -v rbenv 2>/dev/null || true)" ] &&
  eval "$($dir/bin/rbenv init -)"

# phpenv
[ ! -z "$(command -v phpenv 2>/dev/null || true)" ] && eval "$(phpenv init -)"

# virtualenv
[ -z "$VIRTUAL_ENV" ] && {
  # Use local Python by default
  [ -f "$HOME/.venv/local/bin/activate" ] && {
    source "$HOME/.venv/local/bin/activate"
  }
}

# https://gnunn1.github.io/tilix-web/manual/vteconfig
[[ $- != *i* ]] && { # only interactive mode
  if [ $TILIX_ID ] || [ $VTE_VERSION ]
  then
    if [ -f /etc/profile.d/vte-2.91.sh ]
    then
      source /etc/profile.d/vte-2.91.sh
    elif [ -f /etc/profile.d/vte.sh ]
    then
      source /etc/profile.d/vte.sh
    fi
  fi
}

# execute code that does not affect the current session in the background.
{
  # compile the completion dump to increase startup speed.
  if [[ -s "$ZSH_COMPDUMP" && (! -s "${ZSH_COMPDUMP}.zwc" || "$ZSH_COMPDUMP" -nt "${ZSH_COMPDUMP}.zwc") ]]
  then
    zcompile "$ZSH_COMPDUMP"
  fi
} &!

# Local Variables:
# mode: sh
# End:
