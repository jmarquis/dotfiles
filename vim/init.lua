require "user.plugins"

-- don't close buffers when switching
vim.opt.hidden = true

-- use comma as leader
vim.g.mapleader = ","

-- colorscheme setup
vim.opt.background = "dark"
vim.opt.termguicolors = true

-- cursorline only for active window
vim.api.nvim_create_autocmd({ 'VimEnter', 'WinEnter', 'BufWinEnter' }, {
  callback = function()
    if vim.bo[vim.api.nvim_get_current_buf()].filetype ~= "TelescopePrompt" then
      vim.opt_local.cursorline = true
    end
  end
})
vim.api.nvim_create_autocmd('WinLeave', {
  callback = function()
    vim.opt_local.cursorline = false
  end
})

-- basic editing/navigation preferences
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
-- filetype plugin indent on
vim.opt.smartindent = true
vim.opt.number = true
vim.opt.showmatch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrap = false
vim.cmd([[ autocmd FileType php setl iskeyword+=$ ]])

-- start scrolling when the cursor is five spaces away from the edge of the screen
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5

-- navigate wrapped lines easier
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')

-- bindings for navigating splits
vim.keymap.set('n', '<C-J>', '<C-W><C-J>')
vim.keymap.set('n', '<C-K>', '<C-W><C-K>')
vim.keymap.set('n', '<C-L>', '<C-W><C-L>')
vim.keymap.set('n', '<C-H>', '<C-W><C-H>')

-- more intuitive split opening
vim.opt.splitbelow = true
vim.opt.splitright = true

-- faster CursorHold events
vim.opt.updatetime = 300

-- show invisibles
vim.opt.listchars = 'eol:¬,tab:>·,extends:>,precedes:<'
vim.opt.list = true
vim.opt.signcolumn = 'yes'

-- keep selection when changing indentation
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- alt + j/k to move lines
vim.keymap.set('n', '∆', ':m .+1<CR>==')
vim.keymap.set('n', '˚', ':m .-2<CR>==')
vim.keymap.set('i', '∆', '<Esc>:m .+1<CR>==gi')
vim.keymap.set('i', '˚', '<Esc>:m .-2<CR>==gi')
vim.keymap.set('v', '∆', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', '˚', ":m '<-2<CR>gv=gv")
