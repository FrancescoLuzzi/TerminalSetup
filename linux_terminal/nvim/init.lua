-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

if vim.loop.os_uname().sysname:match('Windows') then
  local powershell_options = {
    shell = vim.fn.executable('pwsh') == 1 and 'pwsh' or 'powershell',
    shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;',
    shellredir = '-RedirectStandardOutput %s -NoNewWindow -Wait',
    shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode',
    shellquote = '',
    shellxquote = '',
  }

  for option, value in pairs(powershell_options) do
    vim.opt[option] = value
  end
end

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
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- this works the best but it's slow AF
-- https://www.reddit.com/r/neovim/comments/16zb9hh/wsl2_lazyvim_and_clipboard/
if vim.fn.has('wsl') then
  vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('Yank', { clear = true }),
    callback = function()
      vim.fn.system('clip.exe', vim.fn.getreg('"'))
    end,
  })
end

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

-- See `:help mapleader`
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set single status bar
vim.opt.laststatus = 3

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', tag = 'v1.6.1', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds completion from buffer
      'hrsh7th/cmp-buffer',

      -- Adds completion of local paths
      'hrsh7th/cmp-path',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },

  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    dependencies = { 'folke/which-key.nvim' },
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gs = require('gitsigns')
        vim.keymap.set('n', '[h', function()
          gs.nav_hunk('prev')
        end, { buffer = bufnr, desc = 'Go to Previous Git Hunk' })
        vim.keymap.set('n', ']h', function()
          gs.nav_hunk('next')
        end, { buffer = bufnr, desc = 'Go to Next Git Hunk' })
        require('which-key').add({
          { '<leader>h', group = 'Hunk & Gitsigns' },
          { '<leader>hp', gs.preview_hunk_inline, desc = 'Hunk Preview' },
          { '<leader>hs', gs.stage_hunk, desc = 'Stage Hunk' },
          { '<leader>hr', gs.reset_hunk, desc = 'Reset Hunk' },
          { '<leader>hb', gs.toggle_current_line_blame, desc = 'Toggle Blame' },
        })
      end,
    },
  },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable('make') == 1
        end,
      },
    },
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      {
        'nvim-treesitter/nvim-treesitter-context',
        init = function()
          require('treesitter-context').setup({
            max_lines = 3,
          })

          vim.keymap.set(
            'n',
            '<leader>t\\',
            ':TSContextToggle<CR>',
            { desc = 'Toggle TS context', silent = true }
          )
        end,
      },
    },
    build = ':TSUpdate',
  },

  -- The import below automatically adds your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  { import = 'custom.plugins' },
}, {})

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`

vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { silent = true })

-- exit insert mode with 'jj'
vim.keymap.set('i', 'jj', '<Esc>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup({
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
})

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup({
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = {
    'bash',
    'c',
    'c_sharp',
    'css',
    'html',
    'go',
    'javascript',
    'json',
    'jsonc',
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
  },

  auto_install = true,
  sync_install = false,
  highlight = { enable = true },
  indent = { enable = true },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
})

require('config.extra_filetypes')

vim.diagnostic.config({
  float = { border = 'rounded' },
})

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
--
-- Quickfix keymaps
vim.keymap.set('n', '[q', '<cmd>cprev<CR>', { desc = 'Go to previous quickfix item' })
vim.keymap.set('n', ']q', '<cmd>cnext<CR>', { desc = 'Go to next quickfix item' })

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require('cmp')
local luasnip = require('luasnip')
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup({})

local lsp_symbols = {
  Text = '   (Text) ',
  Method = '   (Method)',
  Function = ' 󰊕  (Function)',
  Constructor = '   (Constructor)',
  Field = '   (Field)',
  Variable = '   (Variable)',
  Class = '   (Class)',
  Interface = '   (Interface)',
  Module = '   (Module)',
  Property = '   (Property)',
  Unit = '   (Unit)',
  Value = '   (Value)',
  Enum = '   (Enum)',
  Keyword = '   (Keyword)',
  Snippet = '   (Snippet)',
  Color = '   (Color)',
  File = '   (File)',
  Reference = '   (Reference)',
  Folder = '   (Folder)',
  EnumMember = '   (EnumMember)',
  Constant = '   (Constant)',
  Struct = '   (Struct)',
  Event = '   (Event)',
  Operator = '   (Operator)',
  TypeParameter = '   (TypeParameter)',
}

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'crates' },
  },
  formatting = {
    format = function(entry, item)
      -- format images in suggestions
      item.kind = lsp_symbols[item.kind]
      return item
    end,
  },
})

require('config.lsp')

local which_key = require('which-key')
--
-- diffview
local diffview_active = false
local diffview_toggle = function()
  diffview_active = not diffview_active
  if diffview_active then
    vim.cmd('silent windo diffthis')
  else
    vim.cmd('silent windo diffoff')
  end
end

local ts_builtin = require('telescope.builtin')

which_key.add({
  {
    '<leader>-',
    '<cmd>split<CR>',
    desc = 'Split window orizzontally',
    remap = false,
  },
  {
    '<leader>/',
    'gcc',
    desc = 'Comment toggle current line',
    remap = true,
  },
  {
    '<leader>\\',
    '<cmd>vsplit<CR>',
    desc = 'Split window vertically',
    remap = false,
  },
  {
    '<leader>e',
    '<cmd>NvimTreeToggle<CR>',
    desc = 'Open File Explorer',
    remap = false,
  },
  {
    '<leader>o',
    '<cmd>only<CR>',
    desc = 'Close all other windows',
    remap = false,
  },
  { '<leader>s', group = 'Search', remap = false },
  {
    '<leader>sa',
    ts_builtin.builtin,
    desc = '[S]earch [A]LL builtin options',
    remap = false,
  },
  {
    '<leader>sb',
    ts_builtin.git_branches,
    desc = 'Git branches',
    remap = false,
  },
  {
    '<leader>sB',
    ts_builtin.buffers,
    desc = '[S]earch existing [B]uffers',
    remap = false,
  },
  {
    '<leader>sd',
    ts_builtin.diagnostics,
    desc = 'Diagnostics',
    remap = false,
  },
  {
    '<leader>sf',
    ts_builtin.git_files,
    desc = 'Git files',
    remap = false,
  },
  {
    '<leader>sF',
    ts_builtin.find_files,
    desc = 'All Files',
    remap = false,
  },
  {
    '<leader>sg',
    ts_builtin.live_grep,
    desc = 'Grep word',
    remap = false,
  },
  {
    '<leader>sh',
    ts_builtin.help_tags,
    desc = 'Help',
    remap = false,
  },
  {
    '<leader>so',
    ts_builtin.oldfiles,
    desc = '[S]earch [O]ld files',
    remap = false,
  },
  {
    '<leader>sr',
    ts_builtin.lsp_references,
    desc = 'Lsp References',
    remap = false,
  },
  {
    '<leader>sw',
    function()
      -- You can pass additional configuration to telescope to change theme, layout, etc.
      ts_builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
        winblend = 10,
        previewer = true,
      }))
    end,
    desc = 'Fuzzily search word in buffer',
    remap = false,
  },
  { '<leader>sW', ts_builtin.grep_string, desc = 'Word under cursor', remap = false },
  { '<leader>t', group = 'Toggle', remap = false },
  { '<leader>td', diffview_toggle, desc = 'Toggle Diffview', remap = false },
  { '<leader>tw', ':set wrap!<CR>', desc = 'Toggle word wrap', remap = false },
  { '<leader>x', ':bn<bar>sp<bar>bp<bar>bd<CR>', desc = 'Close Buffer', remap = false },
})

-- Comment line visual mode

vim.keymap.set('v', '<leader>/', 'gc', { remap = true, desc = 'Comment toggle line (visual)' })

-- Window and buffers commands

vim.keymap.set(
  'n',
  '<S-l>',
  ':BufferLineCycleNext<CR>',
  { desc = 'Cycle to next buffer', silent = true }
)
vim.keymap.set(
  'n',
  '<S-h>',
  ':BufferLineCyclePrev<CR>',
  { desc = 'Cycle to previous buffer', silent = true }
)

vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to right window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to lower window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to upper window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to left window' })

-- resize windows

vim.keymap.set('n', '<A-Up>', ':resize -2<CR>', { desc = '', silent = true })
vim.keymap.set('n', '<A-Down>', ':resize +2<CR>', { desc = '', silent = true })
vim.keymap.set('n', '<A-Left>', ':vertical resize -2<CR>', { desc = '', silent = true })
vim.keymap.set('n', '<A-Right>', ':vertical resize +2<CR>', { desc = '', silent = true })

-- Auto indent on empty line.

vim.keymap.set('n', 'i', function()
  return string.match(vim.api.nvim_get_current_line(), '%g') == nil and 'cc' or 'i'
end, { expr = true, noremap = true })

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

vim.keymap.set('n', '<leader>m', ':Gvdiffsplit!<CR>', { desc = 'Start 3way merge' })
vim.keymap.set('n', '<leader>1', ':diffget LOCAL<CR>', { desc = 'diffget LOCAL change' })
vim.keymap.set('n', '<leader>2', ':diffget BASE<CR>', { desc = 'diffget BASE change' })
vim.keymap.set('n', '<leader>3', ':diffget REMOTE<CR>', { desc = 'diffget REMOTE change' })

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
