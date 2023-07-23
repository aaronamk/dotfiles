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
  use 'neovim/nvim-lspconfig'     -- lsp configurations for servers
  use 'hrsh7th/nvim-cmp'          -- completion helper
  use 'hrsh7th/cmp-nvim-lsp'      -- LSP completion
  use 'hrsh7th/cmp-path'          -- path completion
  use 'hrsh7th/cmp-nvim-lua'      -- internal lua completion
  use 'L3MON4D3/LuaSnip'          -- snippets
  use 'saadparwaiz1/cmp_luasnip'  -- snippets cmp integration
  use 'smjonas/inc-rename.nvim'   -- preview changes when renaming lsp symbols
  use 'windwp/nvim-autopairs'     -- delimiter auto pairing
  use { 'vijaymarupudi/nvim-fzf', -- fzf
        requires = { 'ibhagwan/fzf-lua' } }

  -- git
  use 'tpope/vim-fugitive'      -- git commands
  use 'lewis6991/gitsigns.nvim' -- git change indicators

  -- other
  use 'wbthomason/packer.nvim'      -- plugin manager
  use 'lewis6991/impatient.nvim'    -- uses caching to speed up startup time
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
                              ["ic"] = "@class.inner" },
    },
    move = {
      enable = true,
      set_jumps = false,
      goto_next_start     = { ["]B"] = "@block.outer",
                              ["]a"] = "@parameter.outer",
                              ["]f"] = "@function.outer",
                              ["]]"] = "@call.outer" },
      goto_next_end       = { ["]A"] = "@parameter.outer",
                              ["]F"] = "@function.outer",
                              ["]["] = "@call.outer" },
      goto_previous_start = { ["[B"] = "@block.outer",
                              ["[a"] = "@parameter.outer",
                              ["[f"] = "@function.outer",
                              ["[["] = "@call.outer" },
      goto_previous_end   = { ["[A"] = "@parameter.outer",
                              ["[F"] = "@function.outer",
                              ["[]"] = "@call.outer" },
    },
  },
  refactor = {
    highlight_definitions = { enable = true, clear_on_cursor_move = false },
    navigation = { enable = true, keymaps   = { goto_definition_lsp_fallback = "gd",
                                                goto_next_usage              = "]r",
                                                goto_previous_usage          = "[r" } }
  },
}


-- lsp
local servers = { 'clangd', 'pyright', 'bashls', 'lua_ls' }

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
for _, lsp in ipairs(servers) do
  require('lspconfig')[lsp].setup { capabilities = capabilities }
end

vim.diagnostic.config({ virtual_text = { prefix = '•' }, severity_sort = true })


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


-- inc-rename
require('inc_rename').setup()
vim.keymap.set("n", "cd", function()
  return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true })


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
    add          = { hl = 'DiffAdd',    text = ' ▎' },
    change       = { hl = 'DiffChange', text = '▪ ' },
    changedelete = { hl = 'DiffChange', text = '▪▁' },
    delete       = { hl = 'DiffDelete', text = ' ▁' },
    topdelete    = { hl = 'DiffDelete', text = ' ▔' },
    untracked    = { hl = 'DiffAdd',    text = '┆ ' },
  },
  signcolumn = true,
  numhl = false,
  linehl = false,
  watch_gitdir = { interval = 1000, follow_files = true },
  current_line_blame = true,
  current_line_blame_opts = { delay = 50, position = 'eol' },
  sign_priority = 6,
  update_debounce = 50,
  on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']h', function()
        if vim.wo.diff then return ']h' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end, {expr=true})

      map('n', '[h', function()
        if vim.wo.diff then return '[h' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end, {expr=true})

      -- Actions
      map('n', 'zh', gs.reset_hunk)
      map('v', 'zh', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
      map('n', 'zH', gs.reset_buffer)
      map('n', 'gh', gs.preview_hunk)

      -- Text object
      map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end
}


-- nvim_comment
require('Comment').setup()

-- impatient
require('impatient')

-- fzf-lua
require('fzf-lua').setup { previewers = { builtin = { delay = 0 } } }


-- lualine
require'lualine'.setup {
  options = {theme = 'gruvbox', section_separators = '', component_separators = ''},
  sections = {
    lualine_a = {{'filename', file_status = true, path = 1}},
    lualine_b = {'progress'},
    lualine_c = {{'diagnostics', sources = {'nvim_diagnostic'}, symbols = {error = '✖ ', warn = '! ', info = 'i ', hint = 'h '}}},
    lualine_x = {}, lualine_y = {},
    lualine_z = {'branch'}
    }
}


-- nvim-colorizer
vim.cmd("set termguicolors")
require('colorizer').setup({'*'}, { names = false; })


-- resize neovim properly
vim.api.nvim_create_autocmd({"VimEnter"}, {
  callback = function()
    local pid, WINCH = vim.fn.getpid(), vim.loop.constants.SIGWINCH
    vim.defer_fn(function() vim.loop.kill(pid, WINCH) end, 20)
  end
})


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
  green        = "#98971a",
  green_bold   = "#b8bb26",
  yellow       = "#d79921",
  yellow_bold  = "#fabd2f",
  blue         = "#458588",
  blue_bold    = "#83a598",
  purple       = "#b16286",
  purple_bold  = "#d3869b",
  aqua         = "#689d6a",
  aqua_bold    = "#8ec07c",
  orange       = "#d65d0e",
  orange_bold  = "#fe8019",
}
local ansi = {
  none         = "NONE",
  bg           = 234,
  bg0          = 0,
  bg1          = 236,
  bg2          = 238,
  bg3          = 240,
  bg4          = 242,
  fg           = 15,
  fg0          = 254,
  fg1          = 15,
  fg2          = 15,
  fg3          = 248,
  fg4          = 246,
  gray         = 7,
  red          = 1,
  red_bold     = 9,
  green        = 2,
  green_bold   = 10,
  yellow       = 3,
  yellow_bold  = 11,
  blue         = 4,
  blue_bold    = 12,
  purple       = 5,
  purple_bold  = 13,
  aqua         = 6,
  aqua_bold    = 14,
  orange       = 202,
  orange_bold  = 208,
}

-- editor highlighing
vim.api.nvim_set_hl(0, 'Normal',       { fg=colors.fg, bg=colors.bg, ctermfg=ansi.fg, ctermbg=ansi.bg})
vim.api.nvim_set_hl(0, 'Visual',       { bg=colors.bg2,  ctermbg=ansi.bg2 })
vim.api.nvim_set_hl(0, 'VisualNC',     { bg=colors.bg2,  ctermbg=ansi.bg2 })
vim.api.nvim_set_hl(0, 'Cursor',       { bg=fg })
vim.api.nvim_set_hl(0, 'CursorLine',   { bg=colors.bg0,  ctermbg=ansi.bg0 })
vim.api.nvim_set_hl(0, 'CursorLineNR', { bg=colors.bg0,  ctermbg=ansi.bg0, bold=true })
vim.api.nvim_set_hl(0, 'TabLine',      { bg=colors.bg1, ctermbg=ansi.bg1 })
vim.api.nvim_set_hl(0, 'TabLineSel',   { fg=colors.bg, bg=colors.fg, ctermfg=ansi.bg, ctermbg=ansi.fg, bold = true })
vim.api.nvim_set_hl(0, 'TabLineFill',  { bg=colors.bg1, ctermbg=ansi.bg1 })
vim.api.nvim_set_hl(0, 'Whitespace',   { fg=colors.bg2,  ctermbg=ansi.bg2 })
vim.api.nvim_set_hl(0, 'ColorColumn',  { bg=colors.bg0,  ctermbg=ansi.bg0 })
vim.api.nvim_set_hl(0, 'LineNR',       { fg=colors.gray, ctermfg=ansi.gray })
vim.api.nvim_set_hl(0, 'Title',        { fg=colors.green_bold, ctermfg=ansi.green_bold })
vim.api.nvim_set_hl(0, 'Search',       { bg=colors.bg2,  ctermbg=ansi.bg2 })
vim.api.nvim_set_hl(0, 'IncSearch',    { bg=colors.bg2,  ctermbg=ansi.bg2 })
vim.api.nvim_set_hl(0, 'Pmenu',        { bg=colors.bg1,  ctermbg=ansi.bg1 })
vim.api.nvim_set_hl(0, 'PmenuSel',     { bg=colors.bg2,  ctermbg=ansi.bg2 })
vim.api.nvim_set_hl(0, 'PmenuSbar',    { bg=colors.bg1,  ctermbg=ansi.bg1 })
vim.api.nvim_set_hl(0, 'PmenuThumb',   { bg=colors.fg,   ctermbg=ansi.fg })
vim.api.nvim_set_hl(0, 'Folded',       { fg=colors.gray, ctermfg=ansi.gray })
vim.api.nvim_set_hl(0, 'SpellBad',     { sp=colors.red_bold,    undercurl=true })
vim.api.nvim_set_hl(0, 'SpellCap',     { sp=colors.yellow_bold, undercurl=true })
vim.api.nvim_set_hl(0, 'SignColumn',   {})
vim.api.nvim_set_hl(0, 'WinSeparator', {}) -- removes ugly split divider


-- lualine highlights
vim.api.nvim_set_hl(0, 'lualine_c_normal',   { bg=colors.bg1, ctermbg=ansi.bg1 })
vim.api.nvim_set_hl(0, 'lualine_c_insert',   { bg=colors.bg1, ctermbg=ansi.bg1 })
vim.api.nvim_set_hl(0, 'lualine_c_visual',   { bg=colors.bg1, ctermbg=ansi.bg1 })
vim.api.nvim_set_hl(0, 'lualine_c_replace',  { bg=colors.bg1, ctermbg=ansi.bg1 })
vim.api.nvim_set_hl(0, 'lualine_c_command',  { bg=colors.bg1, ctermbg=ansi.bg1 })
vim.api.nvim_set_hl(0, 'lualine_a_command',  { fg=colors.bg, bg=colors.fg4, ctermfg=ansi.bg, ctermbg=ansi.fg4, bold=true })
vim.api.nvim_set_hl(0, 'lualine_c_inactive', { bg=colors.bg1, ctermbg=ansi.bg1 })


-- syntax highlighting
vim.api.nvim_set_hl(0, 'Comment',           { fg=colors.gray, ctermfg=ansi.gray, italic=true })
vim.api.nvim_set_hl(0, '@text.note',        { fg=colors.fg2,  ctermfg=ansi.fg2, bold=true })
vim.api.nvim_set_hl(0, '@text.warning',     { fg=colors.fg2,  ctermfg=ansi.fg2, bold=true })
vim.api.nvim_set_hl(0, 'Todo',              { fg=colors.fg2,  ctermfg=ansi.fg2, bold=true, italic=true })

vim.api.nvim_set_hl(0, 'Constant',          { fg=colors.purple_bold, ctermfg=ansi.purple_bold })
vim.api.nvim_set_hl(0, 'String',            { fg=colors.green_bold,  ctermfg=ansi.green_bold })
vim.api.nvim_set_hl(0, 'SpecialChar',       { fg=colors.purple_bold, ctermfg=ansi.purple_bold })
vim.api.nvim_set_hl(0, '@constant.builtin', { fg=colors.purple_bold, ctermfg=ansi.purple_bold, bold=true })

vim.api.nvim_set_hl(0, 'Identifier',        { fg=colors.fg, ctermfg=ansi.fg })
vim.api.nvim_set_hl(0, '@variable',         { fg=colors.fg, ctermfg=ansi.fg })
vim.api.nvim_set_hl(0, '@property',         { italic=true })
vim.api.nvim_set_hl(0, '@field',            { italic=true })
vim.api.nvim_set_hl(0, '@variable.builtin', { bold=true })
vim.api.nvim_set_hl(0, '@definition',       { bg=colors.bg1,       ctermbg=ansi.bg1 })
vim.api.nvim_set_hl(0, '@definition.usage', { bg=colors.bg1,       ctermbg=ansi.bg1 })
vim.api.nvim_set_hl(0, '@namespace',        { fg=colors.aqua_bold, ctermfg=ansi.aqua_bold })

vim.api.nvim_set_hl(0, 'Function',          { fg=colors.blue_bold, ctermfg=ansi.blue_bold })
vim.api.nvim_set_hl(0, '@constructor',      { fg=colors.blue_bold, ctermfg=ansi.blue_bold, bold=true, italic=true })
vim.api.nvim_set_hl(0, '@method',           { fg=colors.blue_bold, ctermfg=ansi.blue_bold, italic=true })
vim.api.nvim_set_hl(0, '@function.builtin', { fg=colors.blue_bold, ctermfg=ansi.blue_bold, bold=true })
vim.api.nvim_set_hl(0, '@function.macro',   { fg=colors.blue_bold, ctermfg=ansi.blue_bold })

vim.api.nvim_set_hl(0, 'Statement',         { fg=colors.red_bold,    ctermfg=ansi.red_bold })
vim.api.nvim_set_hl(0, 'Operator',          { fg=colors.orange_bold, ctermfg=ansi.orange_bold })
vim.api.nvim_set_hl(0, 'Exception',         { fg=colors.red,         ctermfg=ansi.red })

vim.api.nvim_set_hl(0, 'PreProc',           { fg=colors.red_bold,  ctermfg=ansi.red_bold })
vim.api.nvim_set_hl(0, 'Include',           { fg=colors.aqua_bold, ctermfg=ansi.aqua_bold })

vim.api.nvim_set_hl(0, 'Type',              { fg=colors.yellow_bold, ctermfg=ansi.yellow_bold })
vim.api.nvim_set_hl(0, '@type.builtin',     { fg=colors.yellow_bold, ctermfg=ansi.yellow_bold, bold=true })

vim.api.nvim_set_hl(0, 'Delimiter',         { fg=colors.fg,  ctermfg=ansi.fg })
vim.api.nvim_set_hl(0, 'MatchParen',        { bg=colors.bg2, ctermbg=ansi.bg2 })

vim.api.nvim_set_hl(0, 'MarkdownURL',       { fg=colors.blue_bold, ctermfg=ansi.blue_bold, underline=true })
vim.api.nvim_set_hl(0, 'MarkdownLinkText',  { fg=colors.blue_bold,  ctermfg=ansi.blue_bold })
vim.api.nvim_set_hl(0, 'MarkdownCode',      { fg=colors.fg,        ctermfg=ansi.fg, bold=true })

-- linting
vim.api.nvim_set_hl(0, 'DiagnosticError',          { fg=colors.red,         ctermfg=ansi.red,    bold=true })
vim.api.nvim_set_hl(0, 'DiagnosticWarn',           { fg=colors.yellow,      ctermfg=ansi.yellow, bold=true })
vim.api.nvim_set_hl(0, 'DiagnosticInfo',           { fg=colors.blue,        ctermfg=ansi.blue,   bold=true })
vim.api.nvim_set_hl(0, 'DiagnosticHint',           { fg=colors.purple,      ctermfg=ansi.purple, bold=true })
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineError', { sp=colors.red_bold,    undercurl=true })
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineWarn',  { sp=colors.yellow_bold, undercurl=true })
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineInfo',  { sp=colors.blue_bold,   undercurl=true })
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineHint',  { sp=colors.purple_bold, undercurl=true })

-- git
vim.api.nvim_set_hl(0, 'DiffAdd',                  { fg=colors.green_bold,  ctermfg=ansi.green_bold })
vim.api.nvim_set_hl(0, 'DiffChange',               { fg=colors.orange_bold, ctermfg=ansi.orange_bold })
vim.api.nvim_set_hl(0, 'DiffDelete',               { fg=colors.red_bold,    ctermfg=ansi.red_bold })
vim.api.nvim_set_hl(0, 'DiffAdded',                { fg=colors.green_bold,  ctermfg=ansi.green_bold })
vim.api.nvim_set_hl(0, 'DiffRemoved',              { fg=colors.red_bold,    ctermfg=ansi.red_bold })
vim.api.nvim_set_hl(0, 'GitSignsDeleteLn',         { fg=colors.red_bold,    ctermfg=ansi.red_bold })
vim.api.nvim_set_hl(0, 'GitSignsCurrentLineBlame', { fg=colors.bg3,         ctermfg=ansi.bg3 })
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

" just highlight the number
sign define DiagnosticSignError numhl=DiagnosticError
sign define DiagnosticSignWarn  numhl=DiagnosticWarn
sign define DiagnosticSignInfo  numhl=DiagnosticInfo
sign define DiagnosticSignHint  numhl=DiagnosticHint


" general
" ---------------------------------------------------------------------------------------------------------------------
set shortmess+=A " avoid swap file warnings
set hidden " enable switching buffers without save
set updatetime=50
set diffopt=internal,algorithm:minimal " generate minimal git diffs
set undofile " save undo history
set title " set window title
set mouse=a " enable mouse
set jumpoptions=view " restore view position on jumps
let g:c_syntax_for_h = 1 " .h files are C, not C++

" update file when changed somewhere else
set autoread
autocmd FocusGained * :checktime

" auto compile latex files
autocmd BufWritePost *.tex silent !pdflatex -output-directory=%:p:h:S %:p:S

" save cursor position and folds
autocmd BufWinLeave *.* silent! mkview
autocmd BufWinEnter *.* silent! loadview
set viewoptions=cursor,folds

" detect file type
autocmd VimEnter * if &filetype == "" | setlocal ft=text | endif
filetype plugin indent on

" scrolling
set scrolloff=10
set scroll=10
autocmd VimResized * :silent! set scroll=10
autocmd WinEnter * :silent! set scroll=10

" whitespace
set tabstop=4
set shiftwidth=4
set list
set listchars=tab:>-,trail:·

" file completion
set path+=**
set wildmenu
set wildmode=longest,list,full
set wildoptions=pum
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
nnoremap <Leader>? :%s//g<Left><Left>
vnoremap <Leader>? "fy:%s//g<Left><Left><c-r>f/

" screen split hotkeys
set splitbelow splitright
nnoremap <Leader>j <c-w>w
nnoremap <Leader>k <c-w>W
nnoremap <Leader>h :bp<CR>
nnoremap <Leader>l :bn<CR>

" tabs
nnoremap <Leader>t :tabnew<CR>
nnoremap <Leader>. gt
nnoremap <Leader>, gT

" clear search
nnoremap <Esc> :noh<CR>

" switch between header and source
nnoremap <Leader><Tab> :ClangdSwitchSourceHeader<CR>

" fzf
nnoremap <Leader>/ :FzfLua files<CR>
nnoremap z= :FzfLua spell_suggest<CR>
nnoremap g/ :FzfLua builtin<CR>

" lsp
nnoremap <silent> K  <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gl <cmd>lua vim.diagnostic.open_float(0, {scope="line"})<CR>
nnoremap <silent> zl <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> ]l <cmd>lua vim.diagnostic.goto_next()<CR>
nnoremap <silent> [l <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <Leader>f <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> gr :FzfLua lsp_references<CR>

cnoremap <expr> <Tab>   getcmdtype() =~ '[?/]' ? "<c-g>" : "<c-z>"
cnoremap <expr> <S-Tab> getcmdtype() =~ '[?/]' ? "<c-t>" : "<S-Tab>"

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
" turn of truecolor if not supported
autocmd VimEnter * if $COLORTERM != "truecolor" | set notermguicolors | endif
