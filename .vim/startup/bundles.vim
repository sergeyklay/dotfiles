" Initial Vundle config
filetype on
filetype off
set nocompatible
set runtimepath+=~/.vim/bundle/vundle
call vundle#rc()
filetype plugin indent on

" Bundles
Bundle 'gmarik/vundle'
Bundle 'vim-ruby/vim-ruby'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-haml'
Bundle 'tpope/vim-rails.git'
Bundle 'tpope/vim-rvm'
Bundle 'tpope/vim-endwise'
Bundle 'scrooloose/nerdtree'
Bundle 'thinca/vim-template'
Bundle 'ecomba/vim-ruby-refactoring'

" Syntax plugins
Bundle 'hail2u/vim-css3-syntax'
Bundle 'othree/html5-syntax.vim'
Bundle 'leshill/vim-json'
Bundle 'tpope/vim-markdown'
Bundle 'jelera/vim-javascript-syntax'
Bundle 'jiangmiao/simple-javascript-indenter'
Bundle 'othree/javascript-libraries-syntax.vim'
Bundle 'groenewege/vim-less'
Bundle 'cakebaker/scss-syntax.vim'
Bundle 'itspriddle/vim-jquery'
Bundle 'evanmiller/nginx-vim-syntax'
Bundle 'Matt-Stevens/vim-systemd-syntax'

" Color schemes
Bundle 'sergeyklay/desert256-transparent.vim'

" vim:ts=8:sw=2:sts=2:tw=80:et
