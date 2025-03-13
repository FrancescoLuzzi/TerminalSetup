return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require('harpoon')
    harpoon:setup()

    require('which-key').add({
      { '<leader>p', group = 'Harpoon' },
      {
        '<leader>pa',
        function()
          harpoon:list():add()
        end,
        desc = 'Add current buffer',
      },
      {
        '<leader>pe',
        function()
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = 'Edit buffers',
      },
      {
        '<leader>p1',
        function()
          harpoon:list():select(1)
        end,
        desc = 'buffer 1',
      },
      {
        '<leader>p2',
        function()
          harpoon:list():select(2)
        end,
        desc = 'buffer 2',
      },
      {
        '<leader>p3',
        function()
          harpoon:list():select(3)
        end,
        desc = 'buffer 3',
      },
      {
        '<leader>p4',
        function()
          harpoon:list():select(4)
        end,
        desc = 'buffer 4',
      },
      {
        '<leader>pn',
        function()
          harpoon:list():next()
        end,
        desc = 'View Crate Graph',
      },
      {
        '<leader>pp',
        function()
          harpoon:list():prev()
        end,
        desc = 'prev buffer',
      },
    })
  end,
}
