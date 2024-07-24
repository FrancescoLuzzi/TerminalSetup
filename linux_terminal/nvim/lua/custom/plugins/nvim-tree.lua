return {
  -- add nvim-tree viewer
  -- See `:help nvim-tree`
  'nvim-tree/nvim-tree.lua',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  init = function()
    local function my_on_attach(bufnr)
      local api = require 'nvim-tree.api'

      local function opts(desc)
        return {
          desc = 'nvim-tree: ' .. desc,
          buffer = bufnr,
          noremap = true,
          silent = true,
          nowait = true,
        }
      end

      -- default mappings
      api.config.mappings.default_on_attach(bufnr)

      -- custom mappings
      vim.keymap.set('n', 'cd', api.tree.change_root_to_node, opts('CD'))
      vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
    end

    -- pass to setup along with your other options
    require('nvim-tree').setup({
      ---
      on_attach = my_on_attach,
      ---
      sync_root_with_cwd = true,
      diagnostics = {
        enable = true,
      },
      modified = {
        enable = true,
      },
      renderer = {
        highlight_modified = 'icon',
        group_empty = true,
      },
      ui = {
        confirm = {
          default_yes = true,
        },
      },
    })
  end,
}
