return {
  'saecki/crates.nvim',
  tag = 'stable',
  event = { "BufRead Cargo.toml" },
  config = function()
    local crates = require('crates')
    crates.setup({
      lsp = {
        enabled = true,
        on_attach = function(client, bufnr)
          require('which-key').add({
            {
              '<leader>cD',
              crates.show_dependencies_popup,
              desc = '[crates] show dependencies',
            },
            { '<leader>cP', crates.show_popup, desc = '[crates] show popup' },
            {
              '<leader>cV',
              crates.show_versions_popup,
              desc = '[crates] show versions popup',
            },
            {
              '<leader>cf',
              crates.show_features_popup,
              desc = '[crates] show features',
            },
            {
              '<leader>ci',
              crates.show_crate_popup,
              desc = '[crates] show info',
            },
            {
              '<leader>cy',
              crates.open_repository,
              desc = '[crates] open repository',
            },
          }, { buffer = bufnr })
          require('config.lsp').on_attach(client, bufnr)
        end,
        actions = true,
        hover = true,
        completion = true,
      },
      completion = {
        cmp = {
          enabled = true,
        },
        crates = {
          enabled = true,  -- disabled by default
          max_results = 8, -- The maximum number of search results to display
          min_chars = 3,   -- The minimum number of charaters to type before completions begin appearing
        },
      },
      popup = {
        border = 'rounded',
        autofocus = true,
      },
    })
  end,
}
