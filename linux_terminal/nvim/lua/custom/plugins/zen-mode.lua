return {
  "folke/zen-mode.nvim",
  opts = {
    window = {
      width = .65
    }
  },
  init = function ()
    vim.keymap.set(
      'n',
      '<leader>tz',
      ':ZenMode<CR>',
      { desc = 'Toggle Formatting', silent = true }
    )
  end
}
