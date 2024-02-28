return {
  'simrat39/rust-tools.nvim',
  dependencies = {
    'neovim/nvim-lspconfig',
    'nvim-lua/popup.nvim',
    {
      'saecki/crates.nvim',
      version = 'v0.4.0',
      dependencies = { 'nvim-lua/plenary.nvim' },
      init = function()
        require('crates').setup {
          popup = {
            border = 'rounded',
            autofocus = true,
          },
        }
      end,
    },
  },
}
