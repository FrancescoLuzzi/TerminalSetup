vim.pack.add({
  {
    src = 'https://github.com/mason-org/mason.nvim',
    version = 'main',
  },
  {
    src = 'https://github.com/folke/lazydev.nvim',
    version = 'main',
  },
  {
    src = 'https://github.com/neovim/nvim-lspconfig',
    version = 'master',
  },
  {
    src = 'https://github.com/mason-org/mason.nvim',
    version = 'main',
  },
  {
    src = 'https://github.com/mason-org/mason-lspconfig.nvim',
    version = 'main',
  },

  { src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim' },
})

require('mason').setup()

local mason_lspconfig = require('mason-lspconfig')
local mason_tool_installer = require('mason-tool-installer')
local utils = require('utils')
local augroup = utils.create_augroup('LSP')
local register_normal = utils.create_keymap_setter('n')

require('lazydev').setup({
  enabled = true,
  library = {
    {
      path = '${3rd}/luv/library',
      words = { 'vim%.uv' },
    },
  },
})

utils.register_keymap_group('<leader>l', 'Lsp and Diagnostic actions')
utils.register_keymap_group('<leader>w', 'Workspace')

register_normal('<leader>la', 'Code Action', vim.lsp.buf.code_action)
register_normal('<leader>ld', 'Diagnostic message', vim.diagnostic.open_float)
register_normal('<leader>ll', 'CodeLens', vim.lsp.codelens.run)
register_normal('<leader>lq', 'Open diagnostics quickfix list', vim.diagnostic.setqflist)
register_normal('<leader>lr', 'Rename symbol', vim.lsp.buf.rename)
register_normal('<leader>wa', 'Add folder', vim.lsp.buf.add_workspace_folder)
register_normal('<leader>wl', 'List folders', function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end)
register_normal('<leader>wr', 'Remove folder', vim.lsp.buf.remove_workspace_folder)
register_normal('K', 'Hover Documentation', function()
  vim.lsp.buf.hover({
    border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
    close_events = { 'CursorMoved', 'BufLeave', 'WinLeave', 'LSPDetach' },
  })
end)
register_normal('J', 'Signature Documentation', vim.lsp.buf.signature_help)

local servers = {
  -- this is installed with rustaceanvim
  -- 'rust_analyzer',
  'lua_ls',
  'gopls',
  'pyright',
  'ruff',
  'bashls',
  'docker_compose_language_service',
  'dockerls',
  'html',
  -- 'htmx',
  'tailwindcss',
  'zls',
  'emmet_ls',
  'jsonls',
  'marksman',
  'sqlls',
  'yamlls',
  'ts_ls',
  'templ',
  'cssls',
  'vue_ls',
}

local tools = {
  'tree-sitter-cli',
  'stylua',
}

for _, server in ipairs(servers) do
  vim.lsp.enable(server)
end

mason_lspconfig.setup({
  ensure_installed = servers,
})

mason_tool_installer.setup({
  ensure_installed = tools,
  auto_update = false,
  run_on_start = true,
})

vim.diagnostic.config({
  severity_sort = true,
  float = { border = 'rounded', source = true },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  } or {},
  virtual_text = {
    source = true,
    spacing = 2,
  },
})

local has_conform, conform = pcall(require, 'conform')

--- @param bufnr integer
local setup_format = function(bufnr)
  vim.bo[bufnr].formatexpr = 'v:lua.vim.lsp.formatexpr()'
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function()
    vim.lsp.buf.format({ bufnr = bufnr })
  end, { desc = 'Format buffer with LSP' })
end

if has_conform then
  --- @param bufnr integer
  setup_format = function(bufnr)
    vim.bo[bufnr].formatexpr = "v:lua.require'conform'.formatexpr()"

    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function()
      conform.format({ bufnr = bufnr, lsp_fallback = true })
    end, { desc = 'Format buffer with Conform (LSP Fallback)' })
  end
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = augroup,
  callback = function(attach)
    local bufnr = attach.buf
    local client = vim.lsp.get_client_by_id(attach.data.client_id)
    local register_buffer_normal = utils.create_keymap_setter('n', bufnr)

    if client then
      -- Completion
      if client:supports_method('textDocument/completion') then
        vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
      end

      -- Formatting
      if client:supports_method('textDocument/formatting') then
        setup_format(bufnr)
      end

      -- Folding
      if client:supports_method('textDocument/foldingRange') then
        local window = vim.api.nvim_get_current_win()
        vim.wo[window][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
      end

      -- Inlay Hint
      if client:supports_method('textDocument/inlayHint') then
        register_buffer_normal('<leader>th', '[T]oggle Inlay [H]ints', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = attach.buf })
        end)
      end
    end

    --  Cleanup
    vim.api.nvim_create_autocmd('LspDetach', {
      group = vim.api.nvim_create_augroup('LspDetachCustom', { clear = true }),
      callback = function()
        vim.lsp.buf.clear_references()
      end,
    })
  end,
})
