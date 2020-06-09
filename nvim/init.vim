set viminfo+=n~/.config/nvim/viminfo

let mapleader=" "

let g:neotex_enabled=2
"let g:deoplete#enable_at_startup = 1
"let g:ale_complion_enabled = 1
let g:gruvbox_contrast_dark="hard"
let g:gruvbox_italic=1

" plugins
call plug#begin('/home/ak/.local/share/nvim/plugged')

"Plug 'vifm/vifm.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'dense-analysis/ale'
Plug 'airblade/vim-gitgutter'
Plug 'donRaphaco/neotex', { 'for': 'tex'}
Plug 'ericcurtin/CurtineIncSw.vim'
Plug 'rrethy/vim-hexokinase'
Plug 'morhetz/gruvbox'
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

call plug#end()

" plaintext file options
autocmd BufRead *.txt set spell
autocmd BufRead *.txt set lbr

au FocusGained * :checktime

" fix latex problem
autocmd BufRead,BufNewFile *.tex set filetype=tex

" auto update file when changed from something else
set autoread
set nocompatible
filetype plugin on
set path+=**

let $NVIM_TUI_ENABLE_TRUE_COLOR=1
autocmd vimenter * colorscheme gruvbox
set termguicolors
let g:Hexokinase_highlighters = ['backgroundfull']

set title
set mouse=a
set clipboard=unnamedplus
syntax on
set number

highlight VertSplit cterm=NONE

" netrw settings
let g:netrw_banner = 0
let g:netrw_liststyle = 3

" file opening completion
set wildmenu
set wildmode=longest,list,full

" use tabs
set tabstop=4
set shiftwidth=4
set list
set listchars=tab:>-

" Delete trailing whitespace
autocmd BufWritePre * %s/\s\+$//e

" mark 80 character limit
set cc=81
hi ColorColumn ctermbg=236

" Make Y work the way you'd expect
map Y y$

" enable ctrl+delete like other editors
nnoremap <BS> bcw

" find/replace
nnoremap <Leader>/ :%s//g<Left><Left>
vnoremap <Leader>/ "fy:%s//g<Left><Left><c-r>f/

" screen splitting hotkeys to mirror window manager
set splitbelow splitright
map <c-h> <c-w>h
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
nnoremap <silent> <CR> :noh<CR><CR>

" switch between header and source
map <c-space> :call CurtineIncSw()<CR>

" disable annoying hist file
let g:netrw_dirhistmax = 0
