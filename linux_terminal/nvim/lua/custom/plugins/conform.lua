return {
  -- package to help formatting files
  'stevearc/conform.nvim',
  opts = {
    formatters_by_ft = {
      -- install from mason
      python = { "isort", "black" },
    }
  },
}
