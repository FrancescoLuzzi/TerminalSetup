local M = {}

local function configure_keymappings()
  require('which-key').register({
    c = {
      name = "RustCoding",
      c = { "<cmd>RustOpenCargo<Cr>", "Open Cargo" },
      D = { "<cmd>lua require'crates'.show_dependencies_popup()<cr>", "[crates] show dependencies" },
      d = { "<cmd>RustDebuggables<Cr>", "Debuggables" },
      f = { "<cmd>lua require'crates'.show_features_popup()<cr>", "[crates] show features" },
      i = { "<cmd>lua require'crates'.show_crate_popup()<cr>", "[crates] show info" },
      m = { "<cmd>RustExpandMacro<Cr>", "Expand Macro" },
      o = { "<cmd>RustOpenExternalDocs<Cr>", "Open External Docs" },
      P = { "<cmd>lua require'crates'.show_popup()<cr>", "[crates] show popup" },
      p = { "<cmd>RustParentModule<Cr>", "Parent Module" },
      R = { "<cmd>lua require('rust-tools/workspace_refresh')._reload_workspace_from_cargo_toml()<Cr>",
        "Reload Workspace", },
      r = { "<cmd>RustRunnables<Cr>", "Runnables" },
      t = { "<cmd>lua _CARGO_TEST()<cr>", "Cargo Test" },
      V = { "<cmd>lua require'crates'.show_versions_popup()<cr>", "[crates] show versions popup" },
      v = { "<cmd>RustViewCrateGraph<Cr>", "View Crate Graph" },
      y = { "<cmd>lua require'crates'.open_repository()<cr>", "[crates] open repository" },
    }
  }, { prefix = "<leader>" })
end

M.customize_opts = function(server_opts)
  local on_attach_orginal_func = server_opts["on_attach"]
  if on_attach_orginal_func == nil then
    server_opts["on_attach"] = configure_keymappings
  else
    server_opts["on_attach"] = function(client, bufnr)
      on_attach_orginal_func(client, bufnr)
      configure_keymappings()
    end
  end
  return server_opts
end

M.setup = function(server_opts)
  local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")

  local codelldb_path = mason_path .. "bin/codelldb"
  local liblldb_path = mason_path .. "packages/codelldb/extension/lldb/lib/liblldb"
  local this_os = vim.loop.os_uname().sysname

  -- The path in windows is different
  if this_os:find "Windows" then
    codelldb_path = mason_path .. "packages\\codelldb\\extension\\adapter\\codelldb.exe"
    liblldb_path = mason_path .. "packages\\codelldb\\extension\\lldb\\bin\\liblldb.dll"
  else
    -- The liblldb extension is .so for linux and .dylib for macOS
    liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
  end

  local dap = require('dap')

  require("rust-tools").setup({
    tools = {
      executor = require("rust-tools/executors").termopen, -- can be quickfix or termopen
      reload_workspace_from_cargo_toml = true,
      runnables = {
        use_telescope = true,
      },
      inlay_hints = {
        auto = false,
      },
      on_initialized = function()
        vim.api.nvim_create_autocmd(
          { "BufWritePost", "BufEnter", "CursorHold", "InsertLeave" }, {
            pattern = { "*.rs" },
            callback = function()
              local _, _ = pcall(vim.lsp.codelens.refresh)
            end,
          })
      end,
    },
    dap = {
      -- adapter= codelldb_adapter,
      adapter = require("rust-tools.dap").get_codelldb_adapter(
        codelldb_path,
        liblldb_path
      ),
    },
    server = server_opts,
  })

  dap.adapters.codelldb = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
  dap.configurations.rust = {
    {
      name = "Launch file",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input('Path to executable: ' ..
          vim.fn.getcwd() .. '/')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
    },
  }
end

return M
