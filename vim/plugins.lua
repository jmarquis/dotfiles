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
      local colors = require('ayu.colors')
      colors.generate()

      -- let the terminal set the bg
      -- this lets active windows have a different bgcolor
      vim.cmd([[ highlight Normal guibg=None ctermbg=None ]])

      -- vim.cmd([[ highlight CursorLine guibg=#171f26 ]])
      vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#171f26' })
      vim.cmd([[ autocmd InsertEnter * highlight CursorLine guibg=#000000 ]])
      vim.cmd([[ autocmd InsertLeave * highlight CursorLine guibg=#171f26 ctermbg=235 ]])
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
              ["<Esc>"] = require('telescope.actions').close,
              ["<C-j>"] = require('telescope.actions').move_selection_next,
              ["<C-k>"] = require('telescope.actions').move_selection_previous
            }
          },
          sorting_strategy = 'ascending',
          prompt_prefix = '   ',
          selection_caret = '   ',
          entry_prefix = '   ',
          path_display = 'truncate',
          layout_config = {
            horizontal = {
              width = 0.8,
              height = 0.6,
              prompt_position = 'top',
            }
          },
        }
      })

      local colors = require('ayu.colors')
      colors.generate()

      vim.api.nvim_set_hl(0, 'TelescopeNormal', { bg = '#171f26' })
      vim.api.nvim_set_hl(0, 'TelescopeBorder', { bg = '#171f26', fg = '#171f26' })
      vim.api.nvim_set_hl(0, 'TelescopePromptBorder', { bg = '#171f26', fg = '#171f26' })
      vim.api.nvim_set_hl(0, 'TelescopePreviewTitle', { bg = '#171f26', fg = '#171f26' })

      vim.api.nvim_set_hl(0, 'TelescopeSelection', { bg = colors.selection_bg, fg = 'white' })

      vim.api.nvim_set_hl(0, 'TelescopePromptPrefix', { bg = colors.panel_bg })
      vim.api.nvim_set_hl(0, 'TelescopeMatching', { bold = true })

      vim.api.nvim_set_hl(0, 'TelescopePromptTitle', { bg = '#171f26', fg = '#171f26' })

      vim.keymap.set({'n', 'i', 'v'}, '<C-P>', function()
        require('telescope.builtin').find_files()
      end)
      vim.keymap.set({'n', 'i', 'v'}, '<C-T>', function()
        require('telescope.builtin').find_files()
      end)
      vim.keymap.set('n', '<Leader>k', function()
        require('telescope.builtin').grep_string()
      end)
      vim.keymap.set('n', ';', function()
        require('telescope.builtin').buffers()
      end)
      vim.keymap.set('n', 'gd', function()
        require('telescope.builtin').lsp_definitions()
      end)
      vim.keymap.set('n', "'", function()
        require('telescope.builtin').treesitter()
      end)

    end
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end

end)
