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
  
  typeset -g LESSHISTFILE="$HOME/.cache/lesshst"
fi

export ALTERNATE_EDITOR EDITOR VISUAL PAGER LESS LESSCHARSET LESSHISTFILE

# Configure less input preprocessor for enhanced file viewing
# Install with: brew install lesspipe (macOS)
if [[ -z "$LESSOPEN" ]] && (( $#commands[(i)lesspipe(|.sh)] )); then
  LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
  export LESSOPEN
fi

# --------------------------------------------------------------------
# Setup zle
# --------------------------------------------------------------------

# Setup Zsh Line Editor (ZLE)
# Only load ZLE when we have a proper terminal (not in Emacs tramp mode)
if [[ "$TERM" != "dumb" ]]; then
  # Load the zsh/zle module with improved error reporting
  zmodload -i zsh/zle
  
  # Use Emacs keybindings for line editing
  # This is preferred by many Emacs users for consistency
  # and matches the default readline behavior
  bindkey -e
  
  # Set a shorter key timeout (default is 0.4s)
  export KEYTIMEOUT=20
fi

# --------------------------------------------------------------------
# Setup colors
# --------------------------------------------------------------------

# Initialize color support detection
typeset -g color_prompt=no

# Check for color support using zsh-specific syntax
if [[ "${COLORTERM:-}" == (truecolor|24bit|1|gnome-terminal) ]] || \
   [[ "${USE_ANSI_COLORS:-}" == "true" ]] || \
   [[ "$TERM" == "xterm-256color" ]] || \
   { (( $+commands[tput] )) && tput setaf 1 &>/dev/null }; then
  color_prompt=yes
else
  # Detect support for colors based on terminal type
  case "$TERM" in
    *-256color|xterm|xterm-color)
      color_prompt=yes
      ;;
  esac

  # Fallback to terminfo detection if needed
  if [[ "$color_prompt" == "no" ]] && (( $+commands[tput] )); then
    tput setaf 1 &>/dev/null && color_prompt=yes
  fi
fi

# Configure color-related environment variables
if [[ "$color_prompt" == "yes" ]]; then
  # Set GCC colors for better error/warning visibility
  typeset -g GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
  
  # Set standard color environment variables
  typeset -g COLORTERM=${COLORTERM:-1}
  typeset -g CLICOLOR=${CLICOLOR:-1}
  
  # Export all color-related variables
  export GCC_COLORS COLORTERM CLICOLOR
fi

# Clean up
unset color_prompt

# Setup dircolors for colorized ls output
# Note: On macOS, install GNU coreutils with: brew install coreutils
if (( $+commands[gdircolors] )); then
  # Use custom dircolors if available, otherwise use defaults
  if [[ -f "$HOME/.dircolors" ]]; then
    eval "$(gdircolors -b "$HOME/.dircolors")"
  else
    eval "$(gdircolors -b)"
  fi
fi

# --------------------------------------------------------------------
# Setup completion support
# --------------------------------------------------------------------

# Ensure unique entries in fpath
typeset -U fpath

# Clean up non-existent directories from fpath
fpath=("${(@)fpath:#}")
for dir in $fpath; do
  [[ -d "$dir" ]] || fpath=("${(@)fpath:#$dir}")
done

# Add site-functions directories if they exist
for site_dir in /usr/local/share/zsh/site-functions /opt/homebrew/share/zsh/site-functions; do
  [[ -d "$site_dir" ]] && fpath=("$site_dir" $fpath)
done

# Load completion modules
zmodload -i zsh/compctl zsh/complete zsh/complist zsh/computil

# Load completion system
autoload -Uz compinit

# Set cache locations
typeset -g ZSH_CACHE_DIR="$HOME/.cache/zsh"
typeset -g ZSH_COMPDUMP="${ZSH_CACHE_DIR}/zcompdump"

# Create cache directories if they don't exist
[[ -d "$ZSH_CACHE_DIR" ]] || mkdir -p "$ZSH_CACHE_DIR"

# Configure cache path using zstyle (modern approach)
zstyle ':completion::complete:*' cache-path "${ZSH_CACHE_DIR}/zcompcache"

# Only regenerate compdump once per day
if [[ -n "$ZSH_COMPDUMP"(#qN.mh+24) ]]; then
  compinit -d "$ZSH_COMPDUMP"
else
  compinit -C -d "$ZSH_COMPDUMP"
fi

# Completion options
setopt correct           # Correct commands
setopt nocorrectall      # Don't correct arguments
setopt auto_menu         # Show completion menu on successive tab press
setopt list_ambiguous    # Complete up to point of ambiguity
setopt auto_list         # List choices on ambiguous completion
setopt list_types        # Show file type indicators in completions
setopt hash_list_all     # Hash command path before completion
setopt complete_in_word  # Complete from both ends of a word
setopt extended_glob     # Extended globbing capabilities

# Disable globbing for dotfiles by default
setopt no_glob_dots

# Enable completion for aliases
setopt complete_aliases

# Set maximum number of entries before asking to show all
typeset -g LISTMAX=50

# Completion styling
zstyle ':completion:*' menu select=10                 # Show menu for 10+ items
zstyle ':completion:*' use-cache on                   # Use completion caching
zstyle ':completion:*:functions' ignored-patterns '_*' # Ignore completion functions
zstyle ':completion:*:cd:*' ignore-parents parent pwd # Don't complete . when cd ../
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case insensitive completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # Use LS_COLORS for completion
zstyle ':completion:*' group-name ''                  # Group completions by category
zstyle ':completion:*:descriptions' format '%F{yellow}%B-- %d --%b%f' # Format group descriptions
