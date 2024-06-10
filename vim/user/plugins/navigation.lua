return {

  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v2.x',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    opts = {
      filesystem = {
        hijack_netrw_behavior = 'open_current'
      }
    },
    config = function(_, opts)
      vim.g.neo_tree_remove_legacy_commands = 1

      require('neo-tree').setup(opts)

      vim.keymap.set('n', '<C-g>', function()
        require('neo-tree.command').execute({ toggle = true })
      end)

      vim.keymap.set('n', '<Leader>f', function()
        require('neo-tree.command').execute({ reveal = true })
      end)
    end
  },

  {
    'ibhagwan/fzf-lua',
    dependencies = {
      'Shatur/neovim-ayu',
      'nvim-tree/nvim-web-devicons',
      {
        'junegunn/fzf',
        build = './install --bin'
      }
    },
    config = function()
      local colors = require('ayu.colors')
      colors.generate()

      local actions = require('fzf-lua.actions')

      require('fzf-lua').setup({

        winopts = {
          border = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
          hl = {
            normal = 'Normal'
          }
        },

        actions = {
          files = {
            ['default'] = actions.file_edit_or_qf,
            ['ctrl-x'] = actions.file_split,
            ['ctrl-v'] = actions.file_vsplit,
            ['ctrl-t'] = actions.file_tabedit,
            ['alt-q'] = actions.file_sel_to_qf,
            ['alt-l'] = actions.file_sel_to_ll,
          },
          buffers = {
            ['default'] = actions.buf_edit,
            ['ctrl-x'] = actions.buf_split,
            ['ctrl-v'] = actions.buf_vsplit,
            ['ctrl-t'] = actions.buf_tabedit,
          },
        },

        fzf_colors = {
          ['bg'] = '#171f26',
          ['bg+'] = colors.selection_bg,
          ['gutter'] = '#171f26',
          ['fg'] = '#cccccc',
          ['hl'] = '#ffffff',
          ['hl+'] = colors.keyword,
          ['pointer'] = '#ffffff',
          ['fg+'] = '#ffffff',
          ['header'] = '#cccccc',

          -- haven't figured out what these do
          -- ['prompt'] = '#000000',
          -- ['info'] = '#ff0000',
          -- ['marker'] = '#0000ff',
          -- ['spinner'] = '#00ff00',
        },

        fzf_opts = {
          ['--info'] = 'hidden',
          ['--pointer'] = '•',
        },

        files = {
          prompt = '      '
        },

        buffers = {
          prompt = '     ',
          actions = {
            ['ctrl-x'] = actions.buf_split,
            ['ctrl-d'] = { fn = actions.buf_del, reload = true }
          }
        },

        grep = {
          prompt = '    '
        },

        lsp = {
          prompt = '  → '
        }

      })

      vim.api.nvim_set_hl(0, 'FzfLuaBorder', { bg = '#171f26' })
      vim.api.nvim_set_hl(0, 'FzfLuaCursorLine', { bg = '#000000' })
      vim.api.nvim_set_hl(0, 'FzfLuaTitle', { bg = '#171f26', fg = '#171f26' })

      vim.keymap.set('n', '<C-P>', function()
        require('fzf-lua').files()
      end)
      vim.keymap.set('n', '<C-F>', function()
        require('fzf-lua').live_grep_native()
      end)
      vim.keymap.set('n', '<Leader>k', function()
        require('fzf-lua').grep_cword()
      end)
      vim.keymap.set('n', ';', function()
        require('fzf-lua').buffers()
      end)
      vim.keymap.set('n', '<Leader>l', function()
        require('fzf-lua').resume()
      end)
      vim.keymap.set('n', 'gd', function()
        require('fzf-lua').lsp_definitions({ jump_to_single_result = true })
      end)
      vim.keymap.set('n', "'", function()
        require('fzf-lua').lsp_document_symbols()
      end)
    end
  }

}
