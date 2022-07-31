set background=dark
set encoding=utf-8
set fileformat=unix
set fileformats=unix,dos
set mouse=a

set number              " show line numbers
set relativenumber      " show relative line numbers

set tabstop=4           " number of visual spaces per TAB
set softtabstop=4       " number of spaces in tab when editing
set shiftwidth=4        " number of spaces when shifting
set expandtab           " tabs are spaces

set backspace=indent,eol,start
set autoindent

set foldenable          " enable folding
set foldlevelstart=99   " open most folds by default
set foldlevel=99        " open most folds by default
set foldmethod=indent   " fold based on indent level

set wildmenu            " menu for completion
set completeopt=menu,menuone,noselect
set hidden

" Netrw
let g:netrw_banner = 0
let g:netrw_liststyle= 3
let g:netrw_winsize = 20
let g:netrw_browse_split = 4
let g:netrw_altv = 1

" remap to move within windows without pressing ctrl+w
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>