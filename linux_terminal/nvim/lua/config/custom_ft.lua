local utils = require('utils')

local ft_group = utils.create_augroup('CustomFileTypes')

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  group = ft_group,
  pattern = { '*.dproj', '*.groupproj' },
  callback = function()
    vim.opt_local.filetype = 'xml'
  end,
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  group = ft_group,
  pattern = { 'docker-compose.yaml', 'docker-compose.yml' },
  callback = function()
    vim.opt_local.filetype = 'yaml.docker-compose'
  end,
})
