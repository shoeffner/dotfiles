" VUNDLE
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" Vundle is the plugin manager
Plugin 'VundleVim/Vundle.vim'
" YouCompleteMe!
Plugin 'Valloric/YouCompleteMe'
" JavaScript completion for YCM
Plugin 'ternjs/tern_for_vim'
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
" R environment
Plugin 'jalvesaq/Nvim-R'
call vundle#end()
" End VUNDLE

filetype plugin indent on
syntax on

" syntastic
let g:syntastic_python_checkers = ['pylint', 'flake8']
let g:syntastic_python_pylint_exe = '/usr/local/bin/python3 -m pylint'
let g:syntastic_python_flake8_exe = '/usr/local/bin/python3 -m flake8'
if !empty($VIRTUAL_ENV)
    " assumes pylint and flake8 are available in virtualenvs
    let g:syntastic_python_pylint_exe = $VIRTUAL_ENV . '/bin/python -m pylint'
    let g:syntastic_python_flake8_exe = $VIRTUAL_ENV . '/bin/python -m flake8'
endif

let g:syntastic_check_on_open = 1
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_error_symbol = '!'
let g:syntastic_warning_symbol = '¡'
let g:syntastic_style_warning_symbol = '†'
let g:syntastic_style_error_symbol = '‡'

" colorscheme corrections for syntastic
function! SyntasticColors()
    hi SyntasticErrorSign ctermbg=160
    hi SyntasticWarningSign ctermbg=220
    hi SyntasticStyleErrorSign ctermbg=126
    hi SyntasticStyleWarningSign ctermbg=111
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

" javascript/jsx/react
let g:jsx_ext_required = 0
let g:used_javascript_libs = 'react,flux,jquery,underscore'
au BufEnter,BufRead,BufNewFile,BufFilePost *.js,*.jsx,package.json,*.xhtml,*.html,*.htm,*.shtml setlocal ts=2 sw=2

" activate airline
set laststatus=2

" tabs = 4 spaces
set tabstop=4
set shiftwidth=4
"set softtabstop=4
set expandtab
" relative and absolute line numbers
set relativenumber
set number
set ruler

" highlight searchresults while typing
set incsearch
" reloads after :! commands
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

" set up R for nvim
if has ('nvim')
    function OpenRHelp()
        if bufwinnr('~/.vim/bundle/Nvim-R/doc/Nvim-R.txt') < 0
            badd ~/.vim/bundle/Nvim-R/doc/Nvim-R.txt
            buffer ~/.vim/bundle/Nvim-R/doc/Nvim-R.txt
            execute "/Menu entry"
            bprevious
        endif
    endfunction
    au BufEnter *.r let maplocalleader = " " | call OpenRHelp() | nnoremap <localleader>h :bnext<CR> | set syntax=r
endif

" automatically remove trailing whitespace in python files on write
au BufWritePre * %s/\s\+$//e

" navigate wrapped lines more gracefully
nnoremap j gj
nnoremap k gk

" nvim requires extra python support :-/
if has('nvim')
    let g:python_host_prog = '/usr/local/bin/python3'
endif

