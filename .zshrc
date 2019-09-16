# Path to your oh-my-zsh installation.
export ZSH="/Users/klay/.oh-my-zsh"

# See: https://github.com/sergeyklay/vimfiles
export EDITOR="vim"
export VIEWER="vim -R"

# More for less
export PAGER=less

# brew install lesspipe
[ -f /usr/local/bin/lesspipe.sh ] && {
    LESSPIPE="$(which lesspipe.sh)"
    LESSOPEN="| ${LESSPIPE} %s"; export LESSOPEN
}

# -X will leave the text in your Terminal, so it doesn't disappear
#    when you exit less
# -F will exit less if the output fits on one screen (so you don't
#    have to press "q").
#
# See: https://unix.stackexchange.com/q/38634/50400
export LESS='-X -F'
export LESSCHARSET=UTF-8

# Set name of the theme to load
ZSH_THEME="robbyrussell"

plugins=(
  git
  git-extras
  osx
  bundler
  gem
  rake
  ruby
  docker
  vagrant
  # cask
  cabal
  brew
)

[ -f "$ZSH/oh-my-zsh.sh" ] && source "$ZSH/oh-my-zsh.sh"
[ -f "$HOME/.zshenv" ] && source "$HOME/.zshenv"

# Include aliases
[ -f "$HOME/.zsh_aliases" ] && source "$HOME/.zsh_aliases"

[ ! -z "$(command -v brew 2>/dev/null || true)" ] && {
  [ -d "$(brew --prefix)/share/zsh/site-functions" ] && {
    FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"
  }
}

# kubectl completion
[ -z "$(command -v kubectl 2>/dev/null || true)" ] && {
  source <(kubectl completion zsh | sed s/kubectl/k/g)
}

[ -d /usr/local/man ] && export MANPATH="/usr/local/man:$MANPATH"
[ -d /usr/share/man ] && export MANPATH="/usr/share/man:$MANPATH"

# The next line updates PATH for the Google Cloud SDK.
[ -f "$HOME/gcp/path.zsh.inc" ] && source "$HOME/gcp/path.zsh.inc"

# The next line enables shell command completion for gcloud.
[ -f "$HOME/gcp/completion.zsh.inc" ] && source "$HOME/gcp/completion.zsh.inc"
