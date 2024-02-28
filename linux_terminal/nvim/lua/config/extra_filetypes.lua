local augroup = function(name)
  return vim.api.nvim_create_augroup('kickstart-filetype-detect_' .. name, { clear = true })
end
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  group = augroup('dproj'),
  pattern = { '*.dproj', '*.groupproj' },
  callback = function()
    vim.opt_local.filetype = 'xml'
  end,
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  group = augroup('docker_compose'),
  pattern = { 'docker-compose.yaml', 'docker-compose.yml' },
  callback = function()
    vim.opt_local.filetype = 'yaml.docker-compose'
  end,
})
