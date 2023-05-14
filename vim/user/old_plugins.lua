vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()
local packer = require 'packer'

return packer.startup({ function(use)

  use 'wbthomason/packer.nvim'

  use 'Shatur/neovim-ayu'

  use 'christoomey/vim-tmux-navigator'

  use 'nvim-treesitter/nvim-treesitter'

  use 'lukas-reineke/indent-blankline.nvim'

  use 'tpope/vim-sleuth'
  use 'windwp/nvim-ts-autotag'
  use 'JoosepAlviste/nvim-ts-context-commentstring'

  use 'windwp/nvim-autopairs'

  use 'numToStr/Comment.nvim'

  -- completion stuff
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'saadparwaiz1/cmp_luasnip'
  use 'L3MON4D3/LuaSnip'
  use 'onsails/lspkind.nvim'

  -- LSP stuff
  use 'williamboman/mason-lspconfig.nvim'
  use 'neovim/nvim-lspconfig'
  use 'folke/neoconf.nvim'
  use 'folke/neodev.nvim'
  use 'b0o/SchemaStore.nvim'
  use 'jayp0521/mason-null-ls.nvim'
  use 'williamboman/mason.nvim'
  use 'jose-elias-alvarez/null-ls.nvim'

  use 'nvim-tree/nvim-web-devicons'

  use {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v2.x',
  }

  use 'nvim-lua/plenary.nvim'
  use 'MunifTanjim/nui.nvim'

  use 'lewis6991/gitsigns.nvim'

  use {
    'junegunn/fzf',
    run = './install --bin',
  }
  use 'ibhagwan/fzf-lua'


  use {
    'kylechui/nvim-surround',
    tag = '*',
  }

  use 'tweekmonster/wstrip.vim'

  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'

  use 'folke/noice.nvim'
  use 'rcarriga/nvim-notify'

  use 'smjonas/inc-rename.nvim'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end

end,

config = {
  display = {
    open_fn = function()
      return require('packer.util').float { border = 'rounded' }
    end
  }
}})
