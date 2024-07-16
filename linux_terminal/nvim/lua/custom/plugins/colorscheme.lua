return {
  'folke/tokyonight.nvim',
  lazy = false,
  priority = 1000,
  opts = {
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
  },
  init = function()
    vim.cmd [[colorscheme tokyonight]]
  end,
}
