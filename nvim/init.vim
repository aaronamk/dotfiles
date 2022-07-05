" Neovim config file
" Author: aaronamk
" Dependencies: git (a decently modern version), fzf, packer.nvim, tree-sitter, LSP clients (clang, jedi, etc.)
" run :PackerSync to install/update all plugins

lua <<EOF
-- plugins
-----------------------------------------------------------------------------------------------------------------------
require('packer').startup(function()
  -- treesitter
  use 'nvim-treesitter/nvim-treesitter'             -- smart syntax parser
  use 'nvim-treesitter/nvim-treesitter-textobjects' -- treesitter text objects
  use 'nvim-treesitter/nvim-treesitter-refactor'    -- highlight references
  use 'nvim-treesitter/playground'                  -- treesitter info

  -- completion
  use 'neovim/nvim-lspconfig'    -- lsp configurations for servers
  use 'hrsh7th/nvim-cmp'         -- completion helper
  use 'hrsh7th/cmp-nvim-lsp'     -- LSP completion
  use 'hrsh7th/cmp-path'         -- path completion
  use 'hrsh7th/cmp-nvim-lua'     -- internal lua completion
  use 'L3MON4D3/LuaSnip'         -- snippets
  use 'saadparwaiz1/cmp_luasnip' -- snippets cmp integration
  use 'windwp/nvim-autopairs'    -- delimiter auto pairing
  use { 'vijaymarupudi/nvim-fzf', requires = { 'ibhagwan/fzf-lua' } } -- fzf

  -- git
  use 'tpope/vim-fugitive'      -- git commands
  use 'lewis6991/gitsigns.nvim' -- git change indicators

  -- other
  use 'wbthomason/packer.nvim'      -- plugin manager
  use 'Chiel92/vim-autoformat'      -- code formatter
  use 'norcalli/nvim-colorizer.lua' -- highlight colors in that color
  use 'wellle/targets.vim'          -- smarter text objects
  use 'machakann/vim-sandwich'      -- delimiter bindings
  use 'numToStr/Comment.nvim'       -- commenting bindings
  use 'nvim-lualine/lualine.nvim'   -- status line
end)


-- treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",
  ignore_install = { "phpdoc" },
  highlight = {enable = true},
  context_commentstring = {enable = true},
  autopairs = {enable = true},
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatic jumps like in targets.vim
      keymaps             = { ["aB"] = "@block.outer",
                              ["iB"] = "@block.inner",
                              ["aa"] = "@parameter.outer",
                              ["ia"] = "@parameter.inner",
                              ["af"] = "@function.outer",
                              ["if"] = "@function.inner",
                              ["ac"] = "@class.outer",
                              ["ic"] = "@class.inner", },
    },
    move = {
      enable = true,
      set_jumps = false,
      goto_next_start     = { ["]B"] = "@block.outer",
                              ["]a"] = "@parameter.outer",
                              ["]f"] = "@function.outer",
                              ["]]"] = "@call.outer", },
      goto_next_end       = { ["]A"] = "@parameter.outer",
                              ["]F"] = "@function.outer",
                              ["]["] = "@call.outer", },
      goto_previous_start = { ["[B"] = "@block.outer",
                              ["[a"] = "@parameter.outer",
                              ["[f"] = "@function.outer",
                              ["[["] = "@call.outer", },
      goto_previous_end   = { ["[A"] = "@parameter.outer",
                              ["[F"] = "@function.outer",
                              ["[]"] = "@call.outer", },
    },
  },
  refactor = {
    highlight_definitions = { enable = true, clear_on_cursor_move = false },
    navigation = { enable = true, keymaps   = { goto_definition_lsp_fallback = "gd",
                                                goto_next_usage              = "]r",
                                                goto_previous_usage          = "[r" } },
    smart_rename = { enable = true, keymaps = { smart_rename                 = "cd" } }
  },
}


-- lsp
local servers = { 'clangd', 'jedi_language_server', 'bashls' }

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
for _, lsp in ipairs(servers) do
  require('lspconfig')[lsp].setup { capabilities = capabilities }
end

vim.diagnostic.config({virtual_text = {prefix = '•'}, severity_sort = true})


-- luasnip
local luasnip = require("luasnip")
luasnip.config.set_config{
  history = true,
  updateevents = "TextChanged,TextChangedI",
  enable_autosnippets = true
}


-- nvim-cmp
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp = require("cmp")
cmp.setup {
  completion = { autocomplete = false, completeopt = 'menu,noinsert' },
  sources = { { name = "luasnip" }, { name = "nvim_lsp" }, { name = "nvim_lua" }, { name = "path" } },
  snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
  experimental = { ghost_text = true },
  mapping = {
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_next_item()
      elseif has_words_before() then cmp.complete()
      else fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_prev_item() else fallback() end
    end, { "i", "s" }),
    ["<Esc>"] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.abort() else fallback() end
    end, { "i", "s" }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ["<C-k>"] = cmp.mapping(function() luasnip.jump() end, { "i", "s" }),
    ["<C-j>"] = cmp.mapping(function() luasnip.jump(-1) end, { "i", "s" }),
  }
}


-- autopairs
local npairs = require'nvim-autopairs'
npairs.setup({ check_ts = true })

npairs.add_rules {
  require'nvim-autopairs.rule'(' ', ' ')
    :with_pair(function (opts)
      return vim.tbl_contains({ '()', '[]', '{}' }, opts.line:sub(opts.col - 1, opts.col))
    end),
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
  watch_gitdir = { interval = 1000, follow_files = true
  },
  current_line_blame = true,
  current_line_blame_opts = { delay = 50, position = 'eol' },
  sign_priority = 6,
  update_debounce = 50,
  status_formatter = nil, -- Use default
  word_diff = false,
  diff_opts = { internal = true }, -- If luajit is present

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


-- nvim_comment
require('Comment').setup()


-- fzf-lua
require('fzf-lua').setup { previewers = { builtin = { delay = 0, }, }, }


-- lualine
require'lualine'.setup {
  options = {theme = 'gruvbox', section_separators = '', component_separators = ''},
  sections = {
    lualine_a = {{'filename', file_status = true, path = 1}},
    lualine_b = {'progress'},
    lualine_c = {{'diagnostics', sources = {'nvim_diagnostic'}, symbols = {error = '❌', warn = '!', info = 'i', hint = 'h'}}},
    lualine_x = {}, lualine_y = {},
    lualine_z = {'branch'}
    }
}


-- nvim-colorizer
vim.cmd("set termguicolors")
require('colorizer').setup({'*'}, { names = false; })


-- appearance
-----------------------------------------------------------------------------------------------------------------------
-- gruvbox dark
local colors = {
  none         = "NONE",
  bg           = "#1d2021",
  bg0          = "#282828",
  bg1          = "#3c3836",
  bg2          = "#504945",
  bg3          = "#665c54",
  bg4          = "#7c6f64",
  fg           = "#ebdbb2",
  fg0          = "#fbf1c7",
  fg1          = "#ebdbb2",
  fg2          = "#d5c4a1",
  fg3          = "#bdae93",
  fg4          = "#a89984",
  gray         = "#928374",
  red          = "#cc241d",
  red_bold     = "#fb4934",
  orange       = "#d65d0e",
  orange_bold  = "#fe8019",
  yellow       = "#d79921",
  yellow_bold  = "#fabd2f",
  green        = "#98971a",
  green_bold   = "#b8bb26",
  aqua         = "#689d6a",
  aqua_bold    = "#8ec07c",
  blue         = "#458588",
  blue_bold    = "#83a598",
  purple       = "#b16286",
  purple_bold  = "#d3869b",
}

-- editor highlighing
vim.api.nvim_set_hl(0, 'Normal',       { fg = colors.fg,   bg = colors.bg })
vim.api.nvim_set_hl(0, 'Visual',       { fg = colors.none, bg = colors.bg2 })
vim.api.nvim_set_hl(0, 'VisualNC',     { fg = colors.none, bg = colors.bg2 })
vim.api.nvim_set_hl(0, 'Cursor',       { fg = colors.none, bg = colors.none, reverse = true })
vim.api.nvim_set_hl(0, 'CursorLine',   { fg = colors.none, bg = colors.bg0 })
vim.api.nvim_set_hl(0, 'Whitespace',   { fg = colors.bg2,  bg = colors.none })
vim.api.nvim_set_hl(0, 'ColorColumn',  { fg = colors.none, bg = colors.bg0 })
vim.api.nvim_set_hl(0, 'SignColumn',   { fg = colors.none, bg = colors.none })
vim.api.nvim_set_hl(0, 'LineNR',       { fg = colors.gray, bg = colors.none })
vim.api.nvim_set_hl(0, 'CursorLineNR', { fg = colors.fg,   bg = colors.bg0 })
vim.api.nvim_set_hl(0, 'MatchParen',   { fg = colors.none, bg = colors.bg2 })
vim.api.nvim_set_hl(0, 'IncSearch',    { fg = colors.none, bg = colors.bg2 })
vim.api.nvim_set_hl(0, 'Search',       { fg = colors.none, bg = colors.bg2 })
vim.api.nvim_set_hl(0, 'Pmenu',        { fg = colors.none, bg = colors.bg1 })
vim.api.nvim_set_hl(0, 'PmenuSel',     { fg = colors.none, bg = colors.none, reverse = true })
vim.api.nvim_set_hl(0, 'Folded',       { fg = colors.gray, bg = colors.none })
vim.api.nvim_set_hl(0, 'SpellBad',     { sp = colors.red_bold })
vim.api.nvim_set_hl(0, 'SpellCap',     { sp = colors.yellow_bold })
vim.api.nvim_set_hl(0, 'WinSeparator', {}) -- removes ugly split divider

-- code highlighting
vim.api.nvim_set_hl(0, 'Comment',           { fg = colors.gray, italic = true })
vim.api.nvim_set_hl(0, 'commentTSConstant', { fg = colors.fg2, bold = true, italic = true })
vim.api.nvim_set_hl(0, 'commentTSWarning',  { fg = colors.fg2, bold = true, italic = true })
vim.api.nvim_set_hl(0, 'Todo',              { fg = colors.fg2, bold = true, italic = true })
vim.api.nvim_set_hl(0, 'Title',             { fg = colors.green_bold, })
vim.api.nvim_set_hl(0, 'MarkdownURL',       { fg = colors.blue_bold, underline = true })
vim.api.nvim_set_hl(0, 'MarkdownLinkText',  { fg = colors.blue_bold, })
vim.api.nvim_set_hl(0, 'MarkdownCode',      { fg = colors.fg, bold = true })
vim.api.nvim_set_hl(0, 'Preproc',           { fg = colors.aqua_bold, })
vim.api.nvim_set_hl(0, 'Include',           { fg = colors.aqua_bold, })
vim.api.nvim_set_hl(0, 'Delimiter',         { fg = colors.fg, })
vim.api.nvim_set_hl(0, 'TSConstructor',     { fg = colors.fg, })
vim.api.nvim_set_hl(0, 'Identifier',        { fg = colors.fg, })
vim.api.nvim_set_hl(0, 'Operator',          { fg = colors.orange_bold, })
vim.api.nvim_set_hl(0, 'Keyword',           { fg = colors.red_bold, })
vim.api.nvim_set_hl(0, 'Statement',         { fg = colors.red_bold, })
vim.api.nvim_set_hl(0, 'Conditional',       { fg = colors.red_bold, })
vim.api.nvim_set_hl(0, 'Repeat',            { fg = colors.red_bold, }) -- loops
vim.api.nvim_set_hl(0, 'Label',             { fg = colors.red_bold, })
vim.api.nvim_set_hl(0, 'Type',              { fg = colors.yellow_bold, })
vim.api.nvim_set_hl(0, 'TSTypeBuiltin',     { fg = colors.yellow_bold, bold = true, italic = true })
vim.api.nvim_set_hl(0, 'Constant',          { fg = colors.purple_bold, })
vim.api.nvim_set_hl(0, 'TSConstBuiltin',    { fg = colors.purple_bold, bold = true, italic = true })
vim.api.nvim_set_hl(0, 'Boolean',           { fg = colors.purple_bold, })
vim.api.nvim_set_hl(0, 'Number',            { fg = colors.purple_bold, })
vim.api.nvim_set_hl(0, 'Character',         { fg = colors.purple_bold, })
vim.api.nvim_set_hl(0, 'String',            { fg = colors.green_bold, })
vim.api.nvim_set_hl(0, 'TSStringEscape',    { fg = colors.purple_bold, })
vim.api.nvim_set_hl(0, 'TSVariable',        { fg = colors.fg, })
vim.api.nvim_set_hl(0, 'TSParameter',       { fg = colors.fg, })
vim.api.nvim_set_hl(0, 'TSProperty',        { fg = colors.fg, })
vim.api.nvim_set_hl(0, 'TSVariableBuiltin', { fg = colors.fg, bold = true, italic = true })
vim.api.nvim_set_hl(0, 'Function',          { fg = colors.blue_bold, })
vim.api.nvim_set_hl(0, 'TSFuncBuiltin',     { fg = colors.blue_bold, bold = true, italic = true })
vim.api.nvim_set_hl(0, 'TSFuncMacro',       { fg = colors.blue_bold, })
vim.api.nvim_set_hl(0, 'Exception',         { fg = colors.red, })
vim.api.nvim_set_hl(0, 'TSDefinition',      { fg = colors.none, bg = colors.bg1 })
vim.api.nvim_set_hl(0, 'TSDefinitionUsage', { fg = colors.none, bg = colors.bg1 })
vim.api.nvim_set_hl(0, 'DiffAdd',           { fg = colors.green_bold })
vim.api.nvim_set_hl(0, 'DiffChange',        { fg = colors.orange_bold })
vim.api.nvim_set_hl(0, 'DiffDelete',        { fg = colors.red_bold })
vim.api.nvim_set_hl(0, 'DiffAdded',         { fg = colors.green_bold })
vim.api.nvim_set_hl(0, 'DiffRemoved',       { fg = colors.red_bold })

-- linting
vim.api.nvim_set_hl(0, 'LintError',                { fg = colors.red_bold })
vim.api.nvim_set_hl(0, 'LintWarning',              { fg = colors.yellow_bold })
vim.api.nvim_set_hl(0, 'LintInfo',                 { fg = colors.blue_bold })
vim.api.nvim_set_hl(0, 'LintHint',                 { fg = colors.purple_bold })
vim.api.nvim_set_hl(0, 'DiagnosticError',          { fg = colors.red,         bold = true })
vim.api.nvim_set_hl(0, 'DiagnosticWarn',           { fg = colors.yellow,      bold = true })
vim.api.nvim_set_hl(0, 'DiagnosticInfo',           { fg = colors.blue,        bold = true })
vim.api.nvim_set_hl(0, 'DiagnosticHint',           { fg = colors.purple,      bold = true })
vim.api.nvim_set_hl(0, 'DiagnosticLineNrError',    { fg = colors.red,         bold = true })
vim.api.nvim_set_hl(0, 'DiagnosticLineNrWarn',     { fg = colors.yellow,      bold = true })
vim.api.nvim_set_hl(0, 'DiagnosticLineNrInfo',     { fg = colors.blue,        bold = true })
vim.api.nvim_set_hl(0, 'DiagnosticLineNrHint',     { fg = colors.purple,      bold = true })
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineError', { sp = colors.red_bold,    undercurl = true })
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineWarn',  { sp = colors.yellow_bold, undercurl = true })
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineInfo',  { sp = colors.blue_bold,   undercurl = true })
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineHint',  { sp = colors.purple_bold, undercurl = true })

-- git
vim.api.nvim_set_hl(0, 'GitSignsCurrentLineBlame', { fg = colors.bg3 })
vim.api.nvim_set_hl(0, 'GitSignsAdd',              { fg = colors.green_bold })
vim.api.nvim_set_hl(0, 'GitSignsChange',           { fg = colors.orange_bold })
vim.api.nvim_set_hl(0, 'GitSignsDelete',           { fg = colors.red_bold })
vim.api.nvim_set_hl(0, 'GitSignsDeleteLn',         { fg = colors.red_bold })
EOF

set number " add line numbers
set fillchars=eob:\ , " remove ~ markers after buffer

set noshowcmd
set noshowmode

" set blinking cursor
:set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
  \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
  \,sm:block-blinkwait175-blinkoff150-blinkon175

" mark 80 character limit
set cc=80,120
" highlight current line
set cursorline

" global statusline
" set laststatus=3

" remove diagnostic sign column symbols
sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=DiagnosticLineNrError
sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=DiagnosticLineNrWarn
sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=DiagnosticLineNrInfo
sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=DiagnosticLineNrHint


" general
" ---------------------------------------------------------------------------------------------------------------------
" fix terminal resizing bug
autocmd VimEnter * :silent exec "!kill -s SIGWINCH $PPID"

" update file when changed somewhere else
set autoread
autocmd FocusGained * :checktime
set shortmess+=A " avoid swap file warnings
set hidden " enable switching buffers without save
set updatetime=50

" save cursor position and folds
autocmd BufWinLeave *.* silent! mkview
autocmd BufWinEnter *.* silent! loadview
set viewoptions=cursor,folds

" save undo history
set undodir=$HOME/.cache/nvim/undodir
set undofile

" set root directory
autocmd BufEnter * :silent! Gcd " Ignores error if not in git repo

" detect file type
autocmd VimEnter * if &filetype == "" | setlocal ft=text | endif
filetype plugin indent on

" scrolling
set scrolloff=10
set scroll=10
autocmd VimResized * :silent! set scroll=10
autocmd WinEnter * :silent! set scroll=10

set title " set window title
set mouse=a " enable mouse
let g:c_syntax_for_h = 1

" whitespace
set tabstop=4
set shiftwidth=4
set expandtab
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
let g:netrw_dirhistmax = 0 " disable hist file


" keybindings
" ---------------------------------------------------------------------------------------------------------------------
" set leader key
noremap <space> <nop>
let mapleader=" "

" Make Y work the way you'd expect
nmap Y y$

" emulate vim surround bindings
runtime macros/sandwich/keymap/surround.vim
let g:sandwich#recipes += [
\ {'buns': ['{ ', ' }'], 'nesting': 1, 'match_syntax': 1, 'kind': ['add', 'replace'], 'action': ['add'], 'input': ['{']},
\ {'buns': ['[ ', ' ]'], 'nesting': 1, 'match_syntax': 1, 'kind': ['add', 'replace'], 'action': ['add'], 'input': ['[']},
\ {'buns': ['( ', ' )'], 'nesting': 1, 'match_syntax': 1, 'kind': ['add', 'replace'], 'action': ['add'], 'input': ['(']},
\ {'buns': ['{\s*', '\s*}'],   'nesting': 1, 'regex': 1, 'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'], 'action': ['delete'], 'input': ['{']},
\ {'buns': ['\[\s*', '\s*\]'], 'nesting': 1, 'regex': 1, 'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'], 'action': ['delete'], 'input': ['[']},
\ {'buns': ['(\s*', '\s*)'],   'nesting': 1, 'regex': 1, 'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'], 'action': ['delete'], 'input': ['(']},
\]
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

" fzf
nnoremap <c-_> :FzfLua files<CR>
nnoremap z= :FzfLua spell_suggest<CR>
nnoremap g/ :FzfLua builtin<CR>

" lsp
nnoremap <silent> K  <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gl <cmd>lua vim.diagnostic.open_float(0, {scope="line"})<CR>
nnoremap <silent> zl <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> ]l <cmd>lua vim.diagnostic.goto_next()<CR>
nnoremap <silent> [l <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap <silent> gt <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> cd <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <Leader>f <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> gr :FzfLua lsp_references<CR>

cnoremap <expr> <Tab>   getcmdtype() =~ '[?/]' ? "<c-g>" : "<c-z>"
cnoremap <expr> <S-Tab> getcmdtype() =~ '[?/]' ? "<c-t>" : "<S-Tab>"

"if (:set modifiable?) == "nomodifiable" | nnoremap <silent> <Esc> :q<CR> | endif
