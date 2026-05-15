vim.pack.add({
  {
    src = 'https://github.com/mrcjkb/rustaceanvim',
    version = vim.version.range('^9'),
  },
})

vim.g.rustaceanvim = function()
  local mason_path = vim.fn.glob(vim.fn.stdpath('data') .. '/mason/')
  local codelldb_path = mason_path .. 'bin/codelldb'
  local liblldb_path = mason_path .. 'packages/codelldb/extension/lldb/lib/liblldb'
  local this_os = vim.loop.os_uname().sysname

  if this_os:find 'Windows' then
    codelldb_path = mason_path .. 'packages\\codelldb\\extension\\adapter\\codelldb.exe'
    liblldb_path = mason_path .. 'packages\\codelldb\\extension\\lldb\\bin\\liblldb.dll'
  else
    -- The liblldb extension is .so for linux and .dylib for macOS
    liblldb_path = liblldb_path .. (this_os == 'Linux' and '.so' or '.dylib')
  end

  local cfg = require('rustaceanvim.config')
  return {
    dap = {
      adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
    },
    tools = {
      executor = require('rustaceanvim.executors').termopen, -- can be quickfix or termopen
      reload_workspace_from_cargo_toml = true,
      enable_clippy = false,
    },
    server = {
      on_attach = function(client, bufnr)
        require('which-key').add({
          { '<leader>c', group = 'RustCoding' },
          { '<leader>cc', '<cmd>RustLsp openCargo<Cr>', desc = 'Open Cargo' },
          { '<leader>cd', '<cmd>RustLsp debuggables<Cr>', desc = 'Debuggables' },
          { '<leader>cm', '<cmd>RustLsp expandMacro<Cr>', desc = 'Expand Macro' },
          { '<leader>co', '<cmd>RustLsp openDocs<Cr>', desc = 'Open External Docs' },
          { '<leader>cr', '<cmd>RustLsp runnables<Cr>', desc = 'Runnables' },
          { '<leader>ct', '<cmd>RustLsp testables<cr>', desc = 'Cargo Test' },
          { '<leader>cv', '<cmd>RustLsp crateGraph<Cr>', desc = 'View Crate Graph' },
        }, { bufn = bufnr })
        if client:supports_method('textDocument/codeLens') then
          vim.lsp.codelens.enable(true, { bufnr = bufnr })
          vim.api.nvim_create_autocmd('BufWritePost', {
            buffer = bufnr,
            callback = function()
              vim.lsp.codelens.enable(true, { bufnr = bufnr })
            end,
          })
        end
      end,
      default_settings = {
        ['rust-analyzer'] = {
          checkOnSave = true,
          check = {
            command = 'clippy',
          },
          diagnostics = {
            enable = true,
          },
          lens = {
            enable = true,
          },
          completion = {
            callable = {
              snippets = 'fill_arguments',
            },
          },
          inlayHints = {
            enable = true,
            showParameterNames = true,
          },
        },
      },
    },
  }
end
