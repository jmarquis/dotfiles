return {

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'williamboman/mason-lspconfig.nvim',
      'folke/neoconf.nvim',
      'folke/neodev.nvim',
      'b0o/SchemaStore.nvim',
      'jayp0521/mason-null-ls.nvim',
      'williamboman/mason.nvim',
      'jose-elias-alvarez/null-ls.nvim'
    },
    config = function()
      require('mason').setup()

      require('mason-null-ls').setup({
        automatic_setup = true
      })

      local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
      require('null-ls').setup({
        sources = { require('null-ls').builtins.formatting.prettierd },
        on_attach = function(client, bufnr)
          -- format on save
          if client.supports_method('textDocument/formatting') then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd('BufWritePre', {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
              end,
            })
          end
        end,
      })

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

      require('neoconf').setup({})
      require('neodev').setup({})

      require('mason-lspconfig').setup()

      -- automatically initialize LSP server per filetype
      require('mason-lspconfig').setup_handlers({
        function(server_name)

          local args = {
            on_attach = on_attach
          }

          if server_name == 'tsserver' then
            args.init_options = {
              hostInfo = 'neovim',
              maxTsServerMemory = 8192
            }
          end

          if server_name == 'intelephense' then
            args.settings = {
              intelephense = {
                maxMemory = 8192
              }
            }
          end

          if server_name == 'jsonls' then
            args.settings = {
              json = {
                schemas = require('schemastore').json.schemas(),
                validate = { enable = true }
              }
            }
          end

          require('lspconfig')[server_name].setup(args)

        end
      })
    end
  }

}

