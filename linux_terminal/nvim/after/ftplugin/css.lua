vim.lsp.document_color.enable(true, nil, { style = 'virtual' })
local bufnr = vim.api.nvim_get_current_buf()

print('ciccciao')

local utils = require('utils')
local register_normal = utils.create_keymap_setter('n')

register_normal(
  '<leader>cp',
  'Open CSS color presentation',
  vim.lsp.document_color.color_presentation
)
