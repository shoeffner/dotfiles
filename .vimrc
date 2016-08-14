" VUNDLE
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" Vundle is the plugin manager
Plugin 'VundleVim/Vundle.vim'
" YouCompleteMe!
Plugin 'Valloric/YouCompleteMe'
" Syntax checking
Plugin 'scrooloose/syntastic'
" Json syntax etc
Plugin 'elzr/vim-json'
" colorschemes
Plugin 'flazz/vim-colorschemes'
Plugin 'notpratheek/vim-luna'
" status bar
Plugin 'vim-airline/vim-airline'
" markdown
" Plugin 'plasticboy/vim-markdown'
" git client (needed for airline)
Plugin 'tpope/vim-fugitive'
" csv plugin
Plugin 'chrisbra/csv.vim'
" start screen
Plugin 'mhinz/vim-startify'
" ctrlp
Plugin 'ctrlpvim/ctrlp.vim'
" Git diffs
Plugin 'airblade/vim-gitgutter'
call vundle#end()
" End VUNDLE


filetype plugin indent on
syntax on

" options for syntastic
let g:syntastic_python_python_exec = '/usr/local/bin/python3'
let g:ycm_python_binary_path = '/usr/local/bin/python3'

" overwritten by airline
" set statusline=[%n]\ %F\ %(\ %M%R%H)%)\ \@(%l\,%c%V)\ %P
" needed for airline
set laststatus=2

" tabs = 4 spaces
set tabstop=4
set shiftwidth=4
set expandtab

" relative and absolute line numbers
set relativenumber
set number
set ruler

" some cool things, I guess :D
set incsearch
set autoread

" colorschemes by filetypes
set t_Co=256
au BufEnter * colorscheme desertedocean
au BufEnter *.vimrc colorscheme inkpot

" add filetype json for ipynbs
au BufRead,BufNewFile *.ipynb setfiletype json
au BufRead,BufNewFile *.pl setfiletype prolog

" automatically remove trailing whitespace in python files on write
autocmd BufWritePre *.py %s/\s\+$//e

" navigate wrapped lines more gracefully
nnoremap j gj
nnoremap k gk
