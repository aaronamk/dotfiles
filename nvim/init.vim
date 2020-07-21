set viminfo+=n~/.config/nvim/viminfo

"let g:ale_complion_enabled=1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('/home/ak/.local/share/nvim/plugged')

"Plug 'vifm/vifm.vim'                       " vifm integration
Plug 'morhetz/gruvbox'                     " color scheme
Plug 'rrethy/vim-hexokinase'               " highlight colors in that color
Plug 'dense-analysis/ale'                  " linting
Plug 'jiangmiao/auto-pairs'                " delimiter auto pairing
Plug 'airblade/vim-gitgutter'              " git change indicators
Plug 'donRaphaco/neotex', { 'for': 'tex'}  " tex compiler
Plug 'ericcurtin/CurtineIncSw.vim'         " header/source switching

call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""" Appearance
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" theming
let g:gruvbox_contrast_dark="hard"
let g:gruvbox_italic=1
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
autocmd vimenter * colorscheme gruvbox
set termguicolors
let g:Hexokinase_highlighters=['backgroundfull'] " highlight colors
highlight VertSplit cterm=NONE                   " remove ugly split indicator

" whitespace
set tabstop=4
set shiftwidth=4
set list
set listchars=tab:>-
autocmd BufWritePre * %s/\s\+$//e " Delete trailing whitespace

" mark 80 character limit
set cc=81
hi ColorColumn ctermbg=236

syntax on
set number
set cursorline " highlight current line

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""" General
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set leader key
let mapleader=" "

filetype plugin on " detect file type
set path+=**
set nocompatible
set title
set mouse=a
set clipboard=unnamedplus

" undo
set undodir=$XDG_CACHE_HOME/nvim/undodir
set undofile

" file completion
set wildmenu
set wildmode=longest,list,full

" auto update file when changed somewhere else
set autoread
au FocusGained * :checktime

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
let g:neotex_enabled=2  " enable latex compiling

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""" Keybindings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Make Y work the way you'd expect
map Y y$

" enable ctrl+delete like other editors
nnoremap <BS> bcw

" find/replace
nnoremap <Leader>/ :%s//g<Left><Left>
vnoremap <Leader>/ "fy:%s//g<Left><Left><c-r>f/

" screen split hotkeys
set splitbelow splitright
map <c-h> <c-w>h
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
nnoremap <silent> <CR> :noh<CR><CR>

" switch between header and source
map <c-space> :call CurtineIncSw()<CR>

" TA Grading help
nnoremap <Leader>n /\ ____<Return>lllR
nnoremap <Leader>N /\ ____<Return>NlllR
