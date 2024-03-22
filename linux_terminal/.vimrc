"basic config for every VIM
set encoding=UTF-8
set noerrorbells        " no bells
set number              " show line numbers
set relativenumber      " show relative line numbers
set background=dark     " dark mode to code faster
set incsearch           " incremental research
set scrolloff=8         " start scrolling before end on visual
set nowrap              " long lines stay on the same line
set tabstop=4           " number of visual spaces per TAB
set softtabstop=4       " number of spaces in tab when editing
set shiftwidth=4        " number of spaces when shifting
set expandtab           " tabs are spaces
set autoindent          " auto indent code
set smartindent         " does the right thing (mostly) in programs
set ignorecase          " ignore casing while searching string
set smartcase           " if an upper letter is searched don't ignore casing
set backspace=indent,eol,start  " more powerful backspacing
set foldenable          " enable folding
set foldlevelstart=99   " open most folds by default
set foldlevel=99        " open most folds by default
set foldmethod=indent   " fold based on indent level
set wildmenu            " menu for completion
set cursorline
set completeopt=menu,menuone,noselect
set hidden

" In insert mode steady bar (|) else steady block
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" add event listeners mapping
augroup my_mappings
    autocmd!
    " trim spaces, for all files
    autocmd BufWritePre * :%s/\s\+$//e
augroup END

" enable mouse events
set mouse=a

" Netrw
let g:netrw_banner = 0
let g:netrw_liststyle= 3
let g:netrw_winsize = 50
let g:netrw_browse_split = 4
let g:netrw_altv = 0
let g:netrw_browse_split = 0

" remap to move within windows without pressing ctrl+w
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" resize windows
nnoremap <S-Right> :vertical resize -2<CR>
nnoremap <S-Left> :vertical resize +2<CR>
nnoremap <S-Up> :resize -2<CR>
nnoremap <S-Down> :resize +2<CR>

" remap to move between buffers Shift + l/h
nnoremap <S-L> :bn<CR>
nnoremap <S-H> :bp<CR>

" VISUAL MODE REMAPS

" move selected lines with Alt + k/j
vnoremap <M-J> :m '>+1<CR>gv=gv
vnoremap <M-K> :m '<-2<CR>gv=gv

" indent in visual mode
vnoremap < <gv
vnoremap > >gv

" PLUGINS

" load vim-plug

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
endif

" load plugins

call plug#begin('~/.vim/plugged')
    Plug 'gruvbox-community/gruvbox'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'preservim/nerdtree'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'machakann/vim-highlightedyank'
call plug#end()

" vim-highlightedyank
let g:highlightedyank_highlight_duration = 170

" set color scheme, silent to prevent error if not installed with :PlugInstall
silent! colorscheme gruvbox

let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" custom remaps with front <Space>

let mapleader = " "
" equalize split views
nnoremap <leader>= <C-W>=
" split view vertically
nmap <leader>\ <C-w>v<C-L>
" split view horizontally
nmap <leader>- <C-w>s<C-J>
" close all views but the one you are editing
nmap <leader>o <Esc>:only<CR>
" delete current buffer <leader>+x
nnoremap <leader>x :bdelete<CR>
" open terminal splitting view vertically
nmap <leader>t <Esc>:vert ter<CR>
" open terminal splitting view horizontally
nmap <leader>T <Esc>:ter<CR>

" open fuzzy finder
noremap <leader>sf <Esc>:FZF<CR>
noremap <leader>e <Esc>:NERDTreeToggle<CR>
