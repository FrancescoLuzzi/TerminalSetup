return {
  "danymat/neogen",
  dependencies = "nvim-treesitter/nvim-treesitter",
  config = { snippet_engine = "luasnip" },
  init = function()
    require("which-key").register(
      {
        n = {
          c = { ":lua require('neogen').generate({ type = 'class' })<CR>", "Document class" },
          f = { ":lua require('neogen').generate()<CR>", "Document function" },
        }
      },
      {
        prefix = "<leader>",
        noremap = true,
        silent = true,
      }
    )
  end
}
