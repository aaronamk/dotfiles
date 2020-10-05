set viminfo+=n~/.config/nvim/viminfo

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('/home/ak/.local/share/nvim/plugged')

"Plug 'vifm/vifm.vim'                       " vifm integration
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neovim/nvim-lspconfig'               " completion
"Plug 'nvim-lua/completion-nvim'            " completion
Plug 'dense-analysis/ale'                  " linting
Plug 'airblade/vim-gitgutter'              " git change indicators
Plug 'morhetz/gruvbox'                     " color scheme
Plug 'rrethy/vim-hexokinase'               " highlight colors in that color
Plug 'tpope/vim-repeat'                    " . repeating for plugins
Plug 'tpope/vim-surround'                  " delimiter keys
Plug 'Raimondi/delimitMate'                " delimiter auto pairing
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
set cc=81,121
hi ColorColumn ctermbg=236

syntax on
set number
set cursorline " highlight current line

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""" General
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set leader key
"map " " nop
let mapleader=" "

set autoindent
filetype plugin indent on

set scrolloff=10

filetype plugin on " detect file type
set path+=**
set title
set mouse=a
set clipboard=unnamedplus
set spell

" undo
set undodir=$XDG_CACHE_HOME/nvim/undodir
set undofile

" file completion
set wildmenu
set wildmode=longest,list,full

" auto update file when changed somewhere else
set autoread
au FocusGained * :checktime

" fixes gitgutter update time
set updatetime=100

" settings for delimiter matching
let delimitMate_expand_cr = 1
let delimitMate_expand_space = 1

" completion
lua << EOF
require'nvim_lsp'.pyls.setup{}
EOF

set completeopt-=preview

" use omni completion provided by lsp
autocmd Filetype python setlocal omnifunc=v:lua.vim.lsp.omnifunc

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""" Individual settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" netrw settings
let g:netrw_banner=0     " remove banner
let g:netrw_liststyle=3  " set to tree view
let g:netrw_dirhistmax=0 " disable annoying hist file

" plaintext file options
autocmd BufRead *.txt set lbr

" latex
let g:neotex_enabled=2 " enable latex compiling
let g:tex_flavor = 'latex' " fix latex problem
"autocmd BufRead,BufNewFile *.tex set filetype=tex

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""" Keybindings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Make Y work the way you'd expect
map Y y$

" enable deleting a word like other editors
nnoremap <BS> bcw

" quickly write a file
nnoremap <Leader>w :w<CR>

" nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>

" fzf
nnoremap <c-_> :GFiles<CR>

" find/replace
nnoremap <Leader>/ :%s//g<Left><Left>
vnoremap <Leader>/ "fy:%s//g<Left><Left><c-r>f/

" screen split hotkeys
set splitbelow splitright
nnoremap <c-j> <c-w>w
nnoremap <c-k> <c-w>W
nnoremap <Leader> <CR> :noh<CR>

" switch between header and source
map <c-space> :call CurtineIncSw()<CR>

" TA Grading help
nnoremap <Leader>n /\ ____<Return>lllR
nnoremap <Leader>N /\ ____<Return>NlllR
