return {
  'akinsho/toggleterm.nvim',
  -- See :help toggleterm
  version = '*',
  init = function()
    require('toggleterm').setup({
      direction = 'float',
      float_opts = {
        size = 20,
        -- The border key is *almost* the same as 'nvim_win_open'
        -- see :h nvim_win_open for details on borders however
        -- the 'curved' border is a custom border type
        -- not natively supported but implemented in this plugin.
        -- border = 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
        border = 'curved',
        -- width = <value>,
        -- height = <value>,
        winblend = 0,
        highlights = {
          border = 'Normal',
          background = 'Normal',
        },
      },
      open_mapping = '<C-t>',
    })
  end,
}
