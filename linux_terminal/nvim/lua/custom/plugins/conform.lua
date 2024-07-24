return {
  'stevearc/conform.nvim',
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      -- Conform will run multiple formatters sequentially
      go = { 'goimports', 'gofmt' },
      -- Use a sub-list to run only the first available formatter
      javascript = { { 'prettierd', 'prettier' } },
      typescript = { { 'prettierd', 'prettier' } },
      javascriptreact = { { 'prettierd', 'prettier' } },
      typescriptreact = { { 'prettierd', 'prettier' } },
      -- You can use a function here to determine the formatters dynamically
      -- rust = { 'rust-analizer' },
      -- for python just use ruff-lsp, the new GOAT
      -- python = function(bufnr)
      --   if require('conform').get_formatter_info('ruff_format', bufnr).available then
      --     return { 'ruff_format' }
      --   else
      --     return { 'isort', 'black' }
      --   end
      -- end,
      -- Use the "*" filetype to run formatters on all filetypes.
      -- ['*'] = { 'codespell' },
      -- Use the "_" filetype to run formatters on filetypes that don't
      -- have other formatters configured.
      ['_'] = { 'trim_whitespace' },
    },
    -- If this is set, Conform will run the formatter on save.
    -- It will pass the table to conform.format().
    -- This can also be a function that returns the table.
    format_on_save = function()
      -- I recommend these options. See :help conform.format for details.
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat then
        return
      end
      return { timeout_ms = 500, lsp_fallback = true }
    end,
  },
  init = function()
    vim.g.disable_autoformat = false
    vim.api.nvim_create_user_command('FormatToggle', function()
      vim.g.disable_autoformat = not vim.g.disable_autoformat
      print('Setting autoformatting to: ' .. tostring(not vim.g.disable_autoformat))
    end, {})
    vim.keymap.set(
      'n',
      '<leader>tf',
      ':FormatToggle<CR>',
      { desc = 'Toggle Formatting', silent = true }
    )
  end,
}
