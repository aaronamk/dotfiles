" Vim config file
" Author: aaronamk

call plug#begin('$XDG_DATA_HOME/nvim/plugged')
  " streamlined editing
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " smart syntax parser
  Plug 'nvim-treesitter/nvim-treesitter-textobjects'          " treesitter text objects
  Plug 'wellle/targets.vim'                                   " better text objects
  Plug 'tpope/vim-commentary'                                 " commenting bindings
  Plug 'windwp/nvim-autopairs'                                " delimiter auto pairing
  Plug 'tpope/vim-surround'                                   " delimiter bindings
  Plug 'tpope/vim-repeat'                                     " . repeating for plugins
  Plug 'lervag/vimtex'                                        " latex compiler
  "Plug 'ericcurtin/CurtineIncSw.vim'                          " header/source switching

  " LSP/navigation
  Plug 'neovim/nvim-lspconfig'                                " LSP configuration
  Plug 'hrsh7th/nvim-compe'                                   " completion helper
  Plug 'vijaymarupudi/nvim-fzf'                               " lua fzf implementation
  Plug 'ibhagwan/fzf-lua'                                     " lua fzf bindings

  " git
  Plug 'tpope/vim-fugitive'                                   " git integration
  Plug 'nvim-lua/plenary.nvim'                                " lua helpers
  Plug 'lewis6991/gitsigns.nvim'                              " git change indicators

  " appearance
  Plug 'morhetz/gruvbox'                                      " color scheme
  Plug 'hoob3rt/lualine.nvim'                                 " status line
  Plug 'nvim-treesitter/nvim-treesitter-refactor'             " highlight references
  Plug 'norcalli/nvim-colorizer.lua'                          " highlight colors
call plug#end()


" General
" ------------------------------------------------------------------------------
" fix terminal resizing bug
autocmd VimEnter * :silent exec "!kill -s SIGWINCH $PPID"

" update file when changed somewhere else
set autoread
autocmd FocusGained * :checktime
set shortmess+=A " avoid swap file warnings
set hidden " enable switching buffers without save
set updatetime=0

" save cursor position and folds
autocmd BufWinLeave *.* silent! mkview
autocmd BufWinEnter *.* silent! loadview
set viewoptions=cursor,folds

" save undo history
set undodir=$XDG_CACHE_HOME/nvim/undodir
set undofile

" set root directory
autocmd BufEnter * :silent! Gcd " Ignores error if not in git repo

" detect file type
autocmd VimEnter * if &filetype == "" | setlocal ft=text | endif
filetype plugin indent on

" scrolling
set scrolloff=10
set scroll=10
autocmd VimResized * :set scroll=10
autocmd WinEnter * :set scroll=10

set title " set window title
set mouse=a " enable mouse

" whitespace
set tabstop=4
set shiftwidth=4
set list
set listchars=tab:>-,trail:·

" file completion
set path+=**
set wildmenu
set wildmode=longest,list,full
set inccommand=nosplit
set completeopt=menu,noselect

" clipboard
set clipboard=unnamedplus
autocmd TextYankPost * lua vim.highlight.on_yank { on_visual = false }

" folding
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevelstart=99

" netrw
let g:netrw_banner = 0     " remove banner
let g:netrw_liststyle = 3  " set to tree view
let g:netrw_dirhistmax = 0 " disable annoying hist file


" Plugin settings
" ------------------------------------------------------------------------------
" use omni completion provided by lsp
"autocmd Filetype * setlocal omnifunc=v:lua.vim.lsp.omnifunc

" latex
let g:vimtex_view_general_viewer = 'omni-open.sh'


" Keybindings
" ------------------------------------------------------------------------------
" set leader key
noremap <space> <nop>
let mapleader=" "

" for some reason need these, events don't work for jumps
nnoremap <c-o> <c-o>:loadview<cr>:<bs>
nnoremap <c-i> <c-i>:loadview<cr>:<bs>

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
nnoremap <Leader>e :mkview<CR>:edit<CR>

" remove trailing spaces
nnoremap <Leader><space> :%s/\s\+$//e<CR>

" find/replace
nnoremap <Leader>/ :%s//g<Left><Left>
vnoremap <Leader>/ "fy:%s//g<Left><Left><c-r>f/

" screen split hotkeys
set splitbelow splitright
nnoremap <c-j> <c-w>w
nnoremap <c-k> <c-w>W

" clear search
nnoremap <Esc> :noh<CR>:<bs>

" switch between header and source
nnoremap <c-space> :ClangdSwitchSourceHeader<CR>
"nnoremap <c-space> :call CurtineIncSw()<CR>

" fzf
nnoremap <c-_> :FzfLua files<CR>
nnoremap z= :FzfLua spell_suggest<CR>
nnoremap g/ :FzfLua builtin<CR>

" LSP
nnoremap <silent> K  <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gl <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nnoremap <silent> ]l <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <silent> [l <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> gt <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> cd <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> gr :FzfLua lsp_references<CR>

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

"if (:set modifiable?) == "nomodifiable" | nnoremap <silent> <Esc> :q<CR> | endif


" Appearance
" ------------------------------------------------------------------------------
let g:gruvbox_contrast_dark = "hard"
let g:gruvbox_italic = 1
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set termguicolors
colorscheme gruvbox

set number " add line numbers
set fillchars=eob:\ , " remove ~ markers after buffer

set noshowcmd
set noshowmode

" set blinking cursor
:set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
  \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
  \,sm:block-blinkwait175-blinkoff150-blinkon175

" mark 80 character limit
set cc=81,121
" highlight current line
set cursorline

" remove ugly split indicator
highlight VertSplit cterm=NONE

" Set highlight groups
highlight       CursorLineNR guifg=#fbf1c7 guibg=#282828
highlight       CursorLine                 guibg=#282828
highlight       ColorColumn                guibg=#282828
highlight link  Delimiter         GruvboxFg0
highlight clear Identifier
highlight link  Identifier        GruvboxFg0
highlight link  Type              GruvboxYellow
highlight link  Operator          GruvboxOrange
highlight link  Keyword           GruvboxRed
highlight link  Function          GruvboxBlue
highlight link  TSFuncBuiltin     GruvboxBlue
highlight link  TSTextReference   GruvboxBlue
highlight link  TSConstructor     GruvboxFg0
highlight link  TSConstBuiltin    GruvboxPurple
highlight clear Search
highlight       Search            gui=reverse
highlight clear IncSearch
highlight       IncSearch         gui=reverse
highlight       TSDefinitionUsage guibg=#3c3836
highlight       TSDefinition      guibg=#3c3836
highlight       TSVariableBuiltin ctermfg=229 guifg=#fbf1c7 cterm=bold,italic gui=bold,italic

" lsp diagnostics
sign define LspDiagnosticsSignError text= texthl= linehl= numhl=GruvboxRedBold
sign define LspDiagnosticsSignWarning text= texthl= linehl= numhl=GruvboxYellowBold
sign define LspDiagnosticsSignInformation text= texthl= linehl= numhl=GruvboxBlueBold
sign define LspDiagnosticsSignHint text= texthl= linehl= numhl=GruvboxPurpleBold


" Lua
" ------------------------------------------------------------------------------
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
  refactor = {
    highlight_definitions = { enable = true },
  },
}


-- LSP
require'lspconfig'.clangd.setup{}
require'lspconfig'.pyright.setup{}
require'lspconfig'.bashls.setup{}
require'lspconfig'.bashls.setup{}


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
    add          = {hl = 'GruvboxGreenSign',  text = ' ┃', numhl='GitSignsAddNr',    linehl='GitSignsAddLn'},
    change       = {hl = 'GruvboxOrangeSign', text = '▪ ', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete       = {hl = 'GruvboxOrangeSign', text = ' ▁', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete    = {hl = 'GruvboxOrangeSign', text = ' ▔', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GruvboxOrangeSign', text = '▪▁', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
  },

  signcolumn = true,
  numhl = false,
  linehl = false,
  watch_index = { interval = 1000, follow_files = true
  },
  current_line_blame = true,
  current_line_blame_opts = { delay = 40, position = 'eol' },
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  word_diff = false,
  use_internal_diff = true,  -- If luajit is present

  keymaps = {
    -- Default keymap options
    noremap = true,
    buffer = true,

    ['n ]h'] = '<cmd>lua require"gitsigns.actions".next_hunk()<CR>',
    ['n [h'] = '<cmd>lua require"gitsigns.actions".prev_hunk()<CR>',

    ['n gh'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
    ['n zh'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
    ['v zh'] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    ['n zH'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',

    -- Text objects
    ['o ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
    ['x ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>'
  },
}


-- fzf-lua
require('fzf-lua').setup { previewers = { builtin = { delay = 0, }, }, }


-- lualine
require'lualine'.setup {
  options = {theme = 'gruvbox', section_separators = '', component_separators = ''},
  sections = {
    lualine_a = {{'filename', file_status = true, path = 1}},
    lualine_b = {'progress'},
    lualine_c = {{'diagnostics', sources = {'nvim_lsp'}, symbols = {error = '❌', warn = '!', info = 'i', hint = 'h'}}},
    lualine_x = {}, lualine_y = {},
    lualine_z = {'branch'}
    }
}


-- nvim-colorizer
require('colorizer').setup({'*'},{names = false;})
EOF
