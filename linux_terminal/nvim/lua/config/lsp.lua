local function rust_analizer_on_attach(server_opts)
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
  dap.configurations.rust = {
    {
      name = "Launch file",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input('Path to executable: ' ..
          vim.fn.getcwd() .. '/' .. 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
    },
  }

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

  require('which-key').register({
    r = {
      name = "Rust",
      r = { "<cmd>RustRunnables<Cr>", "Runnables" },
      t = { "<cmd>lua _CARGO_TEST()<cr>", "Cargo Test" },
      m = { "<cmd>RustExpandMacro<Cr>", "Expand Macro" },
      c = { "<cmd>RustOpenCargo<Cr>", "Open Cargo" },
      p = { "<cmd>RustParentModule<Cr>", "Parent Module" },
      d = { "<cmd>RustDebuggables<Cr>", "Debuggables" },
      v = { "<cmd>RustViewCrateGraph<Cr>", "View Crate Graph" },
      R = {
        "<cmd>lua require('rust-tools/workspace_refresh')._reload_workspace_from_cargo_toml()<Cr>",
        "Reload Workspace",
      },
      o = { "<cmd>RustOpenExternalDocs<Cr>", "Open External Docs" },
      y = { "<cmd>lua require'crates'.open_repository()<cr>",
        "[crates] open repository" },
      P = { "<cmd>lua require'crates'.show_popup()<cr>", "[crates] show popup" },
      i = { "<cmd>lua require'crates'.show_crate_popup()<cr>", "[crates] show info" },
      f = { "<cmd>lua require'crates'.show_features_popup()<cr>",
        "[crates] show features" },
      D = { "<cmd>lua require'crates'.show_dependencies_popup()<cr>",
        "[crates] show dependencies" },
    }
  }, { prefix = "<leader>" })
end

-- Style lsp windows

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
  underline = true,
})

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader><leader>r', vim.lsp.buf.rename, '[R]ename')
  nmap('<leader><leader>a', vim.lsp.buf.code_action, 'Code [A]ction')
  nmap('<leader><leader>l', vim.lsp.codelens.run, 'Code [L]ens')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>wd', require('telescope.builtin').lsp_document_symbols, '[ ]Document [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('J', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })

  local caps = client.server_capabilities

  -- Enable completion triggered by <C-x><C-o> in insert mode
  -- See `:help omnifunc` and `:help ins-completion` for more information.
  if caps.completionProvider then
    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
  end

  -- Use LSP as the handler for formatexpr.
  -- See `:help formatexpr` for more information.
  if caps.documentFormattingProvider then
    vim.bo[bufnr].formatexpr = "v:lua.vim.lsp.formatexpr()"
  end

  if caps.inlayHintProvider then
    local ih = require('lsp-inlayhints')
    nmap('<leader>th', ih.toggle, '[T]oggle Inlay[H]ints')
    ih.on_attach(client, bufnr)
  end
end

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.

local server_opts = {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 150,
  },
}

local servers = {
  --[[
   clangd = {settings={}},
   gopls = {settings={}},
   pyright = {settings={}},
   tsserver = {settings={}},
  -- ]]

  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = {
          command = "clippy",
        },
        lens = {
          enable = true,
        },
        completion = {
          callable = {
            snippets = "fill_arguments"
          }
        }
      }
    }
  },
  lua_ls = {
    options = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      }
    }
  }
}

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'
local lspconfig = require "lspconfig"

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    local opts = vim.tbl_deep_extend("force", server_opts, servers[server_name] or {})
    lspconfig[server_name].setup(opts)
  end,
  ["lua_ls"] = function()
    local opts = vim.tbl_deep_extend("force", server_opts, servers["lua_ls"] or {})
    require("neodev").setup {}
    lspconfig.lua_ls.setup(opts)
  end,
  ["rust_analyzer"] = function()
    local opts = vim.tbl_deep_extend("force", server_opts, servers["rust_analyzer"] or {})
    rust_analizer_on_attach(opts)
  end,
}
