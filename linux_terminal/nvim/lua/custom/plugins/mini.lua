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
      -- symbol = '┊',
      symbol = '▏',
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
    -- disable mini.indentscope for selected filetypes
    -- https://github.com/echasnovski/mini.nvim/issues/144#issuecomment-2164874307
    local augroup = vim.api.nvim_create_augroup('MiniIndentScopeDisable', { clear = true })
    vim.api.nvim_create_autocmd('FileType', {
      group = augroup,
      pattern = disabled_filetypes,
      callback = function(opts)
        vim.b[opts.buf].miniindentscope_disable = true
      end,
    })
    -- disable mini.indentscope in helper floating window
    -- https://github.com/echasnovski/mini.nvim/discussions/962#discussioncomment-9760338
    vim.api.nvim_create_autocmd('BufWinEnter', {
      group = augroup,
      callback = function(opts)
        if vim.bo[opts.buf].buftype == '' then return end
        if vim.api.nvim_win_get_config(0).relative == '' then return end
        vim.b[opts.buf].miniindentscope_disable = true
      end
    })
  end,
}
