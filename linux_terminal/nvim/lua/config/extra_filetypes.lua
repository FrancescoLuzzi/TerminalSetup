local augroup = vim.api.nvim_create_augroup('kickstart-filetype-detect', { clear = true })
vim.api.nvim_create_autocmd(
  { "BufEnter", "BufWinEnter" },
  {
    group = augroup,
    pattern = { "*.dproj", "*.groupproj" },
    command = "set filetype=xml",
  }
)
