vim.pack.add({
  {
    src = 'https://github.com/folke/snacks.nvim',
    version = 'main',
  },
})

local keymaps = require('keymaps')
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

keymaps.add({
  { '<leader>l', group = 'Lsp and Diagnostic actions', remap = false },
  {
    '<leader>le',
    snacks_picker.diagnostics,
    desc = 'Diagnostic message',
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
    snacks_picker.lsp_symbols,
    desc = 'All workspaces symbols',
    remap = false,
  },
  {
    '<leader>wS',
    snacks_picker.lsp_workspace_symbols,
    desc = 'Current workspace symbols',
    remap = false,
  },
  {
    '<leader>s',
    group = 'Search',
    remap = false,
  },
  { 'gd', snacks_picker.lsp_definitions, desc = '[G]oto [D]efinition' },
  { 'gD', snacks_picker.lsp_declarations, desc = '[G]oto [D]eclaration' },
  { 'gr', snacks_picker.lsp_references, desc = '[G]oto [R]eferences' },
  { 'gI', snacks_picker.lsp_implementations, desc = '[G]oto [I]mplementation' },
  { 'gt', snacks_picker.lsp_type_definitions, desc = '[G]oto [T]ype Definition' },
  {
    '<leader>sb',
    snacks_picker.git_branches,
    desc = 'Git branches',
    remap = false,
  },
  {
    '<leader>sB',
    snacks_picker.buffers,
    desc = '[S]earch existing [B]uffers',
    remap = false,
  },
  {
    '<leader>sd',
    snacks_picker.diagnostics,
    desc = 'Diagnostics',
    remap = false,
  },
  {
    '<leader>sf',
    snacks_picker.git_files,
    desc = 'Git files',
    remap = false,
  },
  {
    '<leader>sF',
    function()
      snacks_picker.files({ cmd = 'rg', hidden = true, supports_live = true })
    end,
    desc = 'All Files',
    remap = false,
  },
  {
    '<leader>sg',
    snacks_picker.grep,
    desc = 'Grep word',
    remap = false,
  },
  {
    '<leader>sh',
    snacks_picker.help,
    desc = 'Help',
    remap = false,
  },
  {
    '<leader>sr',
    snacks_picker.lsp_references,
    desc = 'Lsp References',
    remap = false,
  },
  {
    '<leader>sw',
    snacks_picker.lines,
    desc = 'Fuzzily search word in buffer',
    remap = false,
  },
  { '<leader>sW', snacks_picker.grep_word, desc = 'Word under cursor', remap = false },
  { '<leader>tz', snacks.zen.zen, desc = 'Toggle ZenMode', silent = true },
  { '<C-t>', snacks.terminal.toggle, desc = 'Toggle Terminal', silent = true },
})
