return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    input = { enabled = true },
    rename = { enabled = true },
    zen = {
      toggles = {
        dim = false,
      },
      zoom = {
        win = {
          width = 350,
        },
      },
    },
  },
  init = function()
    vim.keymap.set('n', '<leader>tz', function()
      Snacks.zen.zen()
    end, { desc = 'Toggle ZenMode', silent = true })
  end,
}
