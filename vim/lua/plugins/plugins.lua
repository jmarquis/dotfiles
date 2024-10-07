return {

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },

  { "akinsho/bufferline.nvim", enabled = false },

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "<c-k>", mode = "i", false }
      keys[#keys + 1] = {
        "<leader>gd",
        "<cmd>FzfLua lsp_definitions ignore_current_line=true<cr>",
        desc = "Goto Definition (list)",
        has = "definition",
      }
      keys[#keys + 1] = {
        "gD",
        "<cmd>FzfLua lsp_definitions ignore_current_line=true<cr>",
        desc = "Goto Definition (list)",
        has = "definition",
      }
      opts.servers["ruby_lsp"] = {
        mason = false,
        cmd = { vim.fn.expand("~/.rbenv/shims/ruby-lsp") },
      }
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<c-j>"] = cmp.mapping.select_next_item(),
        ["<c-k>"] = cmp.mapping.select_prev_item(),
        ["<tab>"] = cmp.mapping.confirm(),
        ["<cr>"] = cmp.config.disable,
      })
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = function()
      local icons = LazyVim.config.icons

      local function lines()
        return vim.api.nvim_win_get_cursor(0)[1] .. "/" .. vim.api.nvim_buf_line_count(0)
      end

      local sections = {
        lualine_a = { "mode" },
        lualine_b = {
          vim.tbl_extend("force", LazyVim.lualine.root_dir(), {
            padding = 2,
          }),
        },
        lualine_c = {
          { "filetype", icon_only = true, separator = "", padding = { left = 2, right = 0 } },
          { LazyVim.lualine.pretty_path() },
        },
        lualine_x = {
          {
            function()
              return require("nvim-navic").get_location()
            end,
            cond = function()
              return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
            end,
          },
          {
            function()
              return require("noice").api.status.mode.get()
            end,
            cond = function()
              return package.loaded["noice"] and require("noice").api.status.mode.has()
            end,
            color = function()
              return LazyVim.ui.fg("Constant")
            end,
          },
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
            padding = 2,
          },
        },
        lualine_y = {
          {
            "diff",
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
          "branch",
        },
        lualine_z = {
          lines,
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = function()
              return LazyVim.ui.fg("Comment")
            end,
          },
        },
      }

      local inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      }

      vim.list_extend(inactive_sections.lualine_b, sections.lualine_a)
      vim.list_extend(inactive_sections.lualine_b, sections.lualine_b)
      vim.list_extend(inactive_sections.lualine_b, sections.lualine_c)
      vim.list_extend(inactive_sections.lualine_y, sections.lualine_x)
      vim.list_extend(inactive_sections.lualine_y, sections.lualine_y)
      vim.list_extend(inactive_sections.lualine_y, sections.lualine_z)

      return {
        options = {
          disabled_filetypes = { statusline = { "dashboard", "NvimTree" } },
          section_separators = "",
          component_separators = "",
        },
        sections = sections,
        inactive_sections = inactive_sections,
      }
    end,
  },

  { "jeetsukumaran/vim-indentwise" },

  { "nvim-neo-tree/neo-tree.nvim", enabled = false },

  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    opts = {
      view = {
        width = 40,
      },
    },
    keys = {
      {
        "<leader>e",
        function()
          require("nvim-tree.api").tree.toggle()
        end,
      },
      {
        "<leader>E",
        function()
          require("nvim-tree.api").tree.find_file({ open = true, focus = true })
        end,
      },
    },
  },

  { "nvim-telescope/telescope.nvim", enabled = false },

  {
    "ibhagwan/fzf-lua",
    opts = {
      winopts = {
        border = { " ", " ", " ", " ", " ", " ", " ", " " },
        preview = {
          title = false,
        },
      },
      files = {
        winopts = {
          title = { { "", "" } },
        },
        actions = {
          ["ctrl-x"] = require("fzf-lua.actions").file_split,
        },
        header = false,
        no_header_i = true,
      },
      buffers = {
        winopts = {
          title = { { "", "" } },
        },
        actions = {
          ["ctrl-x"] = require("fzf-lua.actions").buf_split,
        },
      },
      grep = {
        winopts = {
          title = { { "", "" } },
        },
        actions = {
          ["ctrl-x"] = require("fzf-lua.actions").file_split,
        },
        header = false,
        no_header_i = true,
      },
      lsp = {
        winopts = {
          title = { { "", "" } },
        },
        actions = {
          ["ctrl-x"] = require("fzf-lua.actions").file_split,
        },
      },
    },
    keys = {
      {
        "<leader>;",
        function()
          local cmd = ""
          local buffers = {}
          for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(bufnr) then
              local bufname = vim.api.nvim_buf_get_name(bufnr)
              if bufname ~= "" then
                bufname = vim.fn.fnamemodify(bufname, ":~:.")
                if
                  string.find(vim.fs.basename(bufname), "NvimTree_") ~= 1 -- filter out nvim tree buffer
                  and bufname ~= vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.") -- filter out current buffer
                then
                  local info = vim.fn.getbufinfo(bufnr)
                  table.insert(buffers, { name = bufname, info = info[1] or info })
                end
              end
            end
          end

          table.sort(buffers, function(a, b)
            return a.info.lastused > b.info.lastused
          end)

          for _, buffer in ipairs(buffers) do
            cmd = cmd .. 'echo "' .. buffer.name .. '" && '
          end

          cmd = cmd .. "fd --color=never --type f --hidden --follow --exclude .git"

          for _, buffer in ipairs(buffers) do
            cmd = cmd .. ' --exclude "' .. buffer.name .. '"'
          end

          require("fzf-lua").files({ cmd = cmd, fzf_opts = { ["--tiebreak"] = "index" } })
        end,
      },
      {
        "<leader><leader>",
        function()
          require("fzf-lua").resume()
        end,
      },
      {
        "<leader>k",
        function()
          require("fzf-lua").grep_cword()
        end,
      },
      {
        "'",
        function()
          require("fzf-lua").lsp_document_symbols()
        end,
      },
    },
  },

  --   dependencies = {
  --     "danielfalk/smart-open.nvim",
  --     "kkharji/sqlite.lua",
  --   },
  --   keys = {
  --     {
  --       ";",
  --       function()
  --         require("telescope").extensions.smart_open.smart_open({
  --           cwd_only = true,
  --           filename_first = false,
  --         })
  --       end,
  --     },
  --     {
  --       "'",
  --       function()
  --         require("telescope.builtin").lsp_document_symbols({ symbols = "method" })
  --       end,
  --     },
  --     {
  --       "<c-p>",
  --       function()
  --         require("telescope.builtin").find_files()
  --       end,
  --     },
  --     {
  --       "<leader><leader>",
  --       function()
  --         require("telescope.builtin").resume()
  --       end,
  --     },
  --     {
  --       "<leader>,",
  --       function()
  --         require("telescope.builtin").pickers()
  --       end,
  --     },
  --   },
  --   opts = {
  --     defaults = {
  --       layout_config = {
  --         prompt_position = "top",
  --       },
  --       results_title = false,
  --       prompt_title = false,
  --       sorting_strategy = "ascending",
  --       mappings = {
  --         i = {
  --           ["<esc>"] = require("telescope.actions").close,
  --           ["<c-j>"] = require("telescope.actions").move_selection_next,
  --           ["<c-k>"] = require("telescope.actions").move_selection_previous,
  --         },
  --       },
  --     },
  --   },
  -- },

  {
    "echasnovski/mini.surround",
    opts = {
      mappings = {
        replace = "cs",
      },
    },
  },

  {
    "folke/flash.nvim",
    keys = {
      { "s", false },
    },
  },

  {
    "catppuccin/nvim",
    config = function()
      local colors = require("catppuccin.palettes").get_palette()
      local TelescopeColor = {
        TelescopeMatching = { fg = colors.flamingo },
        TelescopeSelection = { fg = colors.text, bg = colors.surface0, bold = true },

        TelescopePromptPrefix = { bg = colors.surface0 },
        TelescopePromptNormal = { bg = colors.surface0 },
        TelescopeResultsNormal = { bg = colors.mantle },
        TelescopePreviewNormal = { bg = colors.mantle },
        TelescopePromptBorder = { bg = colors.surface0, fg = colors.surface0 },
        TelescopeResultsBorder = { bg = colors.mantle, fg = colors.mantle },
        TelescopePreviewBorder = { bg = colors.mantle, fg = colors.mantle },
        TelescopePromptTitle = { bg = colors.surface0, fg = colors.surface0 },
        TelescopeResultsTitle = { fg = colors.mantle },
        TelescopePreviewTitle = { bg = colors.mantle, fg = colors.mantle },
      }

      for hl, col in pairs(TelescopeColor) do
        vim.api.nvim_set_hl(0, hl, col)
      end
    end,
  },

  {
    "FabijanZulj/blame.nvim",
    keys = {
      { "<leader>gb", "<cmd>BlameToggle<cr>" },
    },
    opts = {
      blame_options = { "-w" },
      date_format = "%Y-%m-%d",
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    config = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        opts.ensure_installed = LazyVim.dedup(opts.ensure_installed)
      end
      require("nvim-treesitter.install").compilers = { "gcc-6", "gcc", "clang++", "clang" }
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  { "tpope/vim-sleuth" },

  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    keys = {
      {
        "<c-h>",
        function()
          require("smart-splits").move_cursor_left()
        end,
      },
      {
        "<c-j>",
        function()
          require("smart-splits").move_cursor_down()
        end,
      },
      {
        "<c-k>",
        function()
          require("smart-splits").move_cursor_up()
        end,
      },
      {
        "<c-l>",
        function()
          require("smart-splits").move_cursor_right()
        end,
      },
    },
  },

  {
    "tummetott/reticle.nvim",
    config = true,
  },
}
