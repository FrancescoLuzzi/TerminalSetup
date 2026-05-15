vim.pack.add({
  {
    src = 'https://github.com/folke/which-key.nvim',
    version = 'main',
  },
})

local which_key = require('which-key')

local keymaps = {}

keymaps.add = which_key.add

return keymaps
