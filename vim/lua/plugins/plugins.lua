return {

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },

  { "akinsho/bufferline.nvim", enabled = false },

  {
    "danielfalk/smart-open.nvim",
    dependencies = {
      "kkharji/sqlite.lua",
      "nvim-telescope/telescope.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-telescope/telescope-fzy-native.nvim",
    },
    config = function()
      require("telescope").load_extension("smart_open")
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "<c-k>", mode = "i", false }
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
          disabled_filetypes = { statusline = { "dashboard", "neo-tree" } },
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
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>E",
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      {
        "<leader>e",
        "<cmd>Yazi toggle<cr>",
        desc = "Open the file manager in nvim's working directory",
      },
    },
    opts = {
      open_for_directories = true,
      keymaps = {
        show_help = "<f1>",
      },
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "danielfalk/smart-open.nvim",
      "kkharji/sqlite.lua",
    },
    keys = {
      {
        ";",
        function()
          require("telescope").extensions.smart_open.smart_open({
            cwd_only = true,
            filename_first = false,
          })
        end,
      },
      {
        "'",
        function()
          require("telescope.builtin").lsp_document_symbols({ symbols = "method" })
        end,
      },
      {
        "<c-p>",
        function()
          require("telescope.builtin").find_files()
        end,
      },
      {
        "<leader><leader>",
        function()
          require("telescope.builtin").resume()
        end,
      },
      {
        "<leader>,",
        function()
          require("telescope.builtin").pickers()
        end,
      },
    },
    opts = {
      defaults = {
        layout_config = {
          prompt_position = "top",
        },
        results_title = false,
        prompt_title = false,
        sorting_strategy = "ascending",
        mappings = {
          i = {
            ["<esc>"] = require("telescope.actions").close,
            ["<c-j>"] = require("telescope.actions").move_selection_next,
            ["<c-k>"] = require("telescope.actions").move_selection_previous,
          },
        },
      },
    },
  },

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
