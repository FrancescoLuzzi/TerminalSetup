return {
  'mrcjkb/rustaceanvim',
  version = '^5', -- Recommended
  lazy = false,   -- This plugin is already lazy
  config = function()
    vim.g.rustaceanvim = function()
      -- Update this path
      local extension_path = vim.env.HOME .. '/.vscode/extensions/vadimcn.vscode-lldb-1.10.0/'
      local codelldb_path = extension_path .. 'adapter/codelldb'
      local liblldb_path = extension_path .. 'lldb/lib/liblldb'
      local this_os = vim.uv.os_uname().sysname;

      -- The path is different on Windows
      if this_os:find "Windows" then
        codelldb_path = extension_path .. "adapter\\codelldb.exe"
        liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
      else
        -- The liblldb extension is .so for Linux and .dylib for MacOS
        liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
      end

      local cfg = require('rustaceanvim.config')
      return {
        dap = {
          adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
        },
        server = {
          capabilities = vim.lsp.protocol.make_client_capabilities(),
          cmd = function()
            local mason_registry = require('mason-registry')
            if mason_registry.is_installed('rust-analyzer') then
              -- This may need to be tweaked depending on the operating system.
              local ra = mason_registry.get_package('rust-analyzer')
              local ra_filename = ra:get_receipt():get().links.bin['rust-analyzer']
              return { ('%s/%s'):format(ra:get_install_path(), ra_filename or 'rust-analyzer') }
            else
              return { 'rust-analyzer' }
            end
          end,
          on_attach = function(client, bufnr)
            require('which-key').add({
              { '<leader>c',  group = 'RustCoding' },
              { '<leader>cc', '<cmd>RustLsp openCargo<Cr>',   desc = 'Open Cargo' },
              { '<leader>cd', '<cmd>RustLsp debuggables<Cr>', desc = 'Debuggables' },
              { '<leader>cm', '<cmd>RustLsp expandMacro<Cr>', desc = 'Expand Macro' },
              { '<leader>co', '<cmd>RustLsp openDocs<Cr>',    desc = 'Open External Docs' },
              { '<leader>cr', '<cmd>RustLsp runnables<Cr>',   desc = 'Runnables' },
              { '<leader>ct', '<cmd>RustLsp testables<cr>',   desc = 'Cargo Test' },
              { '<leader>cv', '<cmd>RustLsp crateGraph<Cr>',  desc = 'View Crate Graph' },
            }, { bufn = bufnr })
          end,
          tools = {
            executor = require('rustaceanvim.executors').termopen, -- can be quickfix or termopen
            reload_workspace_from_cargo_toml = true,
            runnables = {
              use_telescope = true,
            },
            enable_clippy = false,
            on_initialized = function()
              vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufEnter', 'CursorHold', 'InsertLeave' }, {
                pattern = { '*.rs' },
                callback = function()
                  local _, _ = pcall(vim.lsp.codelens.refresh)
                end,
              })
            end,
          },
          default_settings = {
            ['rust-analyzer'] = {
              checkOnSave = {
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
          }
        }
      }
    end
  end
}
