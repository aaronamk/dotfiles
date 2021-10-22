return require('packer').startup(function()
-- Packer can manage itself
use 'wbthomason/packer.nvim'

-- streamlined editing
--------------------------------------------------------------------------------
-- smart syntax parser
use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
-- treesitter text objects
use 'nvim-treesitter/nvim-treesitter-textobjects'
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
-- completion helper
use 'hrsh7th/nvim-compe'
-- lua fzf implementation
use 'vijaymarupudi/nvim-fzf'
-- lua fzf bindings
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
use 'hoob3rt/lualine.nvim'
-- highlight references
use 'nvim-treesitter/nvim-treesitter-refactor'
-- highlight colors in that color
use 'norcalli/nvim-colorizer.lua'
end)
