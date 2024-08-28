local M = {}

local function configure_keymappings()
  -- attach my LSP configs keybindings
  local wk = require('which-key')
  wk.add({
    { '<leader>c', group = 'GolangCoding' },
    { '<leader>cd', group = 'Debug' },
    { '<leader>cdc', require('dap-go').debug_test, desc = 'Run current test in debugger' },
    { '<leader>ce', '<cmd>GoIfErr<cr>', desc = 'Add if err' },
    { '<leader>ch', group = 'Helper' },
    { '<leader>cha', '<cmd>GoAddTag<cr>', desc = 'Add tags to struct' },
    { '<leader>chc', '<cmd>GoCoverage<cr>', desc = 'Test coverage' },
    { '<leader>chg', "<cmd>lua require('go.comment').gen()<cr>", desc = 'Generate comment' },
    { '<leader>chi', '<cmd>GoModInit<cr>', desc = 'Go mod init' },
    { '<leader>chr', '<cmd>GoRMTag<cr>', desc = 'Remove tags to struct' },
    { '<leader>cht', '<cmd>GoModTidy<cr>', desc = 'Go mod tidy' },
    { '<leader>chv', '<cmd>GoVet<cr>', desc = 'Go vet' },
    { '<leader>cl', '<cmd>GoLint<cr>', desc = 'Run linter' },
    { '<leader>co', '<cmd>GoPkgOutline<cr>', desc = 'Outline' },
    { '<leader>cr', '<cmd>GoRun<cr>', desc = 'Run' },
    { '<leader>cs', '<cmd>GoFillStruct<cr>', desc = 'Autofill struct' },
    { '<leader>ct', group = 'Tests' },
    { '<leader>cta', '<cmd>GoAlt!<cr>', desc = 'Open alt file' },
    { '<leader>ctf', '<cmd>GoTestFile<cr>', desc = 'Run test for current file' },
    { '<leader>ctr', '<cmd>GoTest<cr>', desc = 'Run tests' },
    { '<leader>cts', '<cmd>GoAltS!<cr>', desc = 'Open alt file in split' },
    { '<leader>ctu', '<cmd>GoTestFunc<cr>', desc = 'Run test for current func' },
    { '<leader>ctv', '<cmd>GoAltV!<cr>', desc = 'Open alt file in vertical split' },
  })
  wk.add({
    { '<leader>cj', "<cmd>'<,'>GoJson2Struct<cr>", desc = 'Json to struct', mode = 'v' },
  })
end

M.customize_opts = function(server_opts)
  local on_attach_orginal_func = server_opts['on_attach']
  if on_attach_orginal_func == nil then
    server_opts['on_attach'] = function(client, bufnr)
      configure_keymappings()
    end
  else
    server_opts['on_attach'] = function(client, bufnr)
      on_attach_orginal_func(client, bufnr)
      configure_keymappings()
    end
  end
  return server_opts
end

M.setup = function(server_opts)
  require('lspconfig').gopls.setup(server_opts)
end

return M
