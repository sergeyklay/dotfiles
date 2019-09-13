# Path to your oh-my-zsh installation.
export ZSH="/Users/klay/.oh-my-zsh"

export EDITOR='vim'

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
  export MANPATH="/usr/local/man:/usr/share/man:$MANPATH"
fi

