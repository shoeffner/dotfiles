" VUNDLE
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-surround'
Plugin 'python-mode/python-mode'
Plugin 'rafi/awesome-vim-colorschemes'

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
set t_Co=256


" set colorscheme
colorscheme deus


" AUTOCOMMANDS
au BufRead,BufNewFile *.ipynb,Pipfile.lock,.eslintrc setfiletype json
au BufRead,BufNewFile Pipfile setfiletype config
au BufRead,BufNewFile Dockerfile* setfiletype Dockerfile
au BufRead,BufNewFile *.pl setfiletype prolog
au BufRead,BufNewFile *.beamer setfiletype tex
au BufRead,BufNewFile *.launch setfiletype xml
au BufRead,BufNewFile *.cpp,*.hpp,*.h set tabstop=2
au BufRead,BufNewFile *.cpp,*.hpp,*.h set shiftwidth=2
au BufRead,BufNewFile *.cpp,*.hpp,*.h set expandtab
au BufEnter,BufRead,BufNewFile,BufFilePost *.md set spell


" remove trailing whitespace in files on write
au BufWritePre * %s/\s\+$//e

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

" PLUGIN: netrw
" Thanks @George Ornbo https://shapeshed.com/vim-netrw/
let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_browse_split = 2
let g:netrw_winsize = 10

" PLUGIN: YCM
let g:ycm_confirm_extra_conf = 0
let g:ycm_python_interpreter_path = ''
let g:ycm_python_sys_path = []
let g:ycm_extra_conf_vim_data = [
  \  'g:ycm_python_interpreter_path',
  \  'g:ycm_python_sys_path'
  \]
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'

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
let g:pymode_lint_ignore = ['E501']
au BufRead *.py PymodeLint
au BufWritePre *.py PymodeLint


" PLUGIN: vim-pandoc
let g:pandoc#modules#disabled = ["folding"]
let g:pandoc#syntax#conceal#blacklist = ["atx"]
