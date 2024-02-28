return {
  'stevearc/dressing.nvim',
  opts = {},
  init = function()
    require('dressing').setup({
      input = {
        enabled = true,
        position = '50%',
        relative = 'editor',
        width = 0.5,
        start_in_insert = false,
        win_options = {
          sidescrolloff = 4,
          winblend = 0,
        },
      },
    })
  end,
}
