vim.pack.add({
  {
    src = 'https://github.com/goolord/alpha-nvim',
    version = 'main',
  },
})

vim.api.nvim_set_hl(0, 'AlphaHeader', { ctermbg = 0, fg = '#9d7cd8' })

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
  dashboard.button('f', ' ' .. ' Find file', ':Telescope find_files <CR>'),
  dashboard.button('n', ' ' .. ' New file', ':ene <BAR> startinsert <CR>'),
  dashboard.button('r', ' ' .. ' Recent files', ':Telescope oldfiles <CR>'),
  dashboard.button('g', ' ' .. ' Find text', ':Telescope live_grep <CR>'),
  dashboard.button('c', ' ' .. ' Config', ':cd ' .. vimrc_dir .. ' <BAR> e $MYVIMRC <CR>'),
  dashboard.button('l', '󰒲 ' .. ' Lazy', ':Lazy<CR>'),
  dashboard.button('q', ' ' .. ' Quit', ':qa<CR>'),
}

dashboard.section.header.opts.hl = 'AlphaHeader'
dashboard.opts.layout[1].val = 8
require('alpha').setup(dashboard.opts)
