-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.autowrite = false
vim.opt.clipboard = ""
vim.opt.relativenumber = false
vim.opt.laststatus = 2

-- show invisibles
vim.opt.listchars = "eol:¬,tab:>·,extends:>,precedes:<,trail:·"

-- only run prettier when there's a config file
vim.g.lazyvim_prettier_needs_config = true

vim.g.lazyvim_php_lsp = "intelephense"

-- cursorline only for active window
vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufWinEnter" }, {
  callback = function()
    if vim.bo[vim.api.nvim_get_current_buf()].filetype ~= "TelescopePrompt*" then
      vim.opt_local.cursorline = true
    end
  end,
})
vim.api.nvim_create_autocmd("WinLeave", {
  callback = function()
    vim.opt_local.cursorline = false
  end,
})
