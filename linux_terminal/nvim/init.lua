-- Set highlight on search
vim.opt.hlsearch = true

-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true

-- custom scrolloff
vim.opt.scrolloff = 8

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true
vim.opt.cursorline = true

-- tab options
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.foldmethod = 'indent'
vim.opt.foldenable = false
vim.opt.foldlevel = 99
vim.g.markdown_folding = 1

-- Enable mouse mode
vim.opt.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeout = true
vim.opt.timeoutlen = 300

-- Configure split opening
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live while typing of all occurrences in the buffer
vim.opt.inccommand = 'split'

-- Set completeopt to have a better completion experience
vim.opt.completeopt = 'menuone,noselect,noinsert'

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set single status bar
vim.opt.laststatus = 3

-- set hlsearch
vim.opt.hlsearch = true

-- [[ Basic Keymaps ]]

-- See `:help mapleader`
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keymaps for better default experience

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { silent = true })

-- exit insert mode with 'jj'
vim.keymap.set('i', 'jj', '<Esc>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.hl.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Comment line remaps
vim.keymap.set('n', '<leader>/', 'gcc', { remap = true, desc = 'Comment toggle line' })
vim.keymap.set('v', '<leader>/', 'gc', { remap = true, desc = 'Comment toggle line (visual)' })

-- buffers commands
vim.keymap.set('n', '<S-l>', ':bn<CR>', { desc = 'Cycle to next buffer', silent = true })
vim.keymap.set('n', '<S-h>', ':bp<CR>', { desc = 'Cycle to previous buffer', silent = true })
vim.keymap.set(
  'n',
  '<leader>x',
  ':bn<bar>sp<bar>bp<bar>bd<CR>',
  { desc = 'Close Buffer', silent = true, remap = false }
)
vim.keymap.set(
  'n',
  '<leader>o',
  ':only<CR>',
  { desc = 'Close all Other windows', silent = true, remap = false }
)
vim.keymap.set(
  'n',
  '<leader>O',
  ':%bd|e#|bd#<CR>',
  { desc = 'Close all Other buffers', silent = true, remap = false }
)

-- window commands
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to right window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to lower window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to upper window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to left window' })
vim.keymap.set(
  'n',
  '<leader>\\',
  ':vsplit<CR>',
  { desc = 'Split window vertically', remap = false }
)
vim.keymap.set(
  'n',
  '<leader>-',
  ':split<CR>',
  { desc = 'Split window horizontally', remap = false }
)

-- resize windows
vim.keymap.set('n', '<A-Up>', ':resize -2<CR>', { desc = '', silent = true })
vim.keymap.set('n', '<A-Down>', ':resize +2<CR>', { desc = '', silent = true })
vim.keymap.set('n', '<A-Left>', ':vertical resize -2<CR>', { desc = '', silent = true })
vim.keymap.set('n', '<A-Right>', ':vertical resize +2<CR>', { desc = '', silent = true })

-- Auto indent on empty line.
vim.keymap.set('n', 'i', function()
  return string.match(vim.api.nvim_get_current_line(), '%g') == nil and '"_cc' or 'i'
end, { expr = true, noremap = true })

-- visual delete without clipboard save
vim.keymap.set(
  'v',
  'D',
  '"_d',
  { desc = 'Delete without saving to clipboardStay in visual mode while indenting', silent = true }
)

-- visual indenting
vim.keymap.set('v', '<', '<gv', { desc = 'Stay in visual mode while indenting', silent = true })
vim.keymap.set('v', '>', '>gv', { desc = 'Stay in visual mode while indenting', silent = true })

-- Move line
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', { desc = 'Move line down', silent = true })
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', { desc = 'Move line up', silent = true })
vim.keymap.set('i', '<A-j>', '<Esc>:m .+1<CR>==gi', { desc = 'Move line down', silent = true })
vim.keymap.set('i', '<A-k>', '<Esc>:m .-2<CR>==gi', { desc = 'Move line up', silent = true })
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>==gv-gv", { desc = 'Move line down', silent = true })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>==gv-gv", { desc = 'Move line up', silent = true })

vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
vim.keymap.set('t', '<C-w>', '<C-\\><C-n><C-w>')

-- handle git merge conflicts

vim.keymap.set('n', '<leader>mm', ':Gvdiffsplit!<CR>', { desc = 'Start 3way merge' })
vim.keymap.set('n', '<leader>m1', ':diffget LOCAL<CR>', { desc = 'diffget LOCAL change' })
vim.keymap.set('n', '<leader>m2', ':diffget BASE<CR>', { desc = 'diffget BASE change' })
vim.keymap.set('n', '<leader>m3', ':diffget REMOTE<CR>', { desc = 'diffget REMOTE change' })

require('init')

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
