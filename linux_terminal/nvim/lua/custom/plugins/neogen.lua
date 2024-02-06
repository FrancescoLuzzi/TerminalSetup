return {
  "danymat/neogen",
  dependencies = "nvim-treesitter/nvim-treesitter",
  config = { snippet_engine = "luasnip" },
  init = function()
    require("which-key").register(
      {
        n = {
          name = "Neogen docs",
          c = { ":lua require('neogen').generate({ type = 'class' })<CR>", "Document class" },
          f = { ":lua require('neogen').generate({ type = 'func' })<CR>", "Document function" },
          t = { ":lua require('neogen').generate({ type = 'type' })<CR>", "Document type" },
          F = { ":lua require('neogen').generate({ type = 'file' })<CR>", "Document file" },
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
