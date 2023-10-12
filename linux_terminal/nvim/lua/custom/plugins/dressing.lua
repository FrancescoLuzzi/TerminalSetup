return {
  'stevearc/dressing.nvim',
  opts = {},
  init = function()
    require("dressing").setup({
      input = {
        enabled = true,
        start_in_insert = false,
        win_options = {
          winblend = 0,
          wrap = true,
        },
      },
      select = {
        enabled = false,
      },
    })
  end
}
