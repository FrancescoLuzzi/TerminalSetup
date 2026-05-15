return {
  -- Highlight todo, notes, etc in comments
  'folke/todo-comments.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
  opts = { signs = false },
  init = function()
    vim.keymap.set(
      'n',
      '[t',
      require('todo-comments').jump_prev,
      { desc = 'Previous todo comment' }
    )
    vim.keymap.set('n', ']t', require('todo-comments').jump_next, { desc = 'Next todo comment' })
    vim.keymap.set('n', '<leader>st', '<cmd>TodoTelescope<cr>', { desc = 'Search all Todos' })
  end,
}
