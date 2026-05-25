vim.cmd('packadd nvim.undotree')

local utils = require('utils')
local register_normal = utils.create_keymap_setter('n')

register_normal('<leader>u', 'Open undotree', require('undotree').open)
