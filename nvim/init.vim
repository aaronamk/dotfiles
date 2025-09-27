" Neovim config file
" Author: aaronamk
" Dependencies: git (a decently modern version), fzf, lazy.nvim, tree-sitter, LSP clients


lua <<EOF
vim.loader.enable()

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- set leader key
vim.g.mapleader = " "
vim.opt.completeopt = { "menuone", "noselect", "popup" }

vim.cmd("set termguicolors")

vim.diagnostic.config({
  virtual_text = { prefix = '•' },
  severity_sort = true,
  -- just highlight the number
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = ''
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
      [vim.diagnostic.severity.WARN] = 'WarningMsg',
      [vim.diagnostic.severity.INFO] = 'InfoMsg',
      [vim.diagnostic.severity.HINT] = 'HintMsg'
    }
  }
})


-- plugins
-----------------------------------------------------------------------------------------------------------------------
require("lazy").setup({
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    opts = {
      ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "query", "python", "bash", "go", "rust", "javascript", "json", "ini", "toml", "yaml" },
      highlight = {enable = true},
      indent = {enable = true},
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
  },
  {'nvim-treesitter/nvim-treesitter-textobjects'}, -- treesitter text objects
  {'nvim-treesitter/nvim-treesitter-refactor'},    -- highlight references

  -- completion
  {'neovim/nvim-lspconfig'},     -- lsp configurations for servers
  {'saghen/blink.cmp', lazy=true,
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
      },
      'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    opts = {
      keymap = {
        preset = 'none',
        ['<Tab>'] = { 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'fallback' },
        ['<Right>'] = { 'snippet_forward', 'fallback' },
        ['<Left>'] = { 'snippet_backward', 'fallback' },
        ['<Up>'] = { 'scroll_documentation_up', 'fallback' },
        ['<Down>'] = { 'scroll_documentation_down', 'fallback' },
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 0 },
        list = { selection = { preselect = false, auto_insert = true } },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = { lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 }, },
      },
      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'lua' },
      signature = { enabled = true },
      cmdline = {
        keymap = { preset = 'inherit' },
        completion = {
          menu = {auto_show = true},
          list = { selection = { preselect = false, auto_insert = true } },
        },
      },
    },
  },

  {'smjonas/inc-rename.nvim', lazy=true, opts={}},   -- preview changes when renaming lsp symbols
  {'windwp/nvim-autopairs', opts={ check_ts = true }},     -- delimiter auto pairing
  {'nvim-telescope/telescope.nvim', tag = '0.1.8', dependencies = {'nvim-lua/plenary.nvim'}, opts=function()
    local actions = require("telescope.actions")
    return {
      defaults = {
        layout_strategy = "vertical",
        layout_config = { preview_height = 0.75, prompt_position="top", width = 0.9, height = 0.9, mirror = true },
        mappings = {
          i = {
            ["<esc>"] = actions.close,
            ["<Tab>"] = actions.move_selection_next,
            ["<S-Tab>"] = actions.move_selection_previous,
          },
        },
        sorting_strategy = "ascending"
      }
    }
    end,
  },

  -- git
  {'tpope/vim-fugitive', lazy=true},      -- git commands

  {'lewis6991/gitsigns.nvim', opts = {
    signs = {
      add          = { text = ' ▎' },
      change       = { text = '▪ ' },
      changedelete = { text = '▪▁' },
      delete       = { text = ' ▁' },
      topdelete    = { text = ' ▔' },
      untracked    = { text = '┆ ' },
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
    }}, -- git change indicators

    -- other
    {'NMAC427/guess-indent.nvim'}, -- Detect tabstop and shiftwidth automatically
    {'norcalli/nvim-colorizer.lua', opts={'*'}}, -- highlight colors in that color
    {'echasnovski/mini.ai', version = '*', opts={}},
    {'echasnovski/mini.surround', version = '*', opts={
      mappings = {delete='ds', replace='cs'},
      n_lines = 100,
      respect_selection_type = true,
      search_method = 'cover_or_nearest'
    }},
    {'numToStr/Comment.nvim', lazy=true, opts={}},       -- commenting bindings
    {'nvim-lualine/lualine.nvim', opts={
      options = {theme = 'gruvbox', section_separators = '', component_separators = ''},
      sections = {
        lualine_a = {{'filename', file_status = true, path = 1}},
        lualine_b = {'progress'},
        lualine_c = {{'diagnostics', sources = {'nvim_diagnostic'}, symbols = {error = '✖ ', warn = '! ', info = 'i ', hint = 'h '}}},
        lualine_x = {}, lualine_y = {},
        lualine_z = {'branch'}
      }
    }},   -- status line
  checker = { enabled = false }
})


-- lsp
local servers = { 'clangd', 'pyright', 'bashls', 'lua_ls' }

local capabilities = require('blink.cmp').get_lsp_capabilities()
for _, lsp in ipairs(servers) do
  vim.lsp.enable(lsp)
  vim.lsp.config(lsp, { capabilities = capabilities })
end

vim.keymap.set("n", "K",  vim.lsp.buf.hover)
vim.keymap.set("n", "gl", function() vim.diagnostic.open_float(0, {scope="line"}) end)
vim.keymap.set("n", "zl", vim.lsp.buf.code_action)
vim.keymap.set("n", "]l", vim.diagnostic.goto_next)
vim.keymap.set("n", "[l", vim.diagnostic.goto_prev)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gD", vim.lsp.buf.implementation)
vim.keymap.set("n", "gr", require('telescope.builtin').lsp_references)
vim.keymap.set("n", "cd", function() return ":IncRename " .. vim.fn.expand("<cword>") end, { expr = true })


-- autopairs
require'nvim-autopairs'.add_rules {
  require'nvim-autopairs.rule'(' ', ' ')
    :with_pair(function (opts)
      return vim.tbl_contains({ '()', '[]', '{}' }, opts.line:sub(opts.col - 1, opts.col))
    end),
}


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
vim.api.nvim_set_hl(0, 'Comment',              { fg=colors.gray,       ctermfg=ansi.gray, italic=true })
vim.api.nvim_set_hl(0, '@text.title',          { fg=colors.fg0,        ctermfg=ansi.fg0, bold=true })
vim.api.nvim_set_hl(0, '@text.literal',        { fg=colors.fg,        ctermfg=ansi.fg, bold=true })
vim.api.nvim_set_hl(0, '@text.note',           { fg=colors.fg2,        ctermfg=ansi.fg2, bold=true })
vim.api.nvim_set_hl(0, '@text.warning',        { fg=colors.fg2,        ctermfg=ansi.fg2, bold=true })
vim.api.nvim_set_hl(0, '@text.reference',      { fg=colors.blue_bold,  ctermfg=ansi.blue_bold, bold=true })
vim.api.nvim_set_hl(0, '@text.uri',            { fg=colors.blue,       ctermfg=ansi.blue, bold=true })
vim.api.nvim_set_hl(0, 'Todo',                 { fg=colors.fg2,        ctermfg=ansi.fg2, bold=true, italic=true })

vim.api.nvim_set_hl(0, 'Constant',             { fg=colors.purple_bold, ctermfg=ansi.purple_bold })
vim.api.nvim_set_hl(0, 'String',               { fg=colors.green_bold,  ctermfg=ansi.green_bold })
vim.api.nvim_set_hl(0, 'SpecialChar',          { fg=colors.purple_bold, ctermfg=ansi.purple_bold })
vim.api.nvim_set_hl(0, '@constant.builtin',    { fg=colors.purple_bold, ctermfg=ansi.purple_bold, bold=true })

vim.api.nvim_set_hl(0, 'Identifier',           { fg=colors.fg, ctermfg=ansi.fg })
vim.api.nvim_set_hl(0, '@variable',            { fg=colors.fg, ctermfg=ansi.fg })
vim.api.nvim_set_hl(0, '@property',            { italic=true })
vim.api.nvim_set_hl(0, '@field',               { italic=true })
vim.api.nvim_set_hl(0, '@variable.builtin',    { bold=true })
vim.api.nvim_set_hl(0, '@definition',          { bg=colors.bg1,       ctermbg=ansi.bg1 })
vim.api.nvim_set_hl(0, '@definition.usage',    { bg=colors.bg1,       ctermbg=ansi.bg1 })
vim.api.nvim_set_hl(0, '@namespace',           { fg=colors.aqua_bold, ctermfg=ansi.aqua_bold })

vim.api.nvim_set_hl(0, 'Function',             { fg=colors.blue_bold, ctermfg=ansi.blue_bold })
vim.api.nvim_set_hl(0, '@constructor',         { fg=colors.blue_bold, ctermfg=ansi.blue_bold, bold=true, italic=true })
vim.api.nvim_set_hl(0, '@method',              { fg=colors.blue_bold, ctermfg=ansi.blue_bold, italic=true })
vim.api.nvim_set_hl(0, '@function.builtin',    { fg=colors.blue_bold, ctermfg=ansi.blue_bold, bold=true })
vim.api.nvim_set_hl(0, '@function.macro',      { fg=colors.blue_bold, ctermfg=ansi.blue_bold })

vim.api.nvim_set_hl(0, 'Statement',            { fg=colors.red_bold,    ctermfg=ansi.red_bold })
vim.api.nvim_set_hl(0, 'Operator',             { fg=colors.orange_bold, ctermfg=ansi.orange_bold })
vim.api.nvim_set_hl(0, 'Exception',            { fg=colors.red,         ctermfg=ansi.red })

vim.api.nvim_set_hl(0, 'PreProc',              { fg=colors.red_bold,  ctermfg=ansi.red_bold })
vim.api.nvim_set_hl(0, 'Include',              { fg=colors.aqua_bold, ctermfg=ansi.aqua_bold })
vim.api.nvim_set_hl(0, '@keyword.import',      { fg=colors.aqua_bold, ctermfg=ansi.aqua_bold })
vim.api.nvim_set_hl(0, '@module',              { fg=colors.fg, ctermfg=ansi.fg })

vim.api.nvim_set_hl(0, 'Type',                 { fg=colors.yellow_bold, ctermfg=ansi.yellow_bold })
vim.api.nvim_set_hl(0, '@type.builtin',        { fg=colors.yellow_bold, ctermfg=ansi.yellow_bold, bold=true })

vim.api.nvim_set_hl(0, 'Delimiter',            { fg=colors.fg0,  ctermfg=ansi.fg0, bold=true })
vim.api.nvim_set_hl(0, '@punctuation.delimiter', { fg=colors.fg0,  ctermfg=ansi.fg0, bold=true })
vim.api.nvim_set_hl(0, '@punctuation.special', { fg=colors.fg0,  ctermfg=ansi.fg0, bold=true })
vim.api.nvim_set_hl(0, 'MatchParen',           { bg=colors.bg2, ctermbg=ansi.bg2 })

vim.api.nvim_set_hl(0, 'MarkdownURL',          { fg=colors.blue_bold, ctermfg=ansi.blue_bold, underline=true })
vim.api.nvim_set_hl(0, 'MarkdownLinkText',     { fg=colors.blue_bold, ctermfg=ansi.blue_bold })
vim.api.nvim_set_hl(0, 'MarkdownCode',         { fg=colors.fg,        ctermfg=ansi.fg, bold=true })

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
vim.api.nvim_set_hl(0, 'GitSignsAdd', { link = 'DiffAdd' })
vim.api.nvim_set_hl(0, 'GitSignsChange', { link = 'DiffChange' })
vim.api.nvim_set_hl(0, 'GitSignsChangedelete', { link = 'DiffChange' })
vim.api.nvim_set_hl(0, 'GitSignsDelete', { link = 'DiffDelete' })
vim.api.nvim_set_hl(0, 'GitSignsTopdelete', { link = 'DiffDelete' })
vim.api.nvim_set_hl(0, 'GitSignsUntracked', { link = 'DiffAdd' })
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
set cmdheight=0

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

" scrolling
set scrolloff=10
set scroll=10
autocmd VimResized * :silent! set scroll=10
autocmd WinEnter * :silent! set scroll=10

" whitespace
set expandtab
set tabstop=4
set shiftwidth=4
set list
set listchars=tab:>-,trail:·

" file completion
set path+=**
set wildmenu
set wildmode=longest,list,full
set wildoptions=pum
set inccommand=split

" clipboard
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
nnoremap <Leader>/ :Telescope find_files<CR>
nnoremap z= :Telescope spell_suggest<CR>
nnoremap g/ :Telescope builtin<CR>

vmap s S
" turn off truecolor if not supported
autocmd VimEnter * if $COLORTERM != "truecolor" | set notermguicolors | endif
