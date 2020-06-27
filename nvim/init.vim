set viminfo+=n~/.config/nvim/viminfo

let mapleader=" "

let g:neotex_enabled=2
"let g:deoplete#enable_at_startup=1
"let g:ale_complion_enabled=1
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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""" Theming
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
autocmd vimenter * colorscheme gruvbox
set termguicolors
let g:Hexokinase_highlighters=['backgroundfull'] " highlight colors
highlight VertSplit cterm=NONE " remove ugly split indicator

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""" General
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin on " detect file type
set path+=**
set nocompatible
set title
set mouse=a
set clipboard=unnamedplus
syntax on
set number

" undo
set undodir=$XDG_CACHE_HOME/nvim/undodir
set undofile

" completion
set wildmenu
set wildmode=longest,list,full

" auto update file when changed from something else
set autoread
au FocusGained * :checktime

" Whitespace
set tabstop=4
set shiftwidth=4
set list
set listchars=tab:>-
autocmd BufWritePre * %s/\s\+$//e " Delete trailing whitespace

" mark 80 character limit
set cc=81
hi ColorColumn ctermbg=236

" highlight current line
set cursorline

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""" Individual settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" netrw settings
let g:netrw_banner=0     " remove banner
let g:netrw_liststyle=3  " set to tree view
let g:netrw_dirhistmax=0 " disable annoying hist file

" plaintext file options
autocmd BufRead *.txt set spell
autocmd BufRead *.txt set lbr

" fix latex problem
autocmd BufRead,BufNewFile *.tex set filetype=tex

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""" Keybindings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Make Y work the way you'd expect
map Y y$

" enable ctrl+delete like other editors
nnoremap <BS> bcw

" find/replace
nnoremap <Leader>/ :%s//g<Left><Left>
vnoremap <Leader>/ "fy:%s//g<Left><Left><c-r>f/

" screen splits hotkeys
set splitbelow splitright
map <c-h> <c-w>h
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
nnoremap <silent> <CR> :noh<CR><CR>

" switch between header and source
map <c-space> :call CurtineIncSw()<CR>

" TA Grading help
nnoremap <Leader>n /\ ___<Return>lllR
nnoremap <Leader>N /\ ___<Return>NlllR
