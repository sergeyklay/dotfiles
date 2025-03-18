# Zsh startup file.
#
# This file is sourced on interactive invocations of zsh.
#   .zshenv -> .zprofile -> [.zshrc] -> .zlogin
#
# Used for setting user's interactive shell configuration and
# executing commands, will be read when starting as an interactive
# shell.

# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

# Ensure .zshenv has been sourced
if (( ! ${+ZSH_ENV_SOURCED} )) || [[ "$ZSH_ENV_SOURCED" != "1" ]]; then
  # Source .zshenv if it exists and hasn't been properly sourced
  if [[ -f "${ZDOTDIR:-$HOME}/.zshenv" ]]; then
    source "${ZDOTDIR:-$HOME}/.zshenv"
  fi
fi

# --------------------------------------------------------------------
# Setup editor
# --------------------------------------------------------------------

# Configure editor settings
# Use empty ALTERNATE_EDITOR to start Emacs daemon if not running
typeset -g ALTERNATE_EDITOR=''

# Set up emacsclient as the default editor
typeset -g EDITOR='emacsclient -c -nw -a ""'
typeset -g VISUAL=$EDITOR

# Create convenient alias for emacsclient
alias ec=$EDITOR

# Configure pager based on terminal capabilities
if [[ $TERM == "dumb" ]]; then
  # Use simple cat for dumb terminals (like Emacs tramp)
  typeset -g PAGER=cat
else
  # Use less for normal terminals
  typeset -g PAGER=less
  
  # Configure less options:
  # -X: Don't clear screen when exiting
  # -F: Quit if content fits on one screen
  # -R: Display ANSI color sequences properly
  typeset -g LESS="-X -F -R"
  typeset -g LESSCHARSET=UTF-8
  
  # Store less history in XDG-compliant location
  typeset -g LESSHISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/lesshst"
fi

export ALTERNATE_EDITOR EDITOR VISUAL PAGER LESS LESSCHARSET LESSHISTFILE

# Configure less input preprocessor for enhanced file viewing
# Install with: brew install lesspipe (macOS)
if [[ -z "$LESSOPEN" ]] && (( $#commands[(i)lesspipe(|.sh)] )); then
  LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
  export LESSOPEN
fi
