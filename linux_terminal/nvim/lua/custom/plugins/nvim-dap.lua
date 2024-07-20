return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'theHamsta/nvim-dap-virtual-text',
    'folke/which-key.nvim',
  },
  init = function()
    local dap = require('dap')
    local dapui = require('dapui')
    require('nvim-dap-virtual-text').setup({})
    dapui.setup()

    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close()
    end

    require('which-key').add({
      { "<leader>d",  group = "Debugging", remap = false },
      { "<leader>dC", dap.terminate,       desc = "Close session", remap = false },
      { "<leader>dI", dap.step_out,        desc = "Step out",      remap = false },
      { "<leader>dc", dap.continue,        desc = "Continue",      remap = false },
      { "<leader>di", dap.step_into,       desc = "Step in",       remap = false },
      { "<leader>do", dap.step_over,       desc = "Step over",     remap = false },
      {
        "<leader>ds",
        function()
          dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
        end,
        desc = "Set breakpoint with log print",
        remap = false
      },
      { "<leader>dt", dap.toggle_breakpoint, desc = "Toggle breakpoint", remap = false },
      { "<leader>du", dapui.toggle,          desc = "Toggle DapUi",      remap = false },
    })

    local set_colorscheme = function()
      -- bg color for stopped line or lines with breakpoints
      vim.api.nvim_set_hl(0, 'DapBreakpointLinehl', { bg = '#3f3131' })
      vim.api.nvim_set_hl(0, 'DapLogPointLinehl', { bg = '#313b3f' })
      vim.api.nvim_set_hl(0, 'DapStoppedLinehl', { bg = '#31353f' })

      -- fg color for dap icons
      vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#993939' })
      vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef' })
      vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379' })
    end

    set_colorscheme()

    local group = vim.api.nvim_create_augroup('DapUIFirstSetup', { clear = true })
    vim.api.nvim_create_autocmd('ColorScheme', {
      pattern = '*',
      group = group,
      desc = 'prevent colorscheme clears self-defined DAP icon colors.',
      callback = set_colorscheme,
    })

    vim.fn.sign_define('DapBreakpoint', {
      text = ' ',
      texthl = 'DapBreakpoint',
      linehl = 'DapBreakpointLinehl',
    })
    vim.fn.sign_define('DapBreakpointCondition', {
      text = ' ',
      texthl = 'DapBreakpoint',
      linehl = 'DapBreakpointLinehl',
    })
    vim.fn.sign_define('DapBreakpointRejected', {
      text = ' ',
      texthl = 'DapBreakpoint',
      linehl = 'DapBreakpointLinehl',
    })
    vim.fn.sign_define('DapLogPoint', {
      text = ' ',
      texthl = 'DapLogPoint',
      linehl = 'DapLogPointLinehl',
    })
    vim.fn.sign_define('DapStopped', {
      text = ' ',
      texthl = 'DapStopped',
      linehl = 'DapStoppedLinehl',
    })
  end,
}
