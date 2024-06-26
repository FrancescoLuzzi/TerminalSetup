return {
  'ziontee113/icon-picker.nvim',
  dependencies = {
    'stevearc/dressing.nvim',
  },
  config = function()
    require('icon-picker').setup({ disable_legacy_commands = true })

    local opts = { noremap = true, silent = true }

    vim.keymap.set('n', '<Leader><Leader>i', '<cmd>IconPickerNormal<cr>', opts)
  end,
}
