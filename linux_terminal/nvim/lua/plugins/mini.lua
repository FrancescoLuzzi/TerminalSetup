vim.pack.add({
  {
    src = 'https://github.com/nvim-mini/mini.nvim',
    version = 'main',
  },
})

local keymaps = require('keymaps')
local utils = require('utils')

local augroup = utils.create_augroup('MiniGroup')

-- icons
local icons = require('mini.icons')
icons.setup()
icons.mock_nvim_web_devicons()

-- cursorword
require('mini.cursorword').setup({
  -- Delay (in ms) between when the cursor stops moving and when
  -- the word is highlighted. Default is 100.
  delay = 100,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'alpha',
    'DressingInput',
    'fugitive',
    'mason',
    'minifiles',
    'snacks_input',
    'snacks_terminal',
    'snacks_picker_input',
  },
  callback = function()
    vim.b.minicursorword_disable = true
  end,
})

-- indentline
local indentscope = require('mini.indentscope')
indentscope.setup({
  draw = {
    delay = 0,
    animation = indentscope.gen_animation.none(),
  },
  symbol = '▏',
})
local disabled_filetypes = {
  'alpha',
  'help',
  'Trouble',
  'trouble',
  'lazy',
  'toggleterm',
  'NvimTree',
}
-- disable mini.indentscope for selected filetypes
-- https://github.com/echasnovski/mini.nvim/issues/144#issuecomment-2164874307
vim.api.nvim_create_autocmd('FileType', {
  group = augroup,
  pattern = disabled_filetypes,
  callback = function(opts)
    vim.b[opts.buf].miniindentscope_disable = true
  end,
})
-- disable mini.indentscope in helper floating window
-- https://github.com/echasnovski/mini.nvim/discussions/962#discussioncomment-9760338
vim.api.nvim_create_autocmd('BufWinEnter', {
  group = augroup,
  callback = function(opts)
    if vim.bo[opts.buf].buftype == '' then
      return
    end
    if vim.api.nvim_win_get_config(0).relative == '' then
      return
    end
    vim.b[opts.buf].miniindentscope_disable = true
  end,
})

-- files
local files = require('mini.files')
files.setup({
  mappings = {
    close = 'q',
    go_in = '',
    go_in_plus = 'L',
    go_out = 'H',
    go_out_plus = '',
    reset = '<BS>',
    show_help = 'g?',
    synchronize = '=',
    trim_left = '<',
    trim_right = '>',
  },
  options = {
    use_as_default = true, -- Set to true to replace Netrw
  },
  windows = {
    preview = true, -- Show file preview on the right
    width_focus = 30,
    width_preview = 30,
  },
})
keymaps.add({
  '<leader>e',
  files.open,
  desc = 'Open file explorer',
})

-- surround
require('mini.surround').setup({
  mappings = {
    add = 'ys',
    delete = 'ds',
    find = 'gs',
    find_left = 'gS',
    highlight = '',
    replace = 'cs',
    update_n_lines = '',
  },
})
vim.keymap.set('x', 'S', ':<C-u>lua MiniSurround.add("visual")<CR>', { silent = true })
vim.keymap.set('n', 'yss', 'ys_', { remap = true })

-- tabline
require('mini.tabline').setup({
  show_icons = true,
})

-- statusline
local statusline = require('mini.statusline')
statusline.setup({
  content = {
    active = function()
      local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
      local git = statusline.section_git({ trunc_width = 75 })
      local diff = statusline.section_diff({ trunc_width = 75 })

      local diagnostics = statusline.section_diagnostics({
        trunc_width = 75,
        icon = '',
        signs = { ERROR = '', WARN = '', INFO = '', HINT = '' },
      })

      local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
      local location = statusline.section_location({ trunc_width = 75 })

      local filename = vim.fn.expand('%:.~')
      local time = os.date('%H:%M | %d/%m/%y')

      return statusline.combine_groups({
        { hl = mode_hl,                  strings = { mode } },
        { hl = 'MiniStatuslineDevinfo',  strings = { git, diff, diagnostics } },
        { hl = 'MiniStatuslineFilename', strings = { filename } },
        '%=', -- Right align split
        { hl = 'MiniStatuslineFileinfo', strings = { fileinfo, time } },
        { hl = mode_hl,                  strings = { location } },
      })
    end,
  },
  set_vim_settings = true,
})
vim.opt.laststatus = 3

-- pairs
require('mini.pairs').setup({
  mappings = {
    ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\].' },
    ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\].' },
    ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\].' },

    [')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
    [']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
    ['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },

    ['"'] = {
      action = 'closeopen',
      pair = '""',
      neigh_pattern = '[^\\].',
      register = { cr = false },
    },
    ["'"] = {
      action = 'closeopen',
      pair = "''",
      neigh_pattern = '[^\\].',
      register = { cr = false },
    },
    ['`'] = {
      action = 'closeopen',
      pair = '``',
      neigh_pattern = '[^\\].',
      register = { cr = false },
    },
  },
})

-- To replicate 'disable_filetype' for specific buffers (like sh or Telescope)
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'sh', 'bash', 'snack_picker_input' },
  group = augroup,
  callback = function()
    vim.b.minipairs_disable = true
  end,
})
