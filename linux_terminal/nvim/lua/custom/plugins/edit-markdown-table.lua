return {
  'kiran94/edit-markdown-table.nvim',
  config = true,
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  cmd = 'EditMarkdownTable',
  init = function()
    vim.keymap.set(
      'n',
      '<leader>te',
      ':EditMarkdownTable<CR>',
      { desc = '[T]oggle Markdown [E]dit', silent = true }
    )
  end,
}
