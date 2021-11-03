" Vim config file
" Author: aaronamk

" Plugin settings
" ------------------------------------------------------------------------------
lua <<EOF
require('packer').startup(function()
-- Packer can manage itself
use 'wbthomason/packer.nvim'

-- streamlined editing
--------------------------------------------------------------------------------
-- smart syntax parser
use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
use 'nvim-treesitter/nvim-treesitter-textobjects' -- treesitter text objects
use 'nvim-treesitter/nvim-treesitter-refactor'    -- highlight references
use 'nvim-treesitter/playground'                  -- treesitter info
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
use 'tjdevries/colorbuddy.nvim'
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
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
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


-- autopairs
require('nvim-autopairs').setup({
  check_ts = true,
})
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))

local Rule = require'nvim-autopairs.rule'
require'nvim-autopairs'.add_rules {
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
    add          = {hl = 'GitSignsAdd',    text = ' ▎', numhl='', linehl=''},
    change       = {hl = 'GitSignsChange', text = '▪ ', numhl='', linehl=''},
    changedelete = {hl = 'GitSignsChange', text = '▪▁', numhl='', linehl=''},
    delete       = {hl = 'GitSignsDelete', text = ' ▁', numhl='', linehl=''},
    topdelete    = {hl = 'GitSignsDelete', text = ' ▔', numhl='', linehl=''},
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


-- colorbuddy (gruvbox dark)
require('colorbuddy').setup()
local Color, c, Group, g, styles = require('colorbuddy').setup()
Color.new('bg',           "#1d2021")
Color.new('bg0',          "#282828")
Color.new('bg1',          "#3c3836")
Color.new('bg2',          "#504945")
Color.new('bg3',          "#665c54")
Color.new('bg4',          "#7c6f64")
Color.new('fg',           "#ebdbb2")
Color.new('fg0',          "#fbf1c7")
Color.new('fg1',          "#ebdbb2")
Color.new('fg2',          "#d5c4a1")
Color.new('fg3',          "#bdae93")
Color.new('fg4',          "#a89984")
Color.new('gray',         "#928374")
Color.new('red',          "#cc241d")
Color.new('red_bold',     "#fb4934")
Color.new('orange',       "#d65d0e")
Color.new('orange_bold',  "#fe8019")
Color.new('yellow',       "#d79921")
Color.new('yellow_bold',  "#fabd2f")
Color.new('green',        "#98971a")
Color.new('green_bold',   "#b8bb26")
Color.new('aqua',         "#689d6a")
Color.new('aqua_bold',    "#8ec07c")
Color.new('blue',         "#458588")
Color.new('blue_bold',    "#83a598")
Color.new('purple',       "#b16286")
Color.new('purple_bold',  "#d3869b")

-- editor
Group.new('Normal',            c.fg,          c.bg)
Group.new('SpellBad',          c.none,        c.none, styles.underline)
Group.new('Visual',            c.none,        c.none, styles.reverse)
Group.new('VisualNC',          c.none,        c.none, styles.reverse)
Group.new('Cursor',            c.none,        c.none, styles.reverse)
Group.new('CursorLine',        c.none,        c.bg0)
Group.new('Whitespace',        c.bg2,         c.none)
Group.new('ColorColumn',       c.none,        c.bg0)
Group.new('SignColumn',        c.none,        c.none)
Group.new('LineNR',            c.gray,        c.none)
Group.new('CursorLineNR',      c.fg,          c.bg0)
Group.new('MatchParen',        c.none,        c.bg2)
Group.new('IncSearch',         c.none,        c.none, styles.reverse)
Group.new('Search',            c.none,        c.none, styles.reverse)
Group.new('Pmenu',             c.none,        c.bg1)
Group.new('PmenuSel',          c.none,        c.none, styles.reverse)

-- code highlighting
Group.new('Comment',           c.gray,        c.none, styles.italic)
Group.new('commentTSConstant', c.fg2,         c.none, styles.bold + styles.italic)
Group.new('commentTSWarning',  c.fg2,         c.none, styles.bold + styles.italic)
Group.new('Todo',              c.fg2,         c.none, styles.bold + styles.italic)
Group.new('Title',             c.green_bold,  c.none)
Group.new('MarkdownURL',       c.blue_bold,   c.none, styles.underline)
Group.new('MarkdownLinkText',  c.blue_bold,   c.none)
Group.new('MarkdownCode',      c.fg,          c.none, styles.bold)
Group.new('Preproc',           c.aqua_bold,   c.none)
Group.new('Include',           c.aqua_bold,   c.none)

Group.new('Delimiter',         c.fg,          c.none)
Group.new('TSConstructor',     c.fg,          c.none)
Group.new('Identifier',        c.fg,          c.none)
Group.new('Operator',          c.orange_bold, c.none)
Group.new('Keyword',           c.red_bold,    c.none)
Group.new('Statement',         c.red_bold,    c.none)
Group.new('Conditional',       c.red_bold,    c.none)
Group.new('Repeat',            c.red_bold,    c.none) -- loops
Group.new('Label',             c.red_bold,    c.none)

Group.new('Type',              c.yellow_bold, c.none)
Group.new('TSTypeBuiltin',     c.yellow_bold, c.none, styles.bold + styles.italic)
Group.new('Constant',          c.purple_bold, c.none)
Group.new('TSConstBuiltin',    c.purple_bold, c.none, styles.bold + styles.italic)
Group.new('Boolean',           c.purple_bold, c.none)
Group.new('Number',            c.purple_bold, c.none)
Group.new('Character',         c.purple_bold, c.none)
Group.new('String',            c.green_bold,  c.none)
Group.new('TSStringEscape',    c.purple_bold, c.none)
Group.new('TSVariable',        c.fg,          c.none)
Group.new('TSParameter',       c.fg,          c.none)
Group.new('TSProperty',        c.fg,          c.none)
Group.new('TSVariableBuiltin', c.fg,          c.none, styles.bold + styles.italic)
Group.new('Function',          c.blue_bold,   c.none)
Group.new('TSFuncBuiltin',     c.blue_bold,   c.none, styles.bold + styles.italic)
Group.new('TSFuncMacro',       c.blue_bold,   c.none)
Group.new('Exception',         c.red,         c.none)
Group.new('TSDefinition',      c.none,        c.bg1)
Group.new('TSDefinitionUsage', c.none,        c.bg1)

-- plugins
Group.new('GitSignsCurrentLineBlame', g.Whitespace)
Group.new('GitSignsAdd',              c.green_bold)
Group.new('GitSignsChange',           c.orange_bold)
Group.new('GitSignsDelete',           c.orange_bold)
Group.new('LintError',                c.red_bold)
Group.new('LintWarning',              c.yellow_bold)
Group.new('LintInfo',                 c.blue_bold)
Group.new('LintHint',                 c.purple_bold)
EOF
hi Normal guibg=#1d2021

" latex
let g:vimtex_view_general_viewer = 'omni-open.sh'


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

" lsp diagnostics
sign define LspDiagnosticsSignError text= texthl= linehl= numhl=LintError
sign define LspDiagnosticsSignWarning text= texthl= linehl= numhl=LintWarning
sign define LspDiagnosticsSignInformation text= texthl= linehl= numhl=LintInfo
sign define LspDiagnosticsSignHint text= texthl= linehl= numhl=LintHint
