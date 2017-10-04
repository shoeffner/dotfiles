" VUNDLE
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'

" Plugin 'w0rp/ale'

" Plugin 'elzr/vim-json'
" Plugin 'chrisbra/csv.vim'

Plugin 'flazz/vim-colorschemes'
" Plugin 'yosiat/oceanic-next-vim'

" Plugin 'vim-airline/vim-airline'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'

" Plugin 'mhinz/vim-startify'

Plugin 'klen/python-mode'

" Plugin 'vim-pandoc/vim-pandoc'
" Plugin 'vim-pandoc/vim-pandoc-syntax'

call vundle#end()


" DEFAULT SETTINGS
filetype plugin indent on
syntax on
set synmaxcol=1024
set ttyfast
set ttyscroll=3
set lazyredraw
set tabstop=4
set shiftwidth=4
set expandtab
set relativenumber
set number
set ruler
set incsearch
" set autoread
set t_Co=256
set laststatus=2  " PLUGIN: Airline


" AUTOCOMMANDS: filetypes by extension
au BufRead,BufNewFile *.ipynb setfiletype json
au BufRead,BufNewFile .eslintrc setfiletype json
au BufRead,BufNewFile *.pl setfiletype prolog
au BufRead,BufNewFile *.beamer setfiletype tex
au BufRead,BufNewFile *.cpp,*.hpp,*.h set tabstop=2
au BufRead,BufNewFile *.cpp,*.hpp,*.h set shiftwidth=2
au BufRead,BufNewFile *.cpp,*.hpp,*.h set expandtab


" AUTOCOMMANDS: colorscheme by filetype
au BufEnter,BufRead,BufNewFile,BufFilePost * colorscheme CandyPaper
au BufEnter,BufRead,BufNewFile,BufFilePost *.js colorscheme blazer
au BufEnter,BufRead,BufNewFile,BufFilePost .*vimrc colorscheme CandyPaper


" AUTOCOMMAND: remove trailing whitespace in files on write
au BufWritePre * %s/\s\+$//e
" au BufWritePre,BufRead *.py PymodeLintAuto

" KEYMAP
" move around on soft wrapped lines as if they were hard wrapped
nnoremap j gj
nnoremap k gk
" jump between splits without the C-W first
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>
nnoremap <C-h> <C-w><C-h>
" nmap <silent> <C-k> <Plug>(ale_previous_wrap)
" nmap <silent> <C-j> <Plug>(ale_next_wrap)


" PLUGIN: ale
let g:ale_sign_column_always = 1
let g:ale_sign_error = '!!'
let g:ale_sign_warning = '¡¡'


" PLUGIN: GitGutter
let g:gitgutter_override_sign_column_highlight = 0
let g:gitgutter_sign_removed = '-'
highlight GitGutterAdd ctermfg=34
highlight GitGutterChange ctermfg=184
highlight GitGutterChangeDelete ctermfg=184
highlight GitGutterDelete ctermfg=124


" PLUGIN: python-mode
let g:pymode_python = 'python3'
let g:pymode_folding = 0
let g:pymode_rope = 0
let g:pymode_rope_autoimport = 0
let g:pymode_rope_lookup_project = 0


" PLUGIN: vim-pandoc
let g:pandoc#modules#disabled = ["folding"]
let g:pandoc#syntax#conceal#blacklist = ["atx"]
