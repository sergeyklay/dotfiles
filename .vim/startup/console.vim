" if we're in a linux console
if (&term == 'screen.linux') || (&term =~ '^linux')
  " use 8 bit colour
  set t_Co=8
  " set color scheme
  colors desert
endif
