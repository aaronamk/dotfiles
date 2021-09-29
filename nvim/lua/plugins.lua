return require('packer').startup(function()
-- Packer can manage itself
use 'wbthomason/packer.nvim'

-- streamlined editing
--------------------------------------------------------------------------------
-- smart syntax parser
use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
-- better text objects
use 'wellle/targets.vim'
-- commenting bindings
use 'tpope/vim-commentary'
-- treesitter commenting
use 'JoosepAlviste/nvim-ts-context-commentstring'
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
-- highlight colors in that color
use 'norcalli/nvim-colorizer.lua'

end)
