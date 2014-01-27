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
set stl=%t\ %{strftime(\"%H:%M\ \")}%(%l,%c\ %p%%%)\ %y%m%r[%{&fileencoding}] " строка состояния
set nowrap                    " не разрывать строку wrap|nowrap
set ts=4                      " размер табуляции
set shiftwidth=4              " число пробелов, используемых при автоотступе
set expandtab                 " при вставке заменяем табуляции пробелами (use :retab dude)
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
set noacd                     " текущий каталог тот где находится активный файл acd|noacd
set stal=2                    " отображать строку с вкладками
set tpm=100                   " максимальное количество открытых вкладок
set wak=yes                   " используем ALT как обычно
set ar                        " перечитываем файл, если он изменился извне
set dir=~/.vim/swapfiles      " каталог для сохранения своп-файлов
set undofile                  " создавать файл с откатом
set undodir=~/.vim/undo       " каталог для файлов отката
set undolevels=1000           " количество возможных откатов
set ex                        " читаем файл конфигурации из текущей директории
set ssop+=resize              " сохраняем в сессии размер окон Vim'а
set cot=menuone,longest       " показываем меню автодополнения
set list                      " отображаем табуляции и начальные пробелы
"set lcs=tab:→⋅,trail:⋅,eol:↓ " как отображать непечатаемые символы
set lcs=tab:»\ ,trail:·,eol:¶ " как отображать непечатаемые символы
set autowrite                 " автосохранение при переходе к другому файлу
set tw=120                    " ширина 120 знаков для всех файлов
set cc=+1                     " подсвечивать границу для tw
set nohidden                  " When closing tab, remove the buffer

highlight ColorColumn ctermbg=lightgrey guibg=lightgrey " цвет для cс

au FocusLost * :wa                 " сохранить при потере фокуса
au FileType text setl tw=80 cc=+1  " ширина 80 знаков для текстовых файлов

map Q gq                            " используем Q для задания форматирования
map <C-g> g<C-g>                    " более полная информация при нажатии <C-g>
map <C-k> :mks! ~/.vim/sess.vim<CR> " сохранить сессию в файл
map <C-l> :so ~/.vim/sess.vim<CR>   " восстановить сессию из файла

" если количество цветов терминала > 2
if &t_Co > 2
   " цветовая схема vibrantink|molokai|baycomb|desert|desert256|darkspectrum
    colorscheme molokai
   " включаем подсветку синтаксиса
   syntax on
endif

" если запущен GUI интерфейс:
if has ("gui_running")
   " распахиваем окно на весь экран
   set lines=99999 columns=99999
   " убираем меню и тулбар
   set guioptions-=m
   set guioptions-=T
   set guioptions-=T
   " убираем скроллбары
   set guioptions-=r
   set guioptions-=l
   " используем консольные диалоги вместо графических
   set guioptions+=c
   " антиалиасинг для шривтоф
   set antialias
   " прячем мышь
   set mousehide
   " не выводятся ненужные escape последовательности в :shell
   set noguipty
   " цветовая схема vibrantink|kmcs|baycomb|desert|darkspectrum
   colorscheme desert
   " включаем подсветку синтаксиса
   syntax on
endif



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set wcm=<Tab>                 " ?
set scrolloff=3
set wildmode=list:longest
set cursorline
set backspace=indent,eol,start
set laststatus=2
set relativenumber

set smartcase
set gdefault
" Следующая часть заставляет Vim правильно обрабатывать длинные строки:
set formatoptions=qrn1


" nnoremap / /\v
" vnoremap / /\v
nnoremap <leader><space> :noh<cr>
" nnoremap &lt;tab> %
" vnoremap &lt;tab> %

"Invisible character colors
"highlight NonText guifg=#4a4a59
"highlight SpecialKey guifg=#4a4a59

" Скопировать текущую строку.
" Вставить ниже (и затем переместиться на вставленную версию).
" Выбрать скопированную строку.
" Заменить все символы на =.
nnoremap <leader>1 yypVr=

" избавимся от этого проклятого хелпа, в который попадаешь пытаясь нажать на escape:
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" Это отключит клавиши стрелочек в нормальном режиме,
" чтобы вы приучились пользоваться hjkl.
" nnoremap <up> <nop>
" nnoremap <down> <nop>
" nnoremap <left> <nop>
" nnoremap <right> <nop>
" inoremap <up> <nop>
" inoremap <down> <nop>
" inoremap <left> <nop>
" inoremap <right> <nop>
" nnoremap j gj
" nnoremap k gk

" чтобы ; делало то же, что и :
nnoremap ; :

" HTML, /ft привязано к функции "fold tag":
nnoremap <leader>ft Vatzf

inoremap <C-U> <C-G>u<C-U>

if has("autocmd")
  augroup vimrcEx
  au!

  autocmd FileType text setlocal textwidth=78
  autocmd bufreadpre *.c setlocal textwidth=78
  autocmd FileType php  setlocal makeprg=zca\ %<.php
  autocmd FileType php  setlocal errorformat=%f(line\ %l):\ %m

" При редактировании файла всегда переходить на последнюю известную
" позицию курсора. Если позиция ошибочная - не переходим.
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

" заменяет слово под курсором в html тег
nmap <F7> byei<<ESC>ea></<C-R>0><ESC>

" Switch to alternate file
map <C-Tab> :bnext<cr>
map <C-S-Tab> :bprevious<cr>

" http://www.allaboutvim.ru/2012/09/vim-template.html

augroup template-plugin
    autocmd User plugin-template-loaded call s:template_keywords()
augroup END

function! s:template_keywords()
    if search('<+FILE_NAME+>')
        silent %s/<+FILE_NAME+>/\=toupper(expand('%:t:r'))/g
    endif
    if search('<+CURSOR+>')
        execute 'normal! "_da>'
    endif
    silent %s/<+DATE+>/\=strftime('%Y-%m-%d')/g
endfunction

