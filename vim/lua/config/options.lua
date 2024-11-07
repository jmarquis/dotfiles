-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.autowrite = false
vim.opt.clipboard = ""
vim.opt.relativenumber = false
vim.opt.laststatus = 2
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.ttimeoutlen = 0

-- show invisibles
vim.opt.listchars = "eol:¬,tab:>·,extends:>,precedes:<,trail:·"

-- only run prettier when there's a config file
vim.g.lazyvim_prettier_needs_config = true

vim.g.lazyvim_php_lsp = "intelephense"

vim.g.lazyvim_picker = "fzf"
