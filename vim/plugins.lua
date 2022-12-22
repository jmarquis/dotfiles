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

  use {
    'Shatur/neovim-ayu',
    config = function()
      local colors = require('ayu.colors')
      colors.generate()

      require('ayu').setup({
        overrides = {
          LineNr = { fg = colors.comment },
          lualine_c_normal = { bg = '#ff0000' },
        }
      })

      require('ayu').colorscheme()

      -- let the terminal set the bg
      -- this lets active windows have a different bgcolor
      vim.cmd([[ highlight Normal guibg=None ctermbg=None ]])

      vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#171f26' })
      vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#1F2A33' })

      vim.api.nvim_create_autocmd('ColorScheme', {
        callback = function()
          vim.api.nvim_set_hl(0, 'lualine_c_normal', { bg = '#171f26' })
        end
      })

      vim.api.nvim_create_autocmd('InsertEnter', {
        callback = function()
          if vim.bo[vim.api.nvim_get_current_buf()].filetype == 'TelescopePrompt' then
            vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#1F2A33' })
          else
            vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#000000' })
          end
        end
      })

      vim.api.nvim_create_autocmd('InsertLeave', {
        callback = function()
          vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#171f26' })
        end
      })
    end
  }

  use 'christoomey/vim-tmux-navigator'

  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end,
    config = function()
      require('nvim-treesitter.install').compilers = { 'gcc-11' }
      require('nvim-treesitter.configs').setup {
        auto_install = true,
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
        autopairs = {
          enable = true,
        }
      }
    end
  }

  use {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require('indent_blankline').setup({
        show_current_context = true,
        show_current_context_start = false
      })
    end
  }

  use 'tpope/vim-sleuth'
  use 'windwp/nvim-ts-autotag'
  use 'JoosepAlviste/nvim-ts-context-commentstring'

  use {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup {}
    end
  }

  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup({
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      })
    end
  }

  use {
    'hrsh7th/nvim-cmp',
    requires = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-cmdline' },
      {
        'saadparwaiz1/cmp_luasnip',
        requires = {
          { 'L3MON4D3/LuaSnip' }
        }
      },
      { 'onsails/lspkind.nvim' }
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup {
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
        }, {
          { name = 'buffer' },
        }),
        mapping = {
          ['<C-k>'] = cmp.mapping.select_prev_item(),
          ['<C-j>'] = cmp.mapping.select_next_item(),
          ['<CR>'] = cmp.mapping.confirm { select = true },
          ['<Tab>'] = cmp.mapping.confirm { select = true }
        },
        window = {
          completion = {
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
            col_offset = -3,
            side_padding = 0,
          },
        },
        formatting = {
          fields = { 'kind', 'abbr', 'menu' },
          format = function(entry, vim_item)
            local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = " " .. strings[1] .. " "
            kind.menu = "    (" .. strings[2] .. ")"

            return kind
          end
        }
      }

      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })
    end
  }

  use {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end
  }

  use {
    'williamboman/mason-lspconfig.nvim',
    requires = {
      { 'neovim/nvim-lspconfig' },
    },
    config = function()

      local on_attach = function(client, bufnr)
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)

        -- highlight symbol under cursor
        if client.server_capabilities.documentHighlightProvider then

          local colors = require('ayu.colors')
          colors.generate()

          vim.api.nvim_set_hl(0, 'LspReferenceRead', { bg = colors.selection_bg })
          vim.api.nvim_set_hl(0, 'LspReferenceText', { bg = colors.selection_bg })
          vim.api.nvim_set_hl(0, 'LspReferenceWrite', { bg = colors.selection_bg })

          vim.api.nvim_create_augroup('lsp_document_highlight', {
            clear = false
          })
          vim.api.nvim_clear_autocmds({
            buffer = bufnr,
            group = 'lsp_document_highlight',
          })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            group = 'lsp_document_highlight',
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            group = 'lsp_document_highlight',
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
          })

        end
      end

      require('mason-lspconfig').setup()

      require('mason-lspconfig').setup_handlers({
        function(server_name)
          require('lspconfig')[server_name].setup {
            on_attach = on_attach
          }
        end
      })

    end
  }

  use {
    'nvim-tree/nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').setup()
    end
  }

  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  }

  use {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.0',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'Shatur/neovim-ayu' },
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
      },
    },
    after = 'neovim-ayu',
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
          path_display = { truncate = 3 },
          layout_config = {
            horizontal = {
              width = 0.8,
              height = 0.6,
              prompt_position = 'top',
            }
          },
        },
        extensions = {
          fzf = {}
        }
      })

      require('telescope').load_extension('fzf')

      local colors = require('ayu.colors')
      colors.generate()

      vim.api.nvim_set_hl(0, 'TelescopeNormal', { bg = '#171f26' })
      vim.api.nvim_set_hl(0, 'TelescopeBorder', { bg = '#171f26', fg = '#171f26' })
      vim.api.nvim_set_hl(0, 'TelescopePromptNormal', { bg = '#1F2A33' })
      vim.api.nvim_set_hl(0, 'TelescopePromptCounter', { bg = '#1F2A33', fg = colors.ui })
      vim.api.nvim_set_hl(0, 'TelescopePromptTitle', { bg = '#1F2A33', fg = '#1F2A33' })
      vim.api.nvim_set_hl(0, 'TelescopePromptBorder', { bg = '#1F2A33', fg = '#1F2A33' })
      vim.api.nvim_set_hl(0, 'TelescopePromptPrefix', { bg = '#1F2A33' })
      vim.api.nvim_set_hl(0, 'TelescopePreviewTitle', { bg = '#171f26', fg = '#171f26' })
      vim.api.nvim_set_hl(0, 'TelescopeSelection', { bg = colors.selection_bg, fg = 'white' })
      vim.api.nvim_set_hl(0, 'TelescopeMatching', { fg = colors.white, bold = true })

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

  use {
    'nvim-lualine/lualine.nvim',
    requires = {
      { 'Shatur/neovim-ayu' }
    },
    after = 'neovim-ayu',
    config = function()
      local custom_ayu = require('lualine.themes.ayu')

      custom_ayu.normal.c.bg = '#171f26'

      require('lualine').setup {
        sections = {
          lualine_b = {},
          lualine_c = {
            {
              'filetype',
              icon_only = true,
              separator = '',
              padding = { left = 2, right = 0 }
            },
            {
              'filename',
              path = 1,
              symbols = { modified = '*' }
            }
          },
          lualine_x = { 'diff' },
          lualine_y = { 'branch' },
        },
        inactive_sections = {
          lualine_c = {
            {
              'mode',
              separator = '',
              padding = { left = 1, right = 2 }
            },
            {
              'filetype',
              icon_only = true,
              separator = '',
              padding = { left = 1, right = 0 }
            },
            {
              'filename',
              path = 1,
              symbols = { modified = '*' }
            }
          },
        }
      }
    end
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end

end,

config = {
  display = {
    open_fn = function()
      return require('packer.util').float { border = 'rounded'}
    end
  }
}})