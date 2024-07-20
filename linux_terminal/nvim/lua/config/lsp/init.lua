-- Style lsp windows
local ts_builtin = require('telescope.builtin')

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = 'rounded',
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

  require('which-key').add({
    { "<leader>l",  group = "Lsp and Diagnostic actions", remap = false },
    { "<leader>la", vim.lsp.buf.code_action,              desc = "Code Action",                    remap = false },
    { "<leader>le", vim.diagnostic.open_float,            desc = "Diagnostic message",             remap = false },
    { "<leader>ll", vim.lsp.codelens.run,                 desc = "CodeLens",                       remap = false },
    { "<leader>lq", vim.diagnostic.setqflist,             desc = "Open diagnostics quickfix list", remap = false },
    { "<leader>lr", vim.lsp.buf.rename,                   desc = "Rename symbol",                  remap = false },
    { "<leader>w",  group = "Workspace",                  remap = false },
    { "<leader>wa", vim.lsp.buf.add_workspace_folder,     desc = "Add folder",                     remap = false },
    {
      "<leader>wl",
      function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end,
      desc = "List folders",
      remap = false
    },
    { "<leader>wr", vim.lsp.buf.remove_workspace_folder,      desc = "Remove folder",             remap = false },
    { "<leader>ws", ts_builtin.lsp_dynamic_workspace_symbols, desc = "All workspaces symbols",    remap = false },
    { "<leader>wS", ts_builtin.lsp_document_symbols,          desc = "Current workspace symbols", remap = false },
  })

  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('gt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('J', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })

  local caps = client.server_capabilities

  -- Enable completion triggered by <C-x><C-o> in insert mode
  -- See `:help omnifunc` and `:help ins-completion` for more information.
  if caps.completionProvider then
    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
  end

  -- Use LSP as the handler for formatexpr.
  -- See `:help formatexpr` for more information.
  if caps.documentFormattingProvider then
    vim.bo[bufnr].formatexpr = 'v:lua.vim.lsp.formatexpr()'
  end

  if vim.lsp.inlay_hint and caps.inlayHintProvider then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    nmap('<leader>th', function()
      local next_hint_config = not vim.lsp.inlay_hint.is_enabled()
      print('Setting inlay_hint to: ' .. tostring(next_hint_config))
      vim.lsp.inlay_hint.enable(next_hint_config)
    end, 'Toggle Inlay Hints')
  end
end

-- enable inlay_hints globally
vim.lsp.inlay_hint.enable(true)

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities =
    vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

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
  -- https://github.com/OmniSharp/omnisharp-roslyn/wiki/Configuration-Options
  omnisharp = {
    cmd = { 'omnisharp' },
    settings = {
      FormattingOptions = {
        OrganizeImports = true,
      },
      RoslynExtensionsOptions = {
        EnableAnalyzersSupport = true,
        EnableImportCompletion = true,
      },
      MsBuild = {
        LoadProjectsOnDemand = false,
      },
    },
  },
  rust_analyzer = {
    settings = {
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
    },
  },
  lua_ls = {
    options = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
        hint = { enable = true },
      },
    },
  },
  gopls = {
    settings = {
      gopls = {
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
      },
      -- could be responsible of not working well on windows
      cmd = {
        'gopls', -- share the gopls instance if there is one already
        '-remote.debug=:0',
      },
    },
  },
  pyright = {
    settings = {
      pyright = {
        disableOrganizeImports = true,
      },
      python = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = 'workspace',
          useLibraryCodeForTypes = true,
          typeCheckingMode = 'basic',
        },
      },
    },
  },
  ruff_lsp = {
    settings = {
      -- Any extra CLI arguments for `ruff` go here.
      args = {},
    },
  },
  lemminx = {
    settings = {
      xml = { catalogs = { './catalog.xml' } },
    },
  },
  bashls = {},
  docker_compose_language_service = {},
  dockerls = {},
  html = {
    filetypes = { 'html', 'templ', 'htmldjango' },
  },
  htmx = {
    filetypes = { 'html', 'templ', 'htmldjango' },
  },
  tailwindcss = {
    init_options = {
      userLanguages = {
        rust = 'html',
      },
    },
    filetypes = { 'html', 'templ', 'htmldjango', 'rust', 'typescriptreact', 'javascriptreact' },
    settings = {
      tailwindCSS = {
        emmetCompletions = true,
      },
    },
    root_dir = require 'lspconfig'.util.root_pattern(
      'tailwind.config.js',
      'tailwind.config.ts',
      'postcss.config.js',
      'postcss.config.ts'
    ),
  },
  zls = {},
  -- https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
  emmet_ls = {
    filetypes = {
      'css',
      'eruby',
      'html',
      'htmldjango',
      'javascript',
      'javascriptreact',
      'less',
      'sass',
      'scss',
      'svelte',
      'pug',
      'typescriptreact',
      'vue',
    },
    init_options = {
      html = {
        options = {
          -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
          ['bem.enabled'] = true,
        },
      },
    },
  },
  jsonls = {},
  marksman = {},
  sqlls = {},
  yamlls = {
    yaml = {
      format = {
        enable = true,
        singleQuote = true,
      },
    },
    hover = true,
    completion = true,
    validate = true,
    keyOrdering = true,
  },
  tsserver = {
    settings = {
      javascript = {
        inlayHints = {
          includeInlayEnumMemberValueHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayParameterNameHints = 'all', -- 'none' | 'literals' | 'all';
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayVariableTypeHints = true,
        },
      },
      typescript = {
        inlayHints = {
          includeInlayEnumMemberValueHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayParameterNameHints = 'all', -- 'none' | 'literals' | 'all';
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayVariableTypeHints = true,
        },
      },
    },
  },
}

-- Ensure the servers above are installed
local mason_lspconfig = require('mason-lspconfig')

mason_lspconfig.setup({
  ensure_installed = vim.tbl_keys(servers),
})

local lspconfig = require('lspconfig')

mason_lspconfig.setup_handlers({
  function(server_name)
    local opts = vim.tbl_deep_extend('force', server_opts, servers[server_name] or {})
    lspconfig[server_name].setup(opts)
  end,
  ['lua_ls'] = function()
    local opts = vim.tbl_deep_extend('force', server_opts, servers['lua_ls'] or {})
    require('neodev').setup({})
    lspconfig.lua_ls.setup(opts)
  end,
  ['gopls'] = function()
    local opts = vim.tbl_deep_extend('force', server_opts, servers['gopls'] or {})
    local go = require('config.lsp.go')
    go.setup(go.customize_opts(opts))
  end,
  ['rust_analyzer'] = function()
    local opts = vim.tbl_deep_extend('force', server_opts, servers['rust_analyzer'] or {})
    local rust = require('config.lsp.rust')
    rust.setup(rust.customize_opts(opts))
  end,
  ['pyright'] = function()
    local opts = vim.tbl_deep_extend('force', server_opts, servers['pyright'] or {})
    local python = require('config.lsp.python')
    python.setup(python.customize_opts(opts))
  end,
})
