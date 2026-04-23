vim.pack.add({
  {
    src = 'https://github.com/lewis6991/gitsigns.nvim',
    -- version = 'main',
  },
})

local keymaps = require('keymaps')
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
        vim.keymap.set('n', '[h', function()
            gs.nav_hunk('prev')
        end, { buffer = bufnr, desc = 'Go to Previous Git Hunk' })
        vim.keymap.set('n', ']h', function()
            gs.nav_hunk('next')
        end, { buffer = bufnr, desc = 'Go to Next Git Hunk' })
        keymaps.add({
            { '<leader>h',  group = 'Hunk & Gitsigns' },
            { '<leader>hp', gs.preview_hunk_inline,       desc = 'Hunk Preview' },
            { '<leader>hs', gs.stage_hunk,                desc = 'Stage Hunk' },
            { '<leader>hr', gs.reset_hunk,                desc = 'Reset Hunk' },
            { '<leader>hb', gs.toggle_current_line_blame, desc = 'Toggle Blame' },
        })
    end,
})
