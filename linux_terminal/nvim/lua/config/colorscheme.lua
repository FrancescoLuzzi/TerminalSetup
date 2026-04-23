vim.pack.add({
  {
    src = 'https://github.com/folke/tokyonight.nvim',
    version = vim.version.range('1.*'),
  },
})

local tk_night = require('tokyonight')
tk_night.setup({
  transparent = true,
  styles = {
    sidebars = 'transparent',
    floats = 'normal',
  },
  on_highlights = function(hl, c)
    hl.TelescopeBorder = { fg = c.border_highlight, bg = c.none }
    hl.TelescopeNormal = { fg = c.fg, bg = c.none }
    hl.TelescopePromptBorder = { fg = c.orange, bg = c.none }
    hl.TelescopePromptTitle = { fg = c.orange, bg = c.none }
    hl.MiniIndentscopeSymbol = {
      fg = c.comment,
      nocombine = true,
    }
  end,
})

vim.cmd('colorscheme tokyonight')
