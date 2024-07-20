return {
  'danymat/neogen',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  config = {
    snippet_engine = 'luasnip',
    placeholders_hl = 'None',
  },
  init = function()
    local ng = require('neogen')
    local generate_callback = function(params)
      return function()
        ng.generate(params)
      end
    end
    require('which-key').add({
      { "<leader>n",  group = "Neogen docs",                 remap = false, },
      { "<leader>nF", generate_callback({ type = 'file' }),  desc = "Document file",     remap = false },
      { "<leader>nc", generate_callback({ type = 'class' }), desc = "Document class",    remap = false },
      { "<leader>nf", generate_callback({ type = 'func' }),  desc = "Document function", remap = false },
      { "<leader>nt", generate_callback({ type = 'type' }),  desc = "Document type",     remap = false },
    })
  end,
}
