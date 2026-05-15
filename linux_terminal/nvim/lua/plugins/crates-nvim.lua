-- 1. Add the plugin
vim.pack.add({
  {
    src = 'https://github.com/saecki/crates.nvim',
    tag = 'stable',
  },
})

local utils = require('utils')

vim.api.nvim_create_autocmd('BufRead', {
  pattern = 'Cargo.toml',
  callback = function(args)
    local crates = require('crates')
    local register_normal = utils.create_keymap_setter('n', args.buf)

    crates.setup({
      autoupdate_throttle = 50,
      popup = {
        show_version_date = true,
        autofocus = true,
      },
      completion = {
        crates = {
          enabled = true,
          max_results = 30,
        },
        blink = {
          use_custom_kind = true,
        },
      },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    })

    utils.register_keymap_group('<leader>c', 'Crates', args.buf)
    register_normal('<leader>cD', '[crates] show dependencies', crates.show_dependencies_popup)
    register_normal('<leader>cP', '[crates] show popup', crates.show_popup)
    register_normal('<leader>cV', '[crates] show versions popup', crates.show_versions_popup)
    register_normal('<leader>cf', '[crates] show features', crates.show_features_popup)
    register_normal('<leader>ci', '[crates] show info', crates.show_crate_popup)
    register_normal('<leader>cy', '[crates] open repository', crates.open_repository)
  end,
})
