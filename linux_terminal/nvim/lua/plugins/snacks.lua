vim.pack.add({
  {
    src = 'https://github.com/folke/snacks.nvim',
    version = 'main',
  },
})

local utils = require('utils')
local snacks = require('snacks')

snacks.setup({
  bigfile = { enabled = true },
  notifier = {
    enabled = true,
    timeout = 3000,
  },
  picker = { enabled = true },
  quickfile = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = false },
  statuscolumn = { enabled = true },
  terminal = {
    win = {
      style = 'terminal',
      border = 'rounded',
      position = 'float',
      width = 0.9,
      height = 0.9,
      backdrop = 100,
    },
    keys = {
      q = 'hide',
    },
  },
  words = { enabled = true },
  styles = {
    notification = {
      wo = { wrap = true }, -- Wrap notifications
    },
  },
})

local snacks_picker = snacks.picker
local register_normal = utils.create_keymap_setter('n')

utils.register_keymap_group('<leader>s', 'Search')

register_normal('<leader>le', 'Diagnostic message', snacks_picker.diagnostics)
register_normal('<leader>wr', 'Remove folder', vim.lsp.buf.remove_workspace_folder)
register_normal('<leader>ws', 'All workspaces symbols', snacks_picker.lsp_symbols)
register_normal('<leader>wS', 'Current workspace symbols', snacks_picker.lsp_workspace_symbols)
register_normal('gd', '[G]oto [D]efinition', snacks_picker.lsp_definitions)
register_normal('gD', '[G]oto [D]eclaration', snacks_picker.lsp_declarations)
register_normal('gr', '[G]oto [R]eferences', snacks_picker.lsp_references)
register_normal('gI', '[G]oto [I]mplementation', snacks_picker.lsp_implementations)
register_normal('gt', '[G]oto [T]ype Definition', snacks_picker.lsp_type_definitions)
register_normal('<leader>sb', 'Git branches', snacks_picker.git_branches)
register_normal('<leader>sB', '[S]earch existing [B]uffers', snacks_picker.buffers)
register_normal('<leader>sd', 'Diagnostics', snacks_picker.diagnostics)
register_normal('<leader>sf', 'Git files', snacks_picker.git_files)
register_normal('<leader>sF', 'All Files', function()
  snacks_picker.files({ cmd = 'rg', hidden = true, supports_live = true })
end)
register_normal('<leader>sg', 'Grep word', snacks_picker.grep)
register_normal('<leader>sh', 'Help', snacks_picker.help)
register_normal('<leader>sr', 'Lsp References', snacks_picker.lsp_references)
register_normal('<leader>sw', 'Fuzzily search word in buffer', snacks_picker.lines)
register_normal('<leader>sW', 'Word under cursor', snacks_picker.grep_word)
register_normal('<leader>tz', 'Toggle ZenMode', snacks.zen.zen, { silent = true })
register_normal('<C-t>', 'Toggle Terminal', snacks.terminal.toggle, { silent = true })
