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

packer.init({
  config = {
    display = {
      open_fn = require('packer.util').float,
    }
  }
})

return packer.startup(function(use)

  use 'wbthomason/packer.nvim'

  use {
    'Shatur/neovim-ayu',
    config = function()
      require('ayu').colorscheme()

      -- let the terminal set the bg
      -- this lets active windows have a different bgcolor
      vim.cmd([[ highlight Normal guibg=None ctermbg=None ]])

      vim.cmd([[ highlight CursorLine guibg=#171f26 ]])
    end
  }

  use 'christoomey/vim-tmux-navigator'

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} },
    config = function()

      require('telescope').setup({
        defaults = {
          mappings = {
            i = {
              ["<Esc>"] = require('telescope.actions').close
            }
          },
          sorting_strategy = 'ascending',
          prompt_prefix = '   ',
          selection_caret = '   ',
          entry_prefix = '   ',
          border = false,
          path_display = 'truncate',
          layout_config = {
            horizontal = {
              width = 0.8,
              height = 0.6,
              prompt_position = 'top',
              -- preview_width = 0.55,
              results_width = 0.8,
            }
          },
        }
      })

      vim.keymap.set({'n', 'i', 'v'}, '<C-P>', function()
        require('telescope.builtin').find_files{}
      end)
      vim.keymap.set({'n', 'i', 'v'}, '<C-T>', function()
        require('telescope.builtin').find_files{}
      end)
      vim.keymap.set('n', '<Leader>k', function()
        require('telescope.builtin').grep_string{}
      end)
      vim.keymap.set('n', ';', function()
        require('telescope.builtin').buffers{}
      end)
      vim.keymap.set('n', 'gd', function()
        require('telescope.builtin').lsp_definitions{}
      end)
      vim.keymap.set('n', "'", function()
        require('telescope.builtin').treesitter{}
      end)

    end
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end

end)
