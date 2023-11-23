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
  require("lsp-inlayhints").on_attach(client, bufnr)

  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>lr', vim.lsp.buf.rename, '[R]ename')
  nmap('<leader>la', vim.lsp.buf.code_action, 'Code [A]ction')
  nmap('<leader>ll', vim.lsp.codelens.run, 'Code [L]ens')

  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('gt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')
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
    },
  },
  lua_ls = {
    options = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
        hints = { enable = true },
      }
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
        disableOrganizeImports = true
      },
      python = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = "workspace",
          useLibraryCodeForTypes = true,
          typeCheckingMode = "basic",
        },
      },
    },
  },
  lemminx = {
    settings = {
      xml = { catalogs = { "./catalog.xml" } }
    }
  },
  bashls = {},
  docker_compose_language_service = {},
  dockerls = {},
  html = {},
  -- https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
  emmet_ls = {
    filetypes = { "css", "eruby", "html", "javascript", "javascriptreact", "less", "sass", "scss", "svelte", "pug", "typescriptreact", "vue" },
    init_options = {
      html = {
        options = {
          -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
          ["bem.enabled"] = true,
        },
      },
    },
  },
  jsonls = {},
  marksman = {},
  sqlls = {},
  yamlls = {},
}

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

local lspconfig = require "lspconfig"

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
  ["gopls"] = function()
    local opts = vim.tbl_deep_extend("force", server_opts, servers["gopls"] or {})
    local go = require("config.lsp.go")
    go.setup(go.customize_opts(opts))
  end,
  ["rust_analyzer"] = function()
    local opts = vim.tbl_deep_extend("force", server_opts, servers["rust_analyzer"] or {})
    local rust = require("config.lsp.rust")
    rust.setup(rust.customize_opts(opts))
  end,
  ["pyright"] = function()
    local opts = vim.tbl_deep_extend("force", server_opts, servers["pyright"] or {})
    local python = require("config.lsp.python")
    python.setup(python.customize_opts(opts))
  end,
  ["lemminx"] = function()
    local opts = vim.tbl_deep_extend("force", server_opts, servers["lemminx"] or {})
    local xml = require("config.lsp.xml")
    xml.setup(xml.customize_opts(opts))
  end,
}
