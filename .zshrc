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


if [ -f "$ZSH/oh-my-zsh.sh" ]
then
  source "$ZSH/oh-my-zsh.sh"
fi

source $HOME/.zshenv

# Include aliases
if [ -f $HOME/.zsh_aliases ]; then
  source $HOME/.zsh_aliases
fi

if [ "$(command -v brew 2>/dev/null || true)" != "" ]
then
  if [ -d "$(brew --prefix)/share/zsh/site-functions" ]
  then
    FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"
  fi
fi

if [ "$(command -v kubectl 2>/dev/null || true)" != "" ]
then
  source <(kubectl completion zsh | sed s/kubectl/k/g)
fi

if [ -d /usr/local/man ]
then
  export MANPATH="/usr/local/man:$MANPATH"
fi

if [ -d /usr/share/man ]
then
  export MANPATH="/usr/share/man:$MANPATH"
fi

