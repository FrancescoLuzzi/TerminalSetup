return {
  'leoluz/nvim-dap-go',
  dependencies = {
    'mfussenegger/nvim-dap',
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
  },
  init = function()
    require('dap-go').setup()
  end,
}
