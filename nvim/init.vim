" Vim config file
" Author: aaronamk

call plug#begin('$XDG_DATA_HOME/nvim/plugged')
  Plug 'neovim/nvim-lspconfig'                " LSP
  Plug 'Raimondi/delimitMate'                 " delimiter auto pairing
  Plug 'farmergreg/vim-lastplace'             " restore last cursor position
  Plug 'tpope/vim-repeat'                     " . repeating for plugins
  Plug 'wellle/targets.vim'                   " better text objects
  Plug 'tpope/vim-surround'                   " delimiter bindings
  Plug 'tpope/vim-fugitive'                   " git integration
  Plug 'junegunn/gv.vim'                      " commit history
  Plug 'airblade/vim-gitgutter'               " git change indicators
  Plug 'junegunn/fzf.vim'                     " fzf integration
  Plug 'ericcurtin/CurtineIncSw.vim'          " header/source switching
  Plug 'nvim-treesitter/nvim-treesitter', { 'commit': '42ca4a4'}      " better syntax highlighting
  Plug 'itchyny/lightline.vim'                " set status line
  Plug 'morhetz/gruvbox'                      " color scheme
  Plug 'andis-spr/lightline-gruvbox-dark.vim' " gruvbox for lightline
  Plug 'rrethy/vim-hexokinase'                " highlight colors in that color
  Plug 'donRaphaco/neotex', { 'for': 'tex'}   " tex compiler
  "Plug 'vifm/vifm.vim'                        " vifm integration
  "Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " don't need this?
  "Plug 'dense-analysis/ale'                   " linting
call plug#end()

" ------------------------------------------------------------------------------
" General

" set leader key
noremap <space> <nop>
let mapleader=" "

" set root directory
autocmd BufEnter *.*pp :Gcd " throws an error if not in git repo

filetype plugin indent on " detect file type
set autoindent
set scrolloff=10
set title
set mouse=a
set clipboard=unnamedplus
set spell
set hidden " enable switching buffers without save
set updatetime=100 " fixes gitgutter update time

" whitespace
set tabstop=4
set shiftwidth=4
set list
set listchars=tab:>-
autocmd BufWritePre * %s/\s\+$//e " Delete trailing whitespace

" undo
set undodir=$XDG_CACHE_HOME/nvim/undodir
set undofile

" file completion
set path+=**
set wildmenu
set wildmode=longest,list,full
set completeopt=menuone,noinsert

set inccommand=split
augroup LuaHighlight
  autocmd!
  autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END

" auto update file when changed somewhere else
set autoread
au FocusGained * :checktime

" fix weird resizing bug
autocmd VimEnter * :silent exec "!kill -s SIGWINCH $PPID"

" ------------------------------------------------------------------------------
" Individual settings

lua <<EOF
-- treesitter highlighting
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
}

-- LSP
  require'lspconfig'.ccls.setup{}
  require'lspconfig'.pyls.setup{}
  require'lspconfig'.bashls.setup{}
EOF
" use omni completion provided by lsp
autocmd Filetype * setlocal omnifunc=v:lua.vim.lsp.omnifunc

" treesitter folding
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevelstart=99

" settings for delimiter matching
let delimitMate_expand_cr = 1
let delimitMate_expand_space = 1
let delimitMate_excluded_regions = ""

" netrw
let g:netrw_banner = 0     " remove banner
let g:netrw_liststyle = 3  " set to tree view
let g:netrw_dirhistmax = 0 " disable annoying hist file

" plaintext file options
autocmd BufRead *.txt set lbr

" latex
let g:neotex_enabled = 2 " enable latex compiling
let g:tex_flavor = 'latex' " fix latex problem
"autocmd BufRead,BufNewFile *.tex set filetype=tex

" ------------------------------------------------------------------------------
" Keybindings

" Make Y work the way you'd expect
nmap Y y$

" vim surround visual mode (use c instead of s)
vmap s S

" for easier use of macros
vmap Q @q

" ctrl-backspace deletes word
inoremap <c-h> <c-w>

" quickly write a file
nnoremap <Leader>w :update<CR>
" quickly reload a file
nnoremap <Leader>e :edit<CR>

" find/replace
nnoremap <Leader>/ :%s//g<Left><Left>
vnoremap <Leader>/ "fy:%s//g<Left><Left><c-r>f/

" use tab to cycle through search results
set wildcharm=<c-z>
cnoremap <expr> <Tab>   getcmdtype() =~ '[?/]' ? "<c-g>" : "<c-z>"
cnoremap <expr> <S-Tab> getcmdtype() =~ '[?/]' ? "<c-t>" : "<S-Tab>"

inoremap <expr> <Tab> pumvisible() ? "\<c-n>" : "\<c-x>\<c-o>"
inoremap <expr> <CR>  pumvisible() ? "\<c-y>" : "\<CR>"
inoremap <expr> <Esc> pumvisible() ? "\<c-e>" : "\<Esc>"

" LSP
nnoremap <silent> K  <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gl <cmd>lua vim.lsp.diagnostic.set_loclist()<CR>
nnoremap <silent> cd <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>

" switch between header and source
"nnoremap <c-space> :ClangdSwitchSourceHeader<CR>
nnoremap <c-space> :call CurtineIncSw()<CR>

" fzf
nnoremap <c-_> :GFiles<CR>

" screen split hotkeys
set splitbelow splitright
nnoremap <c-j> <c-w>w
nnoremap <c-k> <c-w>W

" clear search
nnoremap <Leader><Esc> :noh<CR>

" ------------------------------------------------------------------------------
" Appearance

let g:gruvbox_contrast_dark = "hard"
let g:gruvbox_italic = 1
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
colorscheme gruvbox
set termguicolors
let g:Hexokinase_highlighters = ['backgroundfull'] " highlight colors
let g:Hexokinase_optInPatterns = 'full_hex,rgb,rgba,hsl,hsla,'
highlight VertSplit cterm=NONE                   " remove ugly split indicator

" lightline
let g:lightline = {
  \ 'colorscheme': 'gruvboxdark',
  \ 'active': {
  \    'left': [ [ 'mode', 'paste' ],
  \              [ 'filename', 'readonly', 'percentwin' ] ],
  \   'right': [ [ 'gitbranch' ] ]
  \ },
  \ 'component_function': {
  \   'filename': 'LightlineFilename',
  \   'gitbranch': 'LightlineFugitive',
  \ },
  \ 'mode_map': {
  \   'n' : '',
  \   'i' : 'I',
  \   'R' : 'R',
  \   'v' : 'V',
  \   'V' : 'VL',
  \   "\<C-v>": 'VB',
  \   'c' : 'C',
  \   's' : 'S',
  \   'S' : 'SL',
  \   "\<C-s>": 'SB',
  \ 't': 'T',
  \ },
  \ }

function! LightlineFilename()
  let filename = expand('%:f') !=# '' ? expand('%:f') : '[NEW]'
  let modified = &modified ? '*' : ''
  return filename . modified
endfunction

function! LightlineFugitive()
  let mark = ' '
  let branch = FugitiveHead()
  return branch !=# '' ? mark . branch : ''
endfunction

set noshowcmd
set noshowmode

" mark 80 character limit
set cc=81,121
hi ColorColumn ctermbg=236

set number
set cursorline " highlight current line

" set blinking cursor
:set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
  \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
  \,sm:block-blinkwait175-blinkoff150-blinkon175
