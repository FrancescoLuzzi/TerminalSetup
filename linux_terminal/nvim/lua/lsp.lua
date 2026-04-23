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
local keymaps = require('keymaps')
local augroup = utils.create_augroup('LSP')

require('lazydev').setup({
  {
    path = '${3rd}/luv/library',
    words = { 'vim%.uv' },
  },
})

require('which-key').add({
  { '<leader>l', group = 'Lsp and Diagnostic actions', remap = false },
  {
    '<leader>la',
    vim.lsp.buf.code_action,
    desc = 'Code Action',
    remap = false,
  },
  {
    '<leader>ld',
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
    remap = false,
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
    'K',
    function()
      vim.lsp.buf.hover({
        border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
        close_events = { 'CursorMoved', 'BufLeave', 'WinLeave', 'LSPDetach' },
      })
    end,
    desc = 'Hover Documentation',
  },
  { 'J', vim.lsp.buf.signature_help, desc = 'Signature Documentation' },
})

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
  'htmx',
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
        keymaps.add({
          '<leader>th',
          function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = attach.buf })
          end,
          desc = '[T]oggle Inlay [H]ints',
        })
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
