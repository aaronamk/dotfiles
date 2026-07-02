" Neovim config file
" Author: aaronamk
" Dependencies: git (a decently modern version), fzf, tree-sitter cli, LSP clients


lua <<EOF
vim.loader.enable()
vim.g.mapleader = " "
vim.cmd("set termguicolors")

-- plugins
-----------------------------------------------------------------------------------------------------------------------
vim.pack.add({
  -- treesitter
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',

  -- completion
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/smjonas/inc-rename.nvim',
  'https://github.com/windwp/nvim-autopairs',

  -- telescope
  'https://github.com/nvim-lua/plenary.nvim',
  { src = 'https://github.com/nvim-telescope/telescope.nvim', version = 'v0.2.1' },

  -- git
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/lewis6991/gitsigns.nvim',

  -- other
  'https://github.com/ellisonleao/gruvbox.nvim',
  'https://github.com/norcalli/nvim-colorizer.lua',
  'https://github.com/echasnovski/mini.ai',
  'https://github.com/echasnovski/mini.surround',
  'https://github.com/numToStr/Comment.nvim',
  'https://github.com/nvim-lualine/lualine.nvim',
})

-- treesitter
-- Install parsers (replaces ensure_installed; runs on startup, skips already-installed ones)
require('nvim-treesitter').install({ 'c', 'cpp', 'lua', 'vim', 'vimdoc', 'query', 'python', 'bash', 'go', 'rust', 'javascript', 'json', 'ini', 'toml', 'yaml', })

-- Highlighting: activate per-buffer via FileType autocmd
vim.api.nvim_create_autocmd('FileType', {
  callback = function(ev)
    pcall(vim.treesitter.start, ev.buf)
  end,
})

-- Indent: treesitter-based indentation
vim.api.nvim_create_autocmd('FileType', {
  callback = function(ev)
    local ok = pcall(require, 'nvim-treesitter')
    if ok then
      vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- Textobjects: nvim-treesitter-textobjects now has its own setup and direct keymap API
require('nvim-treesitter-textobjects').setup({
  select = { lookahead = true },
  move   = { set_jumps = false },
})

local ts_select = require('nvim-treesitter-textobjects.select')
local ts_move   = require('nvim-treesitter-textobjects.move')

local function sel(obj)  return function() ts_select.select_textobject(obj, 'textobjects') end end
local function next_s(o) return function() ts_move.goto_next_start(o,     'textobjects') end end
local function next_e(o) return function() ts_move.goto_next_end(o,       'textobjects') end end
local function prev_s(o) return function() ts_move.goto_previous_start(o, 'textobjects') end end
local function prev_e(o) return function() ts_move.goto_previous_end(o,   'textobjects') end end

-- select text objects
vim.keymap.set({'x','o'}, 'aB', sel('@block.outer'))
vim.keymap.set({'x','o'}, 'iB', sel('@block.inner'))
vim.keymap.set({'x','o'}, 'aa', sel('@parameter.outer'))
vim.keymap.set({'x','o'}, 'ia', sel('@parameter.inner'))
vim.keymap.set({'x','o'}, 'af', sel('@function.outer'))
vim.keymap.set({'x','o'}, 'if', sel('@function.inner'))
vim.keymap.set({'x','o'}, 'ac', sel('@class.outer'))
vim.keymap.set({'x','o'}, 'ic', sel('@class.inner'))

-- move: next start
vim.keymap.set('n', ']B', next_s('@block.outer'))
vim.keymap.set('n', ']a', next_s('@parameter.outer'))
vim.keymap.set('n', ']f', next_s('@function.outer'))
vim.keymap.set('n', ']]', next_s('@call.outer'))
-- move: next end
vim.keymap.set('n', ']A', next_e('@parameter.outer'))
vim.keymap.set('n', ']F', next_e('@function.outer'))
vim.keymap.set('n', '][', next_e('@call.outer'))
-- move: prev start
vim.keymap.set('n', '[B', prev_s('@block.outer'))
vim.keymap.set('n', '[a', prev_s('@parameter.outer'))
vim.keymap.set('n', '[f', prev_s('@function.outer'))
vim.keymap.set('n', '[[', prev_s('@call.outer'))
-- move: prev end
vim.keymap.set('n', '[A', prev_e('@parameter.outer'))
vim.keymap.set('n', '[F', prev_e('@function.outer'))
vim.keymap.set('n', '[]', prev_e('@call.outer'))

-- completion
vim.opt.completeopt = { 'menuone', 'noselect', 'popup' }
vim.opt.autocomplete = true
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp_completion', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, args.data.client_id, args.buf, { autotrigger = false })
      vim.bo[args.buf].complete = 'o,f'
    end
  end,
})
vim.keymap.set('i', '<Tab>',   function() return vim.fn.pumvisible() == 1 and '<C-n>' or '<Tab>'   end, { expr = true })
vim.keymap.set('i', '<S-Tab>', function() return vim.fn.pumvisible() == 1 and '<C-p>' or '<S-Tab>' end, { expr = true })

require('inc_rename').setup({})

-- LSP
-- Global settings applied to all servers (capabilities, root fallback, etc.)
vim.lsp.config('*', {
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  root_markers = { '.git' },
})
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim' } },
      workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
      telemetry = { enable = false },
    },
  },
})

-- diagnistics config
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

-- Enable servers
vim.lsp.enable({ 'lua_ls', 'pyright', 'gopls', 'rust_analyzer', 'ts_ls', 'clangd', 'bashls', 'jsonls', })

require('nvim-autopairs').setup({ check_ts = true })

-- telescope
local actions = require('telescope.actions')
require('telescope').setup({
  defaults = {
    layout_strategy = "vertical",
    layout_config = { preview_height = 0.75, prompt_position = "top", width = 0.9, height = 0.9, mirror = true },
    mappings = {
      i = {
        ["<esc>"]   = actions.close,
        ["<Tab>"]   = actions.move_selection_next,
        ["<S-Tab>"] = actions.move_selection_previous,
      },
    },
    sorting_strategy = "ascending",
  }
})

-- git
require('gitsigns').setup({
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
    end, { expr = true })

    map('n', '[h', function()
      if vim.wo.diff then return '[h' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, { expr = true })

    -- Actions
    map('n', 'zh', gs.reset_hunk)
    map('v', 'zh', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
    map('n', 'zH', gs.reset_buffer)
    map('n', 'gh', gs.preview_hunk)

    -- Text object
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
})

-- other
require('colorizer').setup({ '*' })

require('mini.ai').setup({})

require('mini.surround').setup({
  mappings = { delete = 'ds', replace = 'cs' },
  n_lines = 100,
  respect_selection_type = true,
  search_method = 'cover_or_nearest',
})

require('Comment').setup({})

require('lualine').setup({
  options = { theme = 'gruvbox', section_separators = '', component_separators = '' },
  sections = {
    lualine_a = { { 'filename', file_status = true, path = 1 } },
    lualine_b = { 'progress' },
    lualine_c = { { 'diagnostics', sources = { 'nvim_diagnostic' }, symbols = { error = '✖ ', warn = '! ', info = 'i ', hint = 'h ' } } },
    lualine_x = {}, lualine_y = {},
    lualine_z = { 'branch' },
  }
})

-- appearance
-----------------------------------------------------------------------------------------------------------------------
-- gruvbox dark
require("gruvbox").setup({ contrast= "hard",
  overrides = {
    ["@lsp.type.parameter"] = { fg="#ebdbb2" },
    ["@variable.parameter"] = { fg="#ebdbb2" },
    ["@property"] = { fg="#ebdbb2" },
    ["@variable.member"] = { fg="#ebdbb2" },
    ["@variable.builtin"] = { fg="#ebdbb2" },
    ["@constructor"] = { fg="#ebdbb2", bold=true },
    ["@punctuation.delimiter"] = { fg="#ebdbb2" },
    ["@punctuation.bracket"] = { fg="#ebdbb2" },
    ["Function"] = { fg="#83a598" },
    ["@function.builtin"] = { fg="#83a598" },
    ["@string.escape"] = { fg="#d3869b" },
    ["@lsp.type.macro"] = { fg="#d3869b" },
    ["@character.special"] = { fg="#d3869b" },
  }
})
vim.cmd.colorscheme("gruvbox")
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

" cmdline autocompletion
autocmd CmdlineChanged [:\/\?] call wildtrigger()
cnoremap <expr> <Up>   wildmenumode() ? "\<C-E>\<Up>"   : "\<Up>"
cnoremap <expr> <Down> wildmenumode() ? "\<C-E>\<Down>" : "\<Down>"
set path+=**
set wildmenu
set wildmode=noselect:lastused,full
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
