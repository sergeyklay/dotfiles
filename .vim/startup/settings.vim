" General
syntax on
set modelines=0
set clipboard=unnamedplus
set isfname-==
set shortmess=aTOI
set showcmd
set ttyfast
set sidescroll=10
set splitbelow
set switchbuf=usetab
set novb
set encoding=utf-8

" Search
set incsearch nohlsearch
set smartcase
set gdefault
set ignorecase
set showmatch

" Editing
set complete=.,t,i,b,w,k
set cot=menu,menuone,longest,preview

" View formatting
set number
set ruler
set laststatus=2

" Appearance
set statusline=
set statusline+=%<%f\ %h%m%r
set statusline+=%{fugitive#statusline()}
set statusline+=%=
set statusline+=[%{&ft}]
set statusline+=[%{&fenc}/%{&ff}]
set statusline+=%-14.([%l/%L],%c%V%)

" Indentation
set backspace=indent,eol,start
set autoindent
set expandtab smarttab
set tabstop=8 softtabstop=2
set shiftwidth=2 shiftround

" Working files
set backup
set bdir=~/.vim/back,/tmp
set autoread
set dir=~/.vim/swapfiles,/tmp
set undofile
set undodir=~/.vim/undo,/tmp
set undolevels=1000
set autowrite

" Spelling
set spelllang=en_us
set spellsuggest=fast,20
