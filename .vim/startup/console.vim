" if we're in a linux console
if (&term == 'screen.linux') || (&term =~ '^linux')
  set t_Co=8
  syntax on
  colors desert
" if we're  in xterm, urxvt or screen with 256 colors
elseif (&term =~ 'rxvt') || (&term =~ '^xterm') || (&term =~ '^screen-256')
  set t_Co=256
  syntax on
  set mouse=a
  set ttymouse=xterm
  set termencoding=utf-8
  colors desert256-transparent
else
  colors desert
endif

" vim:ts=8:sw=2:sts=2:tw=80:et
