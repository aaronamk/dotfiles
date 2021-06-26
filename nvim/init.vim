" Vim config file
" Author: aaronamk

call plug#begin('$XDG_DATA_HOME/nvim/plugged')
  Plug 'neovim/nvim-lspconfig'                " LSP
  Plug 'hrsh7th/nvim-compe'                   " auto-completion
  Plug 'Raimondi/delimitMate'                 " delimiter auto pairing
  Plug 'farmergreg/vim-lastplace'             " restore last cursor position
  Plug 'tpope/vim-repeat'                     " . repeating for plugins
  Plug 'wellle/targets.vim'                   " better text objects
  Plug 'tpope/vim-surround'                   " delimiter bindings
  Plug 'tpope/vim-fugitive'                   " git integration
  Plug 'junegunn/gv.vim'                      " commit history
  Plug 'mhinz/vim-signify'                    " git change indicators
  Plug 'junegunn/fzf.vim'                     " fzf integration
  Plug 'ojroques/nvim-lspfuzzy'               " lsp with fzf
  Plug 'ericcurtin/CurtineIncSw.vim'          " header/source switching
  Plug 'nvim-treesitter/nvim-treesitter'      " better syntax highlighting
  Plug 'itchyny/lightline.vim'                " set status line
  Plug 'morhetz/gruvbox'                      " color scheme
  Plug 'andis-spr/lightline-gruvbox-dark.vim' " gruvbox for lightline
  Plug 'rrethy/vim-hexokinase'                " highlight colors in that color
  Plug 'lervag/vimtex'                        " latex compiler
call plug#end()

" ------------------------------------------------------------------------------
" General

" set leader key
noremap <space> <nop>
let mapleader=" "

" set root directory
autocmd BufEnter * :silent! Gcd " Ignores error if not in git repo

filetype plugin indent on " detect file type
set scrolloff=10
set title
set mouse=a
set clipboard=unnamedplus
set spell
set hidden " enable switching buffers without save
set updatetime=100 " fixes git update time

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
set completeopt=menuone,noselect
set inccommand=split

" highlight yanked text
au TextYankPost * lua vim.highlight.on_yank {on_visual = false}

" auto update file when changed somewhere else
set autoread
au FocusGained * :checktime
set shortmess+=A " avoid swap file warnings

" fix terminal resizing bug
autocmd VimEnter * :silent exec "!kill -s SIGWINCH $PPID"

" ------------------------------------------------------------------------------
" Individual settings

lua <<EOF
-- treesitter highlighting
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  highlight = {enable = true},
}

-- LSP
require'lspconfig'.ccls.setup{}
require'lspconfig'.pyright.setup{}
require'lspconfig'.bashls.setup{}

-- fzf LSP
require('lspfuzzy').setup {}

-- nvim-compe
vim.o.completeopt = "menuone,noselect"

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 0;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    nvim_lsp = true;
    snippets_nvim = true;
  };
}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif vim.fn.call("vsnip#available", {1}) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    -- If <S-Tab> is not working in your terminal, change it to <C-h>
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
EOF
" use omni completion provided by lsp
"autocmd Filetype * setlocal omnifunc=v:lua.vim.lsp.omnifunc

" treesitter folding
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevelstart=99

" git indicator settings
let g:signify_sign_change = '~'

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
let g:vimtex_view_general_viewer = 'omni-open.sh'

" ------------------------------------------------------------------------------
" Keybindings

" Make Y work the way you'd expect
nmap Y y$

" vim surround visual mode (use c instead of s)
vmap s S

" for easier use of macros
nmap Q @q

" ctrl-backspace deletes word
inoremap <c-h> <c-w>

" quickly write a file
nnoremap <Leader>w :update<CR>
" quickly reload a file
nnoremap <Leader>e :edit<CR>

" find/replace
nnoremap <Leader>/ :%s//g<Left><Left>
vnoremap <Leader>/ "fy:%s//g<Left><Left><c-r>f/

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
nnoremap <Esc> :cclose<CR>

" ------------------------------------------------------------------------------
" Appearance

let g:gruvbox_contrast_dark = "hard"
let g:gruvbox_italic = 1
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set termguicolors
colorscheme gruvbox

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
set fillchars=eob:\ , " remove ~ markers after buffer

" set blinking cursor
:set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
  \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
  \,sm:block-blinkwait175-blinkoff150-blinkon175
