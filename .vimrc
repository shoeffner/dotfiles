" VUNDLE
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'

Plugin 'scrooloose/syntastic'

Plugin 'elzr/vim-json'
Plugin 'chrisbra/csv.vim'

Plugin 'flazz/vim-colorschemes'
Plugin 'yosiat/oceanic-next-vim'

Plugin 'vim-airline/vim-airline'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'

Plugin 'mhinz/vim-startify'

call vundle#end()


" DEFAULT SETTINGS
filetype plugin indent on
syntax on
set tabstop=4
set shiftwidth=4
set expandtab
set relativenumber
set number
set ruler
set incsearch
set autoread
set t_Co=256


" KEYMAP
nnoremap j gj
nnoremap k gk


" PLUGIN: Syntastic
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_python_flake8_exe = '/usr/local/bin/python3 -m flake8'

let g:syntastic_error_symbol = '!'
let g:syntastic_warning_symbol = '¡'
let g:syntastic_style_warning_symbol = '†'
let g:syntastic_style_error_symbol = '‡'

function! SyntasticColors()
    hi SyntasticErrorSign ctermbg=160
    hi SyntasticWarningSign ctermbg=220
    hi SyntasticStyleErrorSign ctermbg=126
    hi SyntasticStyleWarningSign ctermbg=111
endfunction


" PLUGIN: GitGutter
let g:gitgutter_override_sign_column_highlight = 0
let g:gitgutter_sign_removed = '-'
function! GitGutterColors()
    hi GitGutterAdd ctermfg=34
    hi GitGutterChange ctermfg=184
    hi GitGutterChangeDelete ctermfg=184
    hi GitGutterDelete ctermfg=124
endfunction


" PLUGIN: Airline
set laststatus=2


" FUNCTION: Set custom colors for plugins
function! CustomizedColors()
    call SyntasticColors()
    call GitGutterColors()
endfunction


" AUTOCOMMANDS: filetypes by extension
au BufRead,BufNewFile *.ipynb setfiletype json
au BufRead,BufNewFile .eslintrc setfiletype json
au BufRead,BufNewFile *.pl setfiletype prolog


" AUTOCOMMANDS: colorscheme by filetype
au BufEnter,BufRead,BufNewFile,BufFilePost * colorscheme CandyPaper | call CustomizedColors()
au BufEnter,BufRead,BufNewFile,BufFilePost *.js colorscheme blazer | call CustomizedColors()
au BufEnter,BufRead,BufNewFile,BufFilePost .*vimrc colorscheme CandyPaper | call CustomizedColors()


" AUTOCOMMAND: remove trailing whitespace in python files on write
au BufWritePre * %s/\s\+$//e

