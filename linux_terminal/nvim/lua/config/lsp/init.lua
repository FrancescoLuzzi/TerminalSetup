-- Style lsp windows
local lspconfig = require('lspconfig')
local ts_builtin = require('telescope.builtin')

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = 'rounded',
  underline = true,
})

function Once(func)
  local called = false
  return function()
    if not called then
      called = true
      func()
    end
  end
end

local setup_keymaps = Once(function()
  require('which-key').add({
    { '<leader>l', group = 'Lsp and Diagnostic actions', remap = false },
    {
      '<leader>la',
      vim.lsp.buf.code_action,
      desc = 'Code Action',
      remap = false,
    },
    {
      '<leader>le',
      vim.diagnostic.open_float,
      desc = 'Diagnostic message',
      remap = false,
    },
    {
      '<leader>ll',
      vim.lsp.codelens.run,
      desc = 'CodeLens',
      remap = false,
    },
    {
      '<leader>lq',
      vim.diagnostic.setqflist,
      desc = 'Open diagnostics quickfix list',
      remap = false,
    },
    {
      '<leader>lr',
      vim.lsp.buf.rename,
      desc = 'Rename symbol',
      remap = false,
    },
    {
      '<leader>w',
      group = 'Workspace',
      remap = false
    },
    {
      '<leader>wa',
      vim.lsp.buf.add_workspace_folder,
      desc = 'Add folder',
      remap = false,
    },
    {
      '<leader>wl',
      function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end,
      desc = 'List folders',
      remap = false,
    },
    {
      '<leader>wr',
      vim.lsp.buf.remove_workspace_folder,
      desc = 'Remove folder',
      remap = false,
    },
    {
      '<leader>ws',
      ts_builtin.lsp_dynamic_workspace_symbols,
      desc = 'All workspaces symbols',
      remap = false,
    },
    {
      '<leader>wS',
      ts_builtin.lsp_document_symbols,
      desc = 'Current workspace symbols',
      remap = false,
    },
    { 'gd',        ts_builtin.lsp_definitions,           desc = '[G]oto [D]efinition' },
    { 'gD',        vim.lsp.buf.declaration,              desc = '[G]oto [D]eclaration' },
    { 'gr',        ts_builtin.lsp_references,            desc = '[G]oto [R]eferences' },
    { 'gI',        ts_builtin.lsp_implementations,       desc = '[G]oto [I]mplementation' },
    { 'gt',        ts_builtin.lsp_type_definitions,      desc = '[G]oto [T]ype Definition' },
    { 'K',         vim.lsp.buf.hover,                    desc = 'Hover Documentation' },
    { 'J',         vim.lsp.buf.signature_help,           desc = 'Signature Documentation' },
  })
end)

local setup_inlay_hints_keymaps = Once(function()
  vim.keymap.set('n', '<leader>th', function()
    local next_hint_config = not vim.lsp.inlay_hint.is_enabled()
    vim.lsp.inlay_hint.enable(next_hint_config)
  end, { desc = 'Toggle Inlay Hints' })
end)


-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
  setup_keymaps()

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
    if vim.lsp.inlay_hint.is_enabled() then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end
    setup_inlay_hints_keymaps()
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
  rust_analyzer = {},
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
  ruff = {
    settings = {
      -- Any extra CLI arguments for `ruff` go here.
      args = {},
    },
  },
  bashls = {},
  docker_compose_language_service = {},
  dockerls = {},
  html = {
    filetypes = { 'html', 'vue', 'templ', 'htmldjango' },
  },
  htmx = {
    filetypes = { 'html', 'templ', 'htmldjango' },
  },
  tailwindcss = {
    filetypes = { 'html', 'vue', 'templ', 'htmldjango', 'typescriptreact', 'javascriptreact' },
    settings = {
      tailwindCSS = {
        emmetCompletions = true,
      },
    },
    root_dir = lspconfig.util.root_pattern("tailwind.config.js", "tailwind.config.ts", "package.json"),
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
      'templ',
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
  volar = {
    settings = {
      css = {
        validate = true,
        lint = {
          unknownAtRules = "ignore",
        },
      },
      scss = {
        validate = true,
        lint = {
          unknownAtRules = "ignore",
        },
      },
      less = {
        validate = true,
        lint = {
          unknownAtRules = "ignore",
        },
      },
    },
  },
  ts_ls = {
    init_options = {
      plugins = {
        {
          name = '@vue/typescript-plugin',
          location = vim.fn.stdpath('data') .. '/mason/packages/vue-language-server/node_modules/@vue/language-server',
          languages = { 'vue' },
        },
      },
    },
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
    filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
  },
  templ = {},
}

-- Ensure the servers above are installed
local mason_lspconfig = require('mason-lspconfig')

mason_lspconfig.setup({
  ensure_installed = vim.tbl_keys(servers),
})

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
  ['rust_analyzer'] = function() end,
  ['pyright'] = function()
    local opts = vim.tbl_deep_extend('force', server_opts, servers['pyright'] or {})
    local python = require('config.lsp.python')
    python.setup(python.customize_opts(opts))
  end,
})

local M = {}

M.on_attach = on_attach

return M
