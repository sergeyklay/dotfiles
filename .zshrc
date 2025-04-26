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
# Setup history
# --------------------------------------------------------------------

# The number of events loaded from $HISTFILE at startup.
HISTSIZE=1000

# The last $SAVEHIST events are the ones that are saved to $HISTFILE
SAVEHIST=5000

HISTFILE=$HOME/.zsh_history

# Write timestamps to history.
#
# For more see: man zshoptions(1)
setopt extended_history

# New history lines are added to the $HISTFILE as soon as they are
# entered.
#
# For more see: man zshoptions(1)
setopt inc_append_history

# Write and import history on every command.
#
# For more see: man zshoptions(1)
setopt share_history

# Don't add commands starting with space to history.
#
# For more see: man zshoptions(1)
setopt hist_ignore_space

# The older command will be removed from the list (if any).
#
# For more see: man zshoptions(1)
setopt hist_ignore_all_dups

# Allow events recalled from history to clobber with >
#
# For more see: man zshoptions(1)
setopt hist_allow_clobber

# Remove superfluous blanks from each command line being added to
# the history list.
#
# For more see: man zshoptions(1)
setopt hist_reduce_blanks

# Do store `history' and `fc' commands in the history.
#
# For more see: man zshoptions(1)
setopt no_hist_no_store

# Do not store function definitions in the history.
#
# For more see: man zshoptions(1)
setopt hist_no_functions

# Don't beep when reaching the limits of history.
#
# For more see: man zshoptions(1)
setopt no_hist_beep

## Key Bindings

# [Ctrl-r] - Search backward incrementally for a specified
# string.  The string may begin with ^ to anchor the search to the
# beginning of the line.
bindkey '^r' history-incremental-search-backward

# [PageUp] - Up a line of history
if [[ "${terminfo[kpp]}" != "" ]]; then
  bindkey "${terminfo[kpp]}" up-line-or-history
fi

# [PageDown] - Down a line of history
if [[ "${terminfo[knp]}" != "" ]]; then
  bindkey "${terminfo[knp]}" down-line-or-history
fi

# Start typing + [Up Arrow] - fuzzy find history forward.
#
# `kcuu1' capname is the Up Arrow on the keypad.  `^[[A' is the Up
# Arrow in the common part of the keyboard.  Note, some keyboards
# does not have keypad, for example notebooks.  Thus, we bind here
# `^[[A' as well as `kcuu1'.
#
# For more see: man terminfo(5) .

autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search

if [[ "${terminfo[kcuu1]}" != "" ]]; then
  bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
fi

bindkey "^[[A" up-line-or-beginning-search

# Start typing + [Down Arrow] - fuzzy find history backward.
#
# `kcud1' capname is the Down Arrow on the keypad.  `^[[B' is the
# Down Arrow in the common part of the keyboard.  Note, some
# keyboards does not have keypad, for example notebooks.  Thus, we
# bind here `^[[B' as well as `kcud1'.
#
# For more see: man terminfo(5) .

autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search

if [[ "${terminfo[kcud1]}" != "" ]]; then
  bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
fi

bindkey "^[[B" down-line-or-beginning-search

## Directory History

# Keep track of visited directories.
#
#   $ dirs -v # See the directores stack
#   $ cd -N   # Go back to a visited folder N
#
# For more see: man zshoptions(1)
setopt auto_pushd

# Don't push multiple copies of the same directory onto the
# directory stack.
# For more see: man zshoptions(1)
setopt pushd_ignore_dups

# Have pushd with no arguments act like `pushd $HOME'.
# For more see: man zshoptions(1)
setopt pushd_to_home

# Do not print the directory stack after pushd or popd.
# For more see: man zshoptions(1)
setopt pushd_silent

# This reverts the +/- operators.
# For more see: man zshoptions(1)
setopt pushd_minus

# Set the directory stack size limit to 20.
# DIRSTACKSIZE keeps the directory stack from getting too large,
# much like HISTSIZE
DIRSTACKSIZE=20

# Store directory stack
typeset -g DIRSTACKFILE="$HOME/.cache/zsh/dirs"

# Create parent directory if it doesn't exist
[[ -d "${DIRSTACKFILE:h}" ]] || mkdir -p "${DIRSTACKFILE:h}"

# This will change directory when zsh starts session
# to the last visited directory.
if [[ -f "$DIRSTACKFILE" ]] && (( ${#dirstack} == 0 ))
then
  dirstack=("${(@f)"$(< "$DIRSTACKFILE")"}")
  [[ -d "${dirstack[1]}" ]] && cd -- "${dirstack[1]}"
fi

pushd-hook() {
  print -l -- "$PWD" "${(u)dirstack[@]}" > "$DIRSTACKFILE"
}

add-zsh-hook -Uz chpwd pushd-hook

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
# Setup aliases
# --------------------------------------------------------------------

# Helper function to check command availability
function _have() {
  command -v "$1" >/dev/null 2>&1
}

# Command correction prevention
alias cp='nocorrect cp'
alias mv='nocorrect mv'
alias mkdir='nocorrect noglob mkdir'

# Grep coloring
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'

# Diff coloring (prefer colordiff if available)
if _have colordiff; then
  alias diff='colordiff -Nuar'
else
  alias diff='diff -Nuar'
fi

# GNU ls with better coloring options
if _have gls; then
  # GNU's ls uses --color to enable colorized output
  # LC_ALL="C.UTF-8" ensures consistent sorting
  alias ls='gls --color=auto --group-directories-first'
  alias ll='ls -alF'
  alias la='ls -A'
  alias l='ls -CF'
else
  # BSD's ls uses -G to enable colorized output
  alias ls='ls -G'
  alias ll='ls -alF'
  alias la='ls -A'
  alias l='ls -CF'
fi

# Prefer GNU core utilities when available
_have gmake && alias make='gmake'
_have gawk && alias awk='gawk'
_have gtar && alias tar='gtar'
_have gsed && alias sed='gsed'
_have gtime && alias time='gtime'

# Store wget HSTS database in cache directory
_have wget && alias wget="wget --hsts-file=$HOME/.cache/wget-hsts"


# Container tools
_have nerdctl && alias nps="nerdctl ps --format '{{.ID}}    {{.Names}}    {{.Status}}'"
_have docker && alias dps="docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}'"
_have kubectl && alias k='kubectl'

# Programming environments
_have clojure && alias rebel='clojure -A:rebel'

# Clean up helper function
unfunction _have

# --------------------------------------------------------------------
# Setup Ruby Env Manager
# --------------------------------------------------------------------

# Initialize rbenv if not already loaded and command exists
if [[ -z "${RBENV_SHELL}" ]] && { (( $+commands[rbenv] )) || [[ -x "$HOME/.rbenv/bin/rbenv" ]]; }; then
  # Set PATH for local installation if needed
  if [[ ! -v commands[rbenv] && -x "$HOME/.rbenv/bin/rbenv" ]]; then
    path=("$HOME/.rbenv/bin" $path)
  fi

  # Add rbenv completions to fpath if directory exists
  [[ -d "${RBENV_ROOT:-$HOME/.rbenv}/completions" ]] &&
    fpath=("${RBENV_ROOT:-$HOME/.rbenv}/completions" $fpath)

  # Initialize rbenv without rehashing (faster startup)
  eval "$(rbenv init - --no-rehash zsh)"
fi

# --------------------------------------------------------------------
# Setup Node.js environment
# --------------------------------------------------------------------

# Initialize nvm (Node Version Manager) if available
function _init_nvm() {
  local -a nvm_dirs
  local nvm_dir

  # Search for nvm in standard locations
  nvm_dirs=(
    "$HOME/.config/nvm"
    "$HOME/.nvm"
  )

  # Find first valid nvm installation
  for nvm_dir in $nvm_dirs; do
    if [[ -d "$nvm_dir" && -r "$nvm_dir/nvm.sh" ]]; then
      # Set NVM_DIR and unset NPM_CONFIG_PREFIX as they conflict
      typeset -g NVM_DIR="$nvm_dir"
      unset NPM_CONFIG_PREFIX

      # Source nvm script
      [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"

      return 0
    fi
  done

  return 1
}

# Initialize Node.js environment
if [[ -z "${NVM_DIR}" ]]; then
  # Try to initialize nvm
  _init_nvm || {
    # If nvm not found, set up npm prefix to avoid permission issues
    typeset -g NPM_CONFIG_PREFIX="$HOME/.local/"
  }
fi

# Clean up
unfunction _init_nvm 2>/dev/null

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
# Setup direnv
# --------------------------------------------------------------------

if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
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

# --------------------------------------------------------------------
# Setup keybindings
# --------------------------------------------------------------------

# Keybinding configuration
# Reference: terminfo(5), zshzle(1), zshmodules(1)
# Useful tools: showkey -a, bindkey -L, infocmp -L

# Load required modules
zmodload zsh/terminfo

# Initialize edit-command-line widget
autoload -Uz edit-command-line
zle -N edit-command-line

# Initialize copy-prev-shell-word widget
autoload -Uz copy-prev-shell-word

# Use emacs keybindings as base
bindkey -e

# Common keybindings
bindkey '\C-x\C-e' edit-command-line      # Edit command in $EDITOR
bindkey '^[m'      copy-prev-shell-word   # Copy previous word (Alt-m)

# Navigation keys
bindkey '^[[1;5C'  forward-word           # Ctrl-Right
bindkey '^[[1;5D'  backward-word          # Ctrl-Left
bindkey '^?'       backward-delete-char   # Backspace

# Terminal-specific key bindings using terminfo when available
# Home key
if [[ -n "${terminfo[khome]}" ]]; then
  bindkey "${terminfo[khome]}" beginning-of-line
else
  # Fallback bindings for common terminal types
  bindkey '^[[H'   beginning-of-line      # xterm
  bindkey '^[OH'   beginning-of-line      # xterm application mode
  bindkey '^[[1~'  beginning-of-line      # linux console
fi

# End key
if [[ -n "${terminfo[kend]}" ]]; then
  bindkey "${terminfo[kend]}" end-of-line
else
  # Fallback bindings for common terminal types
  bindkey '^[[F'   end-of-line            # xterm
  bindkey '^[OF'   end-of-line            # xterm application mode
  bindkey '^[[4~'  end-of-line            # linux console
fi

# Delete key
if [[ -n "${terminfo[kdch1]}" ]]; then
  bindkey "${terminfo[kdch1]}" delete-char
else
  bindkey '^[[3~'  delete-char            # Common fallback
fi

# Additional useful bindings
bindkey '^U'       backward-kill-line     # Ctrl-U: kill line from cursor to beginning
bindkey '^K'       kill-line              # Ctrl-K: kill line from cursor to end

# --------------------------------------------------------------------
# Setup prompt
# --------------------------------------------------------------------

# Add prompt directory directly to fpath
fpath=($HOME/.config/zsh/prompts $fpath)

# Initialize prompt support
autoload -Uz colors; colors
autoload -Uz promptinit; promptinit

# Parameter expansion, command substitution and arithmetic expansion
# are performed in prompts.
#
# For more see: man zshoptions(1)
setopt prompt_subst

# $TERM="dump" is used in Emacs.
if [[ $TERM != "dumb" ]]; then
  prompt ptfancy
else
  setopt no_xtrace

  PS1='%# '
  PS2='%_> '
  PS3='?# '

  PROMPT='%# '
fi
