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
" supports async, but for now I prefer syntastic
"Plugin 'neomake/neomake'
" Json syntax etc
Plugin 'elzr/vim-json'
" colorschemes
Plugin 'flazz/vim-colorschemes'
Plugin 'yosiat/oceanic-next-vim'
" Plugin 'qualiabyte/vim-colorstepper'
" status bar
Plugin 'vim-airline/vim-airline'
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
" JavaScript syntax
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
call vundle#end()
" End VUNDLE

filetype plugin indent on
syntax on

" syntastic
if !empty($VIRTUAL_ENV)
    " assumes pylint and flake8 are available in virtualenvs
    let g:syntastic_python_pylint_exe = $VIRTUAL_ENV . '/bin/python -m pylint'
    let g:syntastic_python_flake8_exe = $VIRTUAL_ENV . '/bin/python -m flake8'
    let g:syntastic_python_checkers = ['pylint', 'flake8']
endif
let g:syntastic_check_on_open = 1
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_error_symbol = '😡'
let g:syntastic_style_error_symbol = '⛏'
let g:syntastic_warning_symbol = '⛅'
let g:syntastic_style_warning_symbol = '☕'

" colorscheme corrections for syntastic
function! SyntasticColors()
    hi SyntasticErrorSign ctermbg=247
    hi SyntasticWarningSign ctermbg=69
    hi SyntasticStyleErrorSign ctermbg=7
    hi SyntasticStyleWarningSign ctermbg=94
endfunction

" GitGutter
let g:gitgutter_override_sign_column_highlight = 0
let g:gitgutter_sign_removed = '-'
function! GitGutterColors()
    hi GitGutterAdd ctermfg=34
    hi GitGutterChange ctermfg=184
    hi GitGutterChangeDelete ctermfg=184
    hi GitGutterDelete ctermfg=124
endfunction

" you complete me
let g:ycm_python_binary_path = '/usr/local/bin/python3'

" javascript/jsx/react
let g:jsx_ext_required = 0
let g:used_javascript_libs = 'react,flux,jquery,underscore'
au FileType javascript.jsx setlocal ts=4 sw=4 sts=0 noexpandtab
au FileType html setlocal ts=4 sw=4 sts=0 noexpandtab

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
function! CustomizedColors()
    call SyntasticColors()
    call GitGutterColors()
endfunction

set t_Co=256
au BufEnter,BufRead,BufNewFile,BufFilePost * colorscheme CandyPaper | call CustomizedColors()
au BufEnter,BufRead,BufNewFile,BufFilePost *.js colorscheme blazer | call CustomizedColors()
au BufEnter,BufRead,BufNewFile,BufFilePost .*vimrc colorscheme CandyPaper | call CustomizedColors()

" add filetype json for ipynbs
au BufRead,BufNewFile *.ipynb setfiletype json
au BufRead,BufNewFile .eslintrc setfiletype json
au BufRead,BufNewFile *.pl setfiletype prolog
" automatically remove trailing whitespace in python files on write
au BufWritePre *.py %s/\s\+$//e

" navigate wrapped lines more gracefully
nnoremap j gj
nnoremap k gk

" nvim requires extra python support :-/
if has('nvim')
    let g:python_host_prog = '/usr/local/bin/python3'
endif

