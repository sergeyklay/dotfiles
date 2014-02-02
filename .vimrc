""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Vim main config
" by Sergey Yakovlev (me@klay.me)
" https://github.com/sergeyklay/
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype on                   " автообнаружение типа файла
filetype plugin on            " подгружать планины соответствующие типу файла
filetype indent on            " включать отступы для этого типа файлов

set nocompatible              " Necessary for lot of cool vim things
set modelines=0               " предотвращает некоторые дыры в безопасности
set backup                    " создавать файлы с резервной копией
set bdir=~/.vim/back,/tmp     " где создавать резервные копии
set history=1000              " сохранять 1000 строк в истории командной строки
set ruler                     " постоянно показывать позицию курсора
set incsearch                 " показывать первое совпадение при наборе шаблона
set nohls                     " подсветка найденного nohls|hls
set ignorecase                " игнорируем регистр символов при поиске
set mouse=a                   " используем мышку
set ai                        " отступ копируется из предыдущей строки
set ttyfast                   " коннект с терминалом быстрый
set novb                      " пищать вместо мигания
set showmatch                 " показываем соответствующие скобки
set shortmess+=tToOI          " убираем заставку при старте
" statusbar
set stl=%t\ %{strftime(\"%H:%M\ \")}%(%l,%c\ %p%%%)\ %y%m%r[%{&fileencoding}]
set nowrap                    " не разрывать строку wrap|nowrap
set ts=4                      " размер табуляции
set shiftwidth=4              " число пробелов, используемых при автоотступе
set expandtab                 " when inserting replace tabs with spaces
set softtabstop=4             " Количество пробелов при нажатии клавиши TAB
set t_Co=256                  " включаем поддержку 256 цветов
set wildmenu                  " красивое автодополнение
set makeprg=make              " программа для сборки - make
set whichwrap=<,>,[,],h,l     " не останавливаться курсору на конце строки
set encoding=utf8             " кодировка
set termencoding=utf8         " кодировка вывода на терминал
set fencs=utf8,cp1251,koi8r,cp866 " возможные кодировки файлов
set showcmd                   " показывать вводимые команды
set showmode                  " показывать режимы
set noacd                     " current directory - where is the active file
set stal=2                    " отображать строку с вкладками
set tpm=100                   " максимальное количество открытых вкладок
set wak=yes                   " используем ALT как обычно
set ar                        " перечитываем файл, если он изменился извне
set dir=~/.vim/swapfiles,/tmp " directory to save the swap files
set undofile                  " создавать файл с откатом
set undodir=~/.vim/undo,/tmp  " directory to save the rollback files
set undolevels=1000           " количество возможных откатов
set ex                        " читаем файл конфигурации из текущей директории
set ssop+=resize              " сохраняем в сессии размер окон Vim'а
set cot=menuone,longest       " показываем меню автодополнения
set list                      " отображаем табуляции и начальные пробелы
set lcs=tab:»\ ,trail:·,eol:¶ " как отображать непечатаемые символы
set autowrite                 " автосохранение при переходе к другому файлу
set tw=80                     " 80 character per line - limit for all files
set cc=+1                     " highlight border for tw
set nohidden                  " When closing tab, remove the buffer

" save on loss of focus
au FocusLost * :wa

" more complete information when pressing <C-g>
map <C-g> g<C-g>
" save sesson to file
map <C-k> :mks! ~/.vim/session/sess.vim<CR>
" restore sesion from file
map <C-l> :so ~/.vim/session/sess.vim<CR>
" that will list file names in the current directory
map <F2> :e <C-d>

" if terminal's color count > 2
if &t_Co > 2
    colorscheme molokai
   syntax on
endif

set wcm=<Tab>
set scrolloff=3
set wildmode=list:longest
set cursorline
set backspace=indent,eol,start
set laststatus=2
set relativenumber
set smartcase
set gdefault
" correctly handle long lines
set formatoptions=qrn1

" ; the same as :
nnoremap ; :

inoremap <C-U> <C-G>u<C-U>

if has("autocmd")
  augroup vimrcEx
  au!

  autocmd FileType text setlocal textwidth=78
  autocmd bufreadpre *.c setlocal textwidth=78
  autocmd FileType php  setlocal makeprg=zca\ %<.php
  autocmd FileType php  setlocal errorformat=%f(line\ %l):\ %m

  " When editing a file is always move to the last known cursor position.
  " If the position is wrong - do not go.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
  augroup END
else

endif

if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif

" Switch to alternate file
map <C-Tab> :bnext<cr>
map <C-S-Tab> :bprevious<cr>

" Using templates for new files.
" In order for plugin was able to find a specific template,
" files must be named template.*, and should be located in
" ~/.vim/template directory
augroup template-plugin
  autocmd User plugin-template-loaded call s:template_keywords()
augroup END

function! s:template_keywords()
  " file name
  if search('<+FILE_NAME+>')
    silent %s/<+FILE_NAME+>/\=toupper(expand('%:t:r'))/g
  endif
  " cursor position
  if search('<+CURSOR+>')
    execute 'normal! "_da>'
  endif
  " current date
  silent %s/<+DATE+>/\=strftime('%Y-%m-%d')/g
endfunction

