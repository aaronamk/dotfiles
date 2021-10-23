lua <<EOF
require('packer').startup(function()
-- Packer can manage itself
use 'wbthomason/packer.nvim'

-- streamlined editing
--------------------------------------------------------------------------------
-- smart syntax parser
use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
use 'nvim-treesitter/nvim-treesitter-textobjects' -- treesitter text objects
use 'nvim-treesitter/nvim-treesitter-refactor' -- highlight references
-- better text objects
use 'wellle/targets.vim'
-- commenting bindings
use 'tpope/vim-commentary'
-- delimiter auto pairing
use 'windwp/nvim-autopairs'
-- delimiter bindings
use 'tpope/vim-surround'
-- . repeating for plugins
use 'tpope/vim-repeat'
-- latex compiler
use 'lervag/vimtex'
-- header/source switching
--use { 'ericcurtin/CurtineIncSw.vim'

-- LSP/navigation
--------------------------------------------------------------------------------
-- LSP configuration
use 'neovim/nvim-lspconfig'
use 'hrsh7th/nvim-cmp'         -- completion helper
use 'hrsh7th/cmp-nvim-lsp'     -- LSP completion
use 'hrsh7th/cmp-path'         -- path completion
use 'hrsh7th/cmp-nvim-lua'     -- internal lua completion
use 'L3MON4D3/LuaSnip'         -- snippets
use 'saadparwaiz1/cmp_luasnip' -- snippets cmp integration
-- lua fzf
use 'vijaymarupudi/nvim-fzf'
use 'ibhagwan/fzf-lua'

-- git
--------------------------------------------------------------------------------
-- git integration
use 'tpope/vim-fugitive'
-- git change indicators
use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }

-- appearance
--------------------------------------------------------------------------------
-- color scheme
use 'morhetz/gruvbox'
-- status line
use 'nvim-lualine/lualine.nvim'
-- highlight colors in that color
use 'norcalli/nvim-colorizer.lua'
end)


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


-- LuaSnip
require'luasnip'.config.setup{}


-- nvim-cmp
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local luasnip = require("luasnip")
local cmp = require("cmp")
require'cmp'.setup {
  
  completion = {
    autocomplete = false,
    completeopt = 'menu,noinsert'
  },

  mapping = {
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<Esc>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.abort()
      else
        fallback()
      end
    end, { "i", "s" }),
  },

  sources = {
    { name = "luasnip" },
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
    { name = "path" }
  },

  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },

  experimental = {
    ghost_text = true
  }
}


-- compe
--require'compe'.setup {
--  enabled = true;
--  autocomplete = false;
--  debug = false;
--  min_length = 1;
--  preselect = 'always';
--  throttle_time = 0;
--  source_timeout = 200;
--  incomplete_delay = 400;
--  max_abbr_width = 100;
--  max_kind_width = 100;
--  max_menu_width = 100;
--  documentation = true;
--
--  source = {
--    path = true;
--    nvim_lsp = true;
--  };
--}


-- autopairs
require('nvim-autopairs').setup()
require("nvim-autopairs.completion.cmp").setup({
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
vim.cmd("set termguicolors")
require('colorizer').setup({'*'},{names = false;})
EOF
" Vim config file
" Author: aaronamk

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
autocmd VimEnter * highlight       CursorLineNR guifg=#fbf1c7 guibg=#282828
autocmd VimEnter * highlight       CursorLine                 guibg=#282828
autocmd VimEnter * highlight       ColorColumn                guibg=#282828
autocmd VimEnter * highlight link  Delimiter         GruvboxFg0
autocmd VimEnter * highlight clear Identifier
autocmd VimEnter * highlight link  Identifier        GruvboxFg0
autocmd VimEnter * highlight link  Type              GruvboxYellow
autocmd VimEnter * highlight link  Operator          GruvboxOrange
autocmd VimEnter * highlight link  Keyword           GruvboxRed
autocmd VimEnter * highlight link  Function          GruvboxBlue
autocmd VimEnter * highlight link  TSFuncBuiltin     GruvboxBlue
autocmd VimEnter * highlight link  TSTextReference   GruvboxBlue
autocmd VimEnter * highlight link  TSConstructor     GruvboxFg0
autocmd VimEnter * highlight link  TSConstBuiltin    GruvboxPurple
autocmd VimEnter * highlight clear Search
autocmd VimEnter * highlight       Search            gui=reverse
autocmd VimEnter * highlight clear IncSearch
autocmd VimEnter * highlight       IncSearch         gui=reverse
autocmd VimEnter * highlight       TSDefinitionUsage guibg=#3c3836
autocmd VimEnter * highlight       TSDefinition      guibg=#3c3836
autocmd VimEnter * highlight       TSVariableBuiltin ctermfg=229 guifg=#fbf1c7 cterm=bold,italic gui=bold,italic

" lsp diagnostics
sign define LspDiagnosticsSignError text= texthl= linehl= numhl=GruvboxRedBold
sign define LspDiagnosticsSignWarning text= texthl= linehl= numhl=GruvboxYellowBold
sign define LspDiagnosticsSignInformation text= texthl= linehl= numhl=GruvboxBlueBold
sign define LspDiagnosticsSignHint text= texthl= linehl= numhl=GruvboxPurpleBold
