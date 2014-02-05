" if we're in a linux console
if (&term == 'screen.linux') || (&term =~ '^linux')
  set t_Co=8
  colors desert
" if we're  in xterm, urxvt or screen with 256 colors
elseif (&term =~ 'rxvt') || (&term =~ '^xterm') || (&term =~ '^screen-256')
  set t_Co=256
  set mouse=a
  set ttymouse=xterm
  set termencoding=utf-8
  colors desert256-transparent
else
  colors desert
endif
