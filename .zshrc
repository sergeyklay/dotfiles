# Path to my oh-my-zsh installation
[ -d "$HOME/.oh-my-zsh" ] && export ZSH="$HOME/.oh-my-zsh"

# User-specific configuration files
export XDG_CONFIG_HOME=$HOME/.config

# User-specific data files
export XDG_DATA_HOME=$HOME/.local/share

# Base directories relative to which data files should be searched
export XDG_DATA_DIRS=/usr/share

# Configuration files should be searched relative to this directory
export XDG_CONFIG_DIRS=/etc/xdg

# User-specific cached data should be written relative to this directory
export XDG_CACHE_HOME=$HOME/.cache

# User-specific runtime files should be placed relative to this directory
export XDG_RUNTIME_DIR=/run/user/$(id -u)

# See: https://stackoverflow.com/a/27965014/1661465
export XDG_STATE_HOME=$HOME/.local/state

# See: https://github.com/sergeyklay/vimfiles
export EDITOR="vim"
export VIEWER="vim -R"

# More for less
export PAGER=less

if [ -f /usr/local/bin/lesspipe.sh ]
then
  LESSPIPE="$(which lesspipe.sh)"
  LESSOPEN="| ${LESSPIPE} %s"; export LESSOPEN
elif [ -x /usr/bin/lesspipe ]
then
  eval "$(lesspipe)"
fi

# -X will leave the text in your Terminal, so it doesn't disappear
#    when you exit less
# -F will exit less if the output fits on one screen (so you don't
#    have to press "q").
#
# See: https://unix.stackexchange.com/q/38634/50400
export LESS="-X -F"
export LESSCHARSET=UTF-8

# Set name of the theme to load
ZSH_THEME="robbyrussell"

plugins=(
  git
  git-extras
  bundler
  gem
  rake
  ruby
  docker
  vagrant
  # cask
  cabal
)

[ "$(uname -o)" != "GNU/Linux" ] && plugins+=(osx)
[ "$(uname -o)" != "GNU/Linux" ] && plugins+=(brew)

[ -f "$ZSH/oh-my-zsh.sh" ] && source "$ZSH/oh-my-zsh.sh"
[ -f "$HOME/.zshenv" ] && source "$HOME/.zshenv"

# Include aliases
[ -f "$HOME/.zsh_aliases" ] && source "$HOME/.zsh_aliases"

[ "$(command -v brew 2>/dev/null || true)" != "" ] && {
  [ -d "$(brew --prefix)/share/zsh/site-functions" ] && {
    FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"
  }
}

# kubectl completion
[ "$(command -v kubectl 2>/dev/null || true)" != "" ] && {
  source <(kubectl completion zsh | sed s/kubectl/k/g)
}

[ -d /usr/local/man ] && export MANPATH="/usr/local/man:$MANPATH"
[ -d /usr/share/man ] && export MANPATH="/usr/share/man:$MANPATH"

# The next line updates PATH for the Google Cloud SDK.
[ -f "$HOME/gcp/path.zsh.inc" ] && source "$HOME/gcp/path.zsh.inc"

# The next line enables shell command completion for gcloud.
[ -f "$HOME/gcp/completion.zsh.inc" ] && source "$HOME/gcp/completion.zsh.inc"
