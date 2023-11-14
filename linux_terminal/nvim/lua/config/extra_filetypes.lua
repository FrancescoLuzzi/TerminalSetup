local augroup = function(name)
  return vim.api.nvim_create_augroup('kickstart-filetype-detect_' .. name, { clear = true })
end
vim.api.nvim_create_autocmd(
  { "BufEnter", "BufWinEnter" },
  {
    group = augroup("dproj"),
    pattern = { "*.dproj", "*.groupproj" },
    callback = function()
      vim.opt_local.filetype = "xml"
    end
  }
)

vim.api.nvim_create_autocmd(
  { "BufEnter", "BufWinEnter" },
  {
    group = augroup("docker_compose"),
    pattern = { "docker-compose.yaml", "docker-compose.yml" },
    callback = function()
      vim.opt_local.filetype = "yaml.docker-compose"
    end
  }
)

-- autoformatting

-- Remove trailing whitespaces on save.
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-format-remove_trailing_whitespaces', { clear = true }),
  pattern = '*',
  callback = function(args)
    local clients = vim.lsp.get_active_clients({ bufnr = args.buf })
    local _, client = next(clients)
    if client == nil or not client.server_capabilities.documentFormattingProvider then
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      vim.cmd [[%s/\s\+$//e]]
      local lastline = vim.fn.line('$')
      if line > lastline then
        line = lastline
      end
      local lastcol = vim.fn.col('$')
      if col > lastcol then
        col = lastcol
      end
      vim.api.nvim_win_set_cursor(0, { line, col })
    end
  end
})
