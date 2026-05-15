local utils = require('utils')

local function pip_install()
  vim.ui.input({ prompt = 'Install packages (separated by space): ' }, function(packages)
    vim.cmd('!pip install ' .. packages)
  end)
end

local function pip_freeze()
  if vim.loop.os_uname().sysname:match('Windows') then
    vim.cmd('!pip freeze | Out-File -Encoding UTF8 ' .. vim.loop.cwd() .. '/requirements.txt')
  else
    vim.cmd('!pip freeze > ' .. vim.loop.cwd() .. '/requirements.txt')
  end
end

-- For what diagnostic is enabled in which type checking mode, check doc:
-- https://github.com/microsoft/pyright/blob/main/docs/configuration.md#diagnostic-settings-defaults
-- Currently, the pyright also has some issues displaying hover documentation:
-- https://www.reddit.com/r/neovim/comments/1gdv1rc/what_is_causeing_the_lsp_hover_docs_to_looks_like/
local new_capability = {
  -- this will remove some of the diagnostics that duplicates those from ruff, idea taken and adapted from
  -- here: https://github.com/astral-sh/ruff-lsp/issues/384#issuecomment-1989619482
  textDocument = {
    publishDiagnostics = {
      tagSupport = {
        valueSet = { 2 },
      },
    },
    hover = {
      contentFormat = { 'plaintext' },
      dynamicRegistration = true,
    },
  },
}

---@type vim.lsp.Config
return {
  -- cmd = { "delance-langserver", "--stdio" },
  on_attach = function(_, bufnr)
    local register_normal = utils.create_keymap_setter('n', bufnr)
    utils.register_keymap_group('<leader>c', 'PythonCoding', bufnr)
    register_normal('<leader>ci', 'Install package', pip_install)
    register_normal('<leader>cf', 'Generate requirements.txt', pip_freeze)
  end,
  ---@type lspconfig.settings.pyright
  settings = {
    pyright = {
      -- disable import sorting and use Ruff for this
      disableOrganizeImports = true,
      disableTaggedHints = false,
    },
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = 'workspace',
        typeCheckingMode = 'standard',
        useLibraryCodeForTypes = true,
        -- we can this setting below to redefine some diagnostics
        diagnosticSeverityOverrides = {
          deprecateTypingAliases = false,
        },
        -- inlay hint settings are provided by pylance?
        inlayHints = {
          callArgumentNames = 'partial',
          functionReturnTypes = true,
          pytestParameters = true,
          variableTypes = true,
        },
      },
    },
  },
  capabilities = new_capability,
}
