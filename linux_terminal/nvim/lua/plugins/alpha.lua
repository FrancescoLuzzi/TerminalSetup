vim.pack.add({
  {
    src = 'https://github.com/goolord/alpha-nvim',
    version = 'main',
  },
})

local utils = require('utils')

vim.api.nvim_set_hl(0, 'AlphaHeader', { ctermbg = 0, fg = '#9d7cd8' })

-- Define your custom commands
utils.create_usrcmd('FindFiles', function()
  Snacks.picker.files()
end)
utils.create_usrcmd('FindRecent', function()
  Snacks.picker.recent()
end)
utils.create_usrcmd('FindGrep', function()
  Snacks.picker.grep()
end)

local dashboard = require('alpha.themes.dashboard')
local logo = [[
███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗
████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║
██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║
██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║
██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║
╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝

  ]]
-- Resolve $MYVIMRC's parent folder, that could be a symlink
local vimrc_dir = vim.fn.resolve(vim.fn.fnamemodify(vim.fn.expand('$MYVIMRC'), ':h:p'))

dashboard.section.header.val = vim.split(logo, '\n')
dashboard.section.buttons.val = {
  dashboard.button('f', ' ' .. ' Find file', ':FindFiles <CR>'),
  dashboard.button('n', ' ' .. ' New file', ':ene <BAR> startinsert <CR>'),
  dashboard.button('r', ' ' .. ' Recent files', ':FindRecent <CR>'),
  dashboard.button('g', ' ' .. ' Find text', ':FindGrep <CR>'),
  dashboard.button('c', ' ' .. ' Config', ':cd ' .. vimrc_dir .. ' <BAR> e $MYVIMRC <CR>'),
  dashboard.button('q', ' ' .. ' Quit', ':qa<CR>'),
}

dashboard.section.header.opts.hl = 'AlphaHeader'
dashboard.opts.layout[1].val = 8
require('alpha').setup(dashboard.opts)
