return {
  'folke/zen-mode.nvim',
  opts = {
    window = {
      width = 0.65,
    },
  },
  init = function()
    vim.keymap.set('n', '<leader>tz', ':ZenMode<CR>', { desc = 'Toggle ZenMode', silent = true })
  end,
}
