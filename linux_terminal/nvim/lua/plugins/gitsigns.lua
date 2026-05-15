vim.pack.add({
  {
    src = 'https://github.com/lewis6991/gitsigns.nvim',
    -- version = 'main',
  },
})

local utils = require('utils')

local gs = require('gitsigns')
gs.setup({
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
  on_attach = function(bufnr)
    local register_normal = utils.create_keymap_setter('n', bufnr)

    utils.register_keymap_group('<leader>h', 'Hunk & Gitsigns', bufnr)
    register_normal('[h', 'Go to Previous Git Hunk', function()
      gs.nav_hunk('prev')
    end)
    register_normal(']h', 'Go to Next Git Hunk', function()
      gs.nav_hunk('next')
    end)
    register_normal('<leader>hp', 'Hunk Preview', gs.preview_hunk_inline)
    register_normal('<leader>hs', 'Stage Hunk', gs.stage_hunk)
    register_normal('<leader>hr', 'Reset Hunk', gs.reset_hunk)
    register_normal('<leader>hb', 'Toggle Blame', gs.toggle_current_line_blame)
  end,
})
