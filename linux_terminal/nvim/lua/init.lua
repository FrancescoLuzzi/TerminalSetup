vim.pack.add({
  -- Git related plugins
  'https://github.com/tpope/vim-fugitive',
  -- Detect tabstop and shiftwidth automatically
  'https://github.com/tpope/vim-sleuth',
  -- spinner
  'https://github.com/j-hui/fidget.nvim',
  -- treesitter
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects', version = 'main' },
})

local parsers = {
  'bash',
  'c',
  'c_sharp',
  'css',
  'html',
  'go',
  'javascript',
  'json',
  'lua',
  'markdown',
  'markdown_inline',
  'python',
  'regex',
  'rust',
  'typescript',
  'sql',
  'toml',
  'xml',
  'yaml',
  'zig',
}

local nvim_treesitter = require('nvim-treesitter')

nvim_treesitter.setup({})

local installed_parsers = {}
for _, parser in ipairs(nvim_treesitter.get_installed('parsers')) do
  installed_parsers[parser] = true
end

local missing_parsers = vim.tbl_filter(function(parser)
  return not installed_parsers[parser]
end, parsers)

if #missing_parsers > 0 then
  nvim_treesitter.install(missing_parsers)
end

vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local bufnr = args.buf
    local filetype = vim.bo[bufnr].filetype
    local language = vim.treesitter.language.get_lang(filetype)

    if not language then
      return
    end

    local ok = pcall(vim.treesitter.start, bufnr, language)
    if not ok then
      return
    end

    vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

require('nvim-treesitter-textobjects').setup({
  select = {
    lookahead = true,
  },
  move = {
    set_jumps = true,
  },
})

local select = require('nvim-treesitter-textobjects.select')
local move = require('nvim-treesitter-textobjects.move')
local swap = require('nvim-treesitter-textobjects.swap')

vim.keymap.set({ 'x', 'o' }, 'aa', function()
  select.select_textobject('@parameter.outer', 'textobjects')
end)
vim.keymap.set({ 'x', 'o' }, 'ia', function()
  select.select_textobject('@parameter.inner', 'textobjects')
end)
vim.keymap.set({ 'x', 'o' }, 'af', function()
  select.select_textobject('@function.outer', 'textobjects')
end)
vim.keymap.set({ 'x', 'o' }, 'if', function()
  select.select_textobject('@function.inner', 'textobjects')
end)
vim.keymap.set({ 'x', 'o' }, 'ac', function()
  select.select_textobject('@class.outer', 'textobjects')
end)
vim.keymap.set({ 'x', 'o' }, 'ic', function()
  select.select_textobject('@class.inner', 'textobjects')
end)

vim.keymap.set({ 'n', 'x', 'o' }, ']m', function()
  move.goto_next_start('@function.outer', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, ']]', function()
  move.goto_next_start('@class.outer', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, ']M', function()
  move.goto_next_end('@function.outer', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, '][', function()
  move.goto_next_end('@class.outer', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, '[m', function()
  move.goto_previous_start('@function.outer', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, '[[', function()
  move.goto_previous_start('@class.outer', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, '[M', function()
  move.goto_previous_end('@function.outer', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, '[]', function()
  move.goto_previous_end('@class.outer', 'textobjects')
end)

vim.keymap.set('n', '<leader>a', function()
  swap.swap_next('@parameter.inner')
end)
vim.keymap.set('n', '<leader>A', function()
  swap.swap_previous('@parameter.inner')
end)

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind

    if name == 'nvim-treesitter' and kind == 'update' then
      vim.cmd('TSUpdate')
    end
  end,
})

require('config')
require('plugins')
require('lsp')
