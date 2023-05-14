return {

  {
    'tpope/vim-fugitive',
    dependencies = {
      'tpope/vim-rhubarb'
    }
  },

  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local opts = { buffer = bufnr }
        vim.keymap.set('n', ']c', function() gs.next_hunk() end, opts)
        vim.keymap.set('n', '[c', function() gs.prev_hunk() end, opts)
        vim.keymap.set('n', '<Leader>hr', function() gs.reset_hunk() end, opts)
        vim.keymap.set('n', '<Leader>hb', function() gs.blame_line({ full = true }) end, opts)
      end
    }
  }

}
