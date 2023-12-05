return {

  {
    'nvim-tree/nvim-web-devicons',
    lazy = true,
    config = true
  },

  {
    'Shatur/neovim-ayu',
    config = function()
      local colors = require('ayu.colors')
      colors.generate()

      require('ayu').setup({
        overrides = {
          LineNr = { fg = colors.comment },
          NonText = { fg = '#434c5d' },
          SpecialKey = { fg = '#434c5d' }
        }
      })

      require('ayu').colorscheme()

      -- let the terminal set the bg
      -- this lets active windows have a different bgcolor
      vim.cmd([[ highlight Normal guibg=None ctermbg=None ]])

      vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#171f26' })
      vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#1F2A33' })

      vim.api.nvim_create_autocmd('InsertEnter', {
        callback = function()
          vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#000000' })
        end
      })

      vim.api.nvim_create_autocmd('InsertLeave', {
        callback = function()
          vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#171f26' })
        end
      })
    end
  },

  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-treesitter/nvim-treesitter',
      {
        'rcarriga/nvim-notify',
        opts = {
          stages = 'static',
          timeout = 10000
        }
      },
    },
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true
        }
      },
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = true, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true -- add a border to hover docs and signature help
      }
    },
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      scope = {
        enabled = true,
        show_start = false
      }
    }
  },

  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = {
      'Shatur/neovim-ayu',
      'stevearc/aerial.nvim'
    },
    config = function()
      require('aerial').setup()

      local custom_ayu = require('lualine.themes.ayu')
      local colors = require('ayu.colors')
      colors.generate()

      custom_ayu.normal.c = { fg = colors.fg, bg = '#1F2A33' }
      custom_ayu.normal.x = { fg = colors.comment, bg = '#1F2A33' }
      custom_ayu.inactive.c =  { fg = colors.fg_idle, bg = '#171f26' }

      local function lines()
        return vim.api.nvim_win_get_cursor(0)[1] .. '/' .. vim.api.nvim_buf_line_count(0)
      end

      require('lualine').setup {
        options = {
          theme = custom_ayu,
          section_separators = '',
          component_separators = '',
          icons_enabled = false
        },
        sections = {
          lualine_b = {},
          lualine_c = {
            {
              'filename',
              path = 1,
              symbols = { modified = '*' },
              padding = { left = 2 }
            }
          },
          lualine_x = {
            {
              'aerial',
              sep = ' › ',
              padding = { left = 1, right = 2 }
            }
          },
          lualine_y = {
            {
              'diff',
              separator = ''
            },
            'branch'
          },
          lualine_z = { lines }
        },
        inactive_sections = {
          lualine_c = {
            {
              'mode',
              separator = '',
              padding = { left = 1, right = 3 }
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
  },

  'christoomey/vim-tmux-navigator'

}
