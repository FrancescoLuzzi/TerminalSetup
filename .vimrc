
" In insert mode steady bar (|) else steady block
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

set noerrorbells
set number              " show line numbers
set relativenumber      " show relative line numbers
set background=dark

set incsearch
set scrolloff=8
set nowrap

set tabstop=4           " number of visual spaces per TAB
set softtabstop=4       " number of spaces in tab when editing
set shiftwidth=4        " number of spaces when shifting
set expandtab           " tabs are spaces
set smartindent

set backspace=indent,eol,start

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
let g:netrw_browse_split = 0
let g:netrw_altv = 1
augroup netrw_mapping
    autocmd!
    autocmd filetype netrw call NetrwMapping()
augroup END

function! NetrwMapping()
    map <buffer> <F2> :Rex<CR>
endfunction
" remap to move within windows without pressing ctrl+w
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '>-2<CR>gv=gv

" remap to move between tabs
" remap to move between tabs
nnoremap <C-Left> :bp<CR>
nnoremap <C-Right> :bn<CR>
nnoremap <C-K> :bdelete<CR>
" key remap to open Explorer in new tab
map <F1> :FZF<CR>
map <F2> :Explore<CR>

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
endif

call plug#begin('~/.vim/plugged')
Plug 'gruvbox-community/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
call plug#end()
colorscheme gruvbox

let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

let mapleader = " "
nnoremap <leader>+ :vertical resize +5<CR>
nnoremap <leader>- :vertical resize -5<CR>

