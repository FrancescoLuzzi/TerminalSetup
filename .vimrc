" In insert mode steady bar (|) else steady block
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

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
set smartindent         "does the right thing (mostly) in programs
set backspace=indent,eol,start  " more powerful backspacing
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
" add event listeners mapping
augroup my_mappings
    autocmd!
    " call mappings on netrw open
    autocmd filetype netrw :call NetrwMapping()
    " trim spaces
    autocmd BufWritePre * :%s/\s\+$//e
    " trim spaces for ruby files
    autocmd BufWritePre *.rb :%s/\s\+$//e
augroup END

" add mapping to netrw
function! NetrwMapping()
    " map F2 to close Explore when open
    map <buffer> <F2> :Rex<CR>
endfunction


" NORMAL MODE MAPPINGS

" remap to move within windows without pressing ctrl+w
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" fast move with Shift + k/j
nnoremap <buffer> <S-K> 10k
nnoremap <buffer> <S-J> 10j

" remap to move between buffers Ctrl + ->/<-
nnoremap <C-Left> :bp<CR>
nnoremap <C-Right> :bn<CR>

" delete current buffer Ctrl + k
nnoremap <C-D> :bdelete<CR>

" VISUAL MODE REMAPS

" move selected lines with Shift + k/j
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '>-2<CR>gv=gv


" ALL MODES REMAPS

" key remap to open Explorer in new tab
noremap <buffer> <F1> <Esc>:FZF<CR>
noremap <buffer> <F2> <Esc>:Explore<CR>


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
call plug#end()

" set color scheme
colorscheme gruvbox

let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" custom remaps with front <Space>

let mapleader = " "
nnoremap <leader>+ <C-W>+
nnoremap <leader>- <C-W>-
nnoremap <leader>= <C-W>=
nmap <leader>v <C-w>v<C-L>
