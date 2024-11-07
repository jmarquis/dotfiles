-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- move in insert mode
vim.keymap.set("i", "<c-h>", "<Left>")
vim.keymap.set("i", "<c-j>", "<Down>")
vim.keymap.set("i", "<c-k>", "<Up>")
vim.keymap.set("i", "<c-l>", "<Right>")

vim.keymap.del("i", "<A-j>")
vim.keymap.del("i", "<A-k>")
