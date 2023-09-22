return {

  'tpope/vim-sleuth',

  {
    'tweekmonster/wstrip.vim',
    config = function()
      vim.g.wstrip_auto = 1
    end
  },

  {
    'kylechui/nvim-surround',
    version = '*',
    config = true
  },

  {
    'windwp/nvim-autopairs',
    config = true
  },

  {
    'smjonas/inc-rename.nvim',
    config = function(_, opts)
      require('inc_rename').setup(opts)
      vim.keymap.set('n', '<leader>rn', ':IncRename ')
    end
  },

  {
    'nvim-treesitter/nvim-treesitter',
    version = false,
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
      'windwp/nvim-ts-autotag',
      'JoosepAlviste/nvim-ts-context-commentstring',
      'numToStr/Comment.nvim'
    },
    opts = {
      auto_install = true,
      highlight = {
        enable = true,
        disable = { 'embedded_template' }
      },
      indent = {
        enable = true
      },
      autopairs = {
        enable = true
      },
      autotag = {
        enable = true
      },
      context_commentstring = {
        enable = true
      }
    },
    config = function(_, opts)
      require('nvim-treesitter.install').compilers = { 'gcc' }
      require('nvim-treesitter.configs').setup(opts)
      require('ts_context_commentstring').setup {}
      require('Comment').setup {
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      }
    end
  },

  {
    'folke/todo-comments.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    config = true
  }

}
