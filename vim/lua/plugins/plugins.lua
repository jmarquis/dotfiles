local function symbols_filter(entry, ctx)
  if ctx.symbols_filter == nil then
    ctx.symbols_filter = LazyVim.config.get_kind_filter(ctx.bufnr) or false
  end
  if ctx.symbols_filter == false then
    return true
  end
  return vim.tbl_contains(ctx.symbols_filter, entry.kind)
end

return {

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanso",
    },
  },

  {
    "webhooked/kanso.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      background = {
        dark = "mist",
        light = "pearl",
      },
      foreground = "saturated",
      dimInactive = true,
      overrides = function(colors)
        return {
          LspReferenceText = { bg = colors.palette.pearlBlue1 },
          LspReferenceWrite = { bg = colors.palette.pearlBlue1, underline = true },
        }
      end,
    },
  },

  -- buffer tabs don't belong in vim
  { "akinsho/bufferline.nvim", enabled = false },

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "<c-k>", mode = "i", false }

      -- use <leader>gd or gD to open definitions in fzf
      -- useful to preview & split
      keys[#keys + 1] = {
        "<leader>gd",
        "<cmd>FzfLua lsp_definitions ignore_current_line=true<cr>",
        desc = "Goto Definition (list)",
        has = "definition",
      }
      keys[#keys + 1] = {
        "gD",
        "<cmd>FzfLua lsp_definitions ignore_current_line=true jump_to_single_result=false<cr>",
        desc = "Goto Definition (list)",
        has = "definition",
      }

      -- make ruby_lsp play nice with rbenv
      opts.servers["ruby_lsp"] = {
        mason = false,
        cmd = { vim.fn.expand("~/.rbenv/shims/ruby-lsp") },
      }

      opts.servers["vtsls"] = {
        settings = {
          typescript = {
            tsserver = {
              maxTsServerMemory = 8192,
            },
          },
        },
      }

      opts.diagnostics.underline = false
    end,
  },

  -- autocomplete keymap overrides
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "super-tab",
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<Tab>"] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          "snippet_forward",
          "fallback",
        },
      },
    },
  },

  -- hella lualine customizations
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
          {
            function()
              return require("nvim-navic").get_location()
            end,
            cond = function()
              return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
            end,
          },
        },
        lualine_x = {
          {
            function()
              return require("noice").api.status.mode.get()
            end,
            cond = function()
              return package.loaded["noice"] and require("noice").api.status.mode.has()
            end,
            color = function()
              return Snacks.util.color("TSConstant")
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
              return Snacks.util.color("TSComment")
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

  -- motions for indentation
  -- [- / ]- to go to previous/next line with less indentation
  -- [+ / ]+ to go to previous/next line with more indentation
  -- [= / ]= to go to previous/next line with equal indentation
  { "jeetsukumaran/vim-indentwise" },

  -- disable neo-tree, use nvim-tree instead
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },

  -- way faster than neo-tree
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    opts = {
      view = {
        width = 40,
      },
      filesystem_watchers = {
        ignore_dirs = {
          "node_modules",
          "vendor",
        },
      },
      git = {
        timeout = 2000,
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

  {
    "ibhagwan/fzf-lua",
    opts = {
      winopts = {
        -- blank border just serves as floating window padding
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
        ";",
        -- combine buffers and files
        function()
          local cmd = ""
          local buffers = {}
          for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(bufnr) then
              local bufname = vim.api.nvim_buf_get_name(bufnr)
              if
                bufname ~= ""
                and bufname ~= nil
                and vim.api.nvim_buf_is_loaded(bufnr)
                and vim.api.nvim_buf_get_option(bufnr, "buflisted")
              then
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
        desc = "Find buffers & files",
      },
      {
        "<leader><leader>",
        function()
          require("fzf-lua").resume()
        end,
        desc = "Open last picker",
      },
      {
        "<leader>k",
        function()
          require("fzf-lua").grep_cword()
        end,
        desc = "Grep cword",
      },
      {
        "'",
        function()
          require("fzf-lua").lsp_document_symbols({ regex_filter = symbols_filter })
        end,
        desc = "Document symbols",
      },
      {
        "<leader>/",
        function()
          require("fzf-lua").live_grep_glob()
        end,
        desc = "Grep (root dir)",
      },
    },
  },

  -- override change surround keymap
  {
    "nvim-mini/mini.surround",
    opts = {
      mappings = {
        replace = "cs",
      },
    },
  },

  -- gimme back my s key
  {
    "folke/flash.nvim",
    keys = {
      { "s", false },
    },
  },

  -- git blame pane (<leader>gb)
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

  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   config = function(_, opts)
  --     if type(opts.ensure_installed) == "table" then
  --       opts.ensure_installed = LazyVim.dedup(opts.ensure_installed)
  --     end
  --     require("nvim-treesitter.install").compilers = { "gcc-6", "gcc", "clang++", "clang" }
  --     -- require("nvim-treesitter.configs").setup(opts)
  --   end,
  -- },

  -- automatic indentation detection, etc
  { "tpope/vim-sleuth" },

  -- vim + tmux split navigation
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

  -- only show cursorline in active buffer
  {
    "tummetott/reticle.nvim",
    config = true,
  },

  -- gaip= to align stuff with the = sign
  {
    "nvim-mini/mini.align",
    version = false,
    config = true,
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        php = { "phpcbf" },
      },
    },
  },
}
