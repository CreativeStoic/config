set mouse=a
set rnu nu
inoremap jk 
let mapleader = ";"
nnoremap <Leader>ev :vsplit ~/.vimrc
nnoremap <Leader>sv :source ~/.vimrc
nnoremap <Leader>w :w
autocmd FileType javascript nnoremap <Leader>w :Prettier:w
nnoremap <C-p> :CtrlP
nnoremap <C-h> h
nnoremap <C-k> k
nnoremap <C-l> l
nnoremap <C-j> j
set nocompatible              " be iMproved, required
syntax on
set cursorline
set expandtab
set tabstop=2
set shiftwidth=2
nnoremap <Leader>nt :NERDTree
set ttymouse=sgr
"let g:AutoPairsShortcutFastWrap = '<C-a>'
let g:ctrlp_by_filename = 1
"let g:ctrlp_custom_ignore = {'dir': '\v/(node_modules|amplify)$'}
let g:ctrlp_custom_ignore = {'dir': '\v/(node_modules)$'}
setlocal foldmethod=syntax
autocmd BufRead * normal zR
vnoremap <Leader>y "*y
set autochdir

nnoremap <Leader>p :setl noai nocin nosi inde=<CR>"*p

call plug#begin()

Plug 'prettier/vim-prettier', { 'do': 'yarn install --frozen-lockfile --production', 'branch': 'release/0.x' }
Plug 'preservim/nerdtree'								" File Explorer
Plug 'tpope/vim-fugitive'								" Git wrapper
Plug 'neoclide/coc.nvim', {'branch': 'release'}								" autocomplete
Plug 'preservim/nerdcommenter'
Plug 'sheerun/vim-polyglot'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'jiangmiao/auto-pairs'             " pair brackets and quotes
Plug 'mattn/emmet-vim'                  " html shortcust
Plug 'kien/ctrlp.vim'                   " file searching
Plug 'dense-analysis/ale'               " linting

call plug#end()

" ale settings
let g:ale_fixers = ['prettier', 'eslint']

" coc settings
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
