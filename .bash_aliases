# enable color support of ls and also add handy aliases
if [ $colors_support = true ]
then
  alias ls='ls --color=auto'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# alsi
alias alsi='alsi -a -u'

# pacman
alias pclean='sudo pacman -Qdt'

# yaourt
alias ysd='yaourt -Syua --devel'

# alias for Karma
alias google-chrome='chromium'

# be more cultured at work in the console`
alias please=sudo

# clear screen
alias cls=clear

# vim:ft=sh:ts=8:sw=2:sts=2:tw=80:et
