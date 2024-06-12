return {
  'echasnovski/mini.nvim',
  version = false,
  init = function()
    local indentscope = require('mini.indentscope')
    indentscope.setup({
      draw = {
        delay = 0,
        animation = indentscope.gen_animation.none(),
      },
      symbol = '┊',
    })
    local disabled_filetypes = {
      'alpha',
      'help',
      'Trouble',
      'trouble',
      'lazy',
      'mason',
      'toggleterm',
      'NvimTree',
    }
    local autogroup = vim.api.nvim_create_augroup('MiniIndentScopeDisable', { clear = true })
    vim.api.nvim_create_autocmd('FileType', {
      group = autogroup,
      pattern = disabled_filetypes,
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })
  end,
}
