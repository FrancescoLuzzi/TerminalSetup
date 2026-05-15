-- 1. Add the plugin
vim.pack.add({
  {
    src = 'https://github.com/saecki/crates.nvim',
    tag = 'stable',
  },
})

vim.api.nvim_create_autocmd('BufRead', {
  pattern = 'Cargo.toml',
  callback = function(args)
    local crates = require('crates')
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

    require('which-key').add({
      { '<leader>cD', crates.show_dependencies_popup, desc = '[crates] show dependencies' },
      { '<leader>cP', crates.show_popup, desc = '[crates] show popup' },
      { '<leader>cV', crates.show_versions_popup, desc = '[crates] show versions popup' },
      { '<leader>cf', crates.show_features_popup, desc = '[crates] show features' },
      { '<leader>ci', crates.show_crate_popup, desc = '[crates] show info' },
      { '<leader>cy', crates.open_repository, desc = '[crates] open repository' },
    }, { buffer = args.buf })
  end,
})
