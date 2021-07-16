" Vim config file
" Author: aaronamk

call plug#begin('$XDG_DATA_HOME/nvim/plugged')
  Plug 'neovim/nvim-lspconfig'                       " LSP
  Plug 'hrsh7th/nvim-compe'                          " auto-completion

  Plug 'nvim-treesitter/nvim-treesitter'             " better syntax highlighting and more
  Plug 'nvim-treesitter/nvim-treesitter-textobjects' " better text objects with treesitter
  Plug 'wellle/targets.vim'                          " better text objects
  Plug 'tpope/vim-commentary'                        " commenting bindings
  Plug 'JoosepAlviste/nvim-ts-context-commentstring' " treesitter commenting bindings

  Plug 'windwp/nvim-autopairs'                        " delimiter auto pairing
  Plug 'tpope/vim-surround'                          " delimiter bindings
  Plug 'farmergreg/vim-lastplace'                    " restore last cursor position
  Plug 'tpope/vim-repeat'                            " . repeating for plugins
  Plug 'junegunn/fzf.vim'                            " fzf integration
  Plug 'ojroques/nvim-lspfuzzy'                      " lsp with fzf

  " git
  Plug 'tpope/vim-fugitive'                          " git integration
  Plug 'junegunn/gv.vim'                             " commit history
  Plug 'nvim-lua/plenary.nvim'                       " lua helpers
  Plug 'lewis6991/gitsigns.nvim'                     " git change indicators
  " Plug 'mhinz/vim-signify'                           " git change indicators

  " language specific
  Plug 'ericcurtin/CurtineIncSw.vim'                 " header/source switching
  Plug 'lervag/vimtex'                               " latex compiler

  " visual
  Plug 'morhetz/gruvbox'                             " color scheme
  Plug 'itchyny/lightline.vim'                       " set status line
  Plug 'andis-spr/lightline-gruvbox-dark.vim'        " gruvbox for lightline
  Plug 'norcalli/nvim-colorizer.lua'                 " highlight colors in that color
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
set inccommand=nosplit
set completeopt=menu,noselect

" highlight yanked text
au TextYankPost * lua vim.highlight.on_yank {on_visual = false}

" auto update file when changed somewhere else
set autoread
au FocusGained * :checktime
set shortmess+=A " avoid swap file warnings

" ------------------------------------------------------------------------------
" Individual settings

" use omni completion provided by lsp
"autocmd Filetype * setlocal omnifunc=v:lua.vim.lsp.omnifunc

" treesitter folding
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevelstart=99

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
nnoremap <silent> ]l <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <silent> [l <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> cd <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> gt <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>

cnoremap <expr> <Tab>   getcmdtype() =~ '[?/]' ? "<c-g>" : "<c-z>"
cnoremap <expr> <S-Tab> getcmdtype() =~ '[?/]' ? "<c-t>" : "<S-Tab>"

" completion to more or less match my shell
function! SmartTab()
  let before = strpart(getline('.'), -1, col('.'))
  if (!match(before, '^\s*$'))
    return "\<tab>"
  endif
  return compe#complete()
endfunction

inoremap <expr> <Tab>   pumvisible() ? "\<c-n>" : SmartTab()
inoremap <expr> <S-Tab> pumvisible() ? "\<c-p>" : "<Tab>"
inoremap <expr> <Esc>   pumvisible() ? compe#close('<c-e>') : "\<Esc>"

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


lua <<EOF
-- treesitter highlighting
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  highlight = {enable = true},
  context_commentstring = {enable = true},
  autopairs = {enable = true},
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["aB"] = "@block.outer",
        ["iB"] = "@block.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = false,
      goto_next_start = {
        ["]B"] = "@block.outer",
        ["]a"] = "@parameter.outer",
        ["]f"] = "@function.outer",
        ["]]"] = "@call.outer",
      },
      goto_next_end = {
        ["]A"] = "@parameter.outer",
        ["]F"] = "@function.outer",
        ["]["] = "@call.outer",
      },
      goto_previous_start = {
        ["[B"] = "@block.outer",
        ["[a"] = "@parameter.outer",
        ["[f"] = "@function.outer",
        ["[["] = "@call.outer",
      },
      goto_previous_end = {
        ["[A"] = "@parameter.outer",
        ["[F"] = "@function.outer",
        ["[]"] = "@call.outer",
      },
    },
  },
}

-- LSP
require'lspconfig'.ccls.setup{}
require'lspconfig'.pyright.setup{}
require'lspconfig'.bashls.setup{}
require'lspconfig'.bashls.setup{}

-- fzf LSP
require('lspfuzzy').setup {}

-- compe
require'compe'.setup {
  enabled = true;
  autocomplete = false;
  debug = false;
  min_length = 1;
  preselect = 'always';
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
  };
}

-- autopairs
require('nvim-autopairs').setup()
require("nvim-autopairs.completion.compe").setup({
  check_ts = true,
  map_cr = true, --  map <CR> on insert mode
  map_complete = true, -- it will auto insert `(` after select function or method item
  enable_check_bracket_line = false,
  ignored_next_char = "[%w%.]",
})
local npairs = require'nvim-autopairs'
local Rule   = require'nvim-autopairs.rule'

npairs.add_rules {
  Rule(' ', ' ')
    :with_pair(function (opts)
      local pair = opts.line:sub(opts.col, opts.col + 1)
      return vim.tbl_contains({ '()', '[]', '{}' }, pair)
    end),
  Rule('( ',' )')
        :with_pair(function() return false end)
        :with_move(function() return true end)
        :use_key(")")
}

-- git signs
require('gitsigns').setup {
  signs = {
    add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
    change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
  },
  signcolumn = true,
  numhl = false,
  linehl = false,
  keymaps = {
    -- Default keymap options
    noremap = true,
    buffer = true,

    ['n ]h'] = '<cmd>lua require"gitsigns.actions".next_hunk()<CR>',
    ['n [h'] = '<cmd>lua require"gitsigns.actions".prev_hunk()<CR>',

    ['n <leader>h'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
    ['v <leader>h'] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',

    -- Text objects
    ['o ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
    ['x ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>'
  },
  watch_index = {
    interval = 1000,
    follow_files = true
  },
  current_line_blame = true,
  current_line_blame_delay = 40,
  current_line_blame_position = 'eol',
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  word_diff = false,
  use_decoration_api = true,
  use_internal_diff = true,  -- If luajit is present
}

-- nvim-colorizer
require('colorizer').setup({'*'},{names = false;})
EOF
