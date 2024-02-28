local M = {}

local function configure_keymappings()
  -- attach my LSP configs keybindings
  local wk = require('which-key')
  local default_options = { silent = true }
  wk.register({
    c = {
      name = 'GolangCoding',
      d = {
        name = 'Debug',
        c = { require('dap-go').debug_test, 'Run current test in debugger' },
      },
      e = { '<cmd>GoIfErr<cr>', 'Add if err' },
      h = {
        name = 'Helper',
        a = { '<cmd>GoAddTag<cr>', 'Add tags to struct' },
        r = { '<cmd>GoRMTag<cr>', 'Remove tags to struct' },
        c = { '<cmd>GoCoverage<cr>', 'Test coverage' },
        g = { "<cmd>lua require('go.comment').gen()<cr>", 'Generate comment' },
        v = { '<cmd>GoVet<cr>', 'Go vet' },
        t = { '<cmd>GoModTidy<cr>', 'Go mod tidy' },
        i = { '<cmd>GoModInit<cr>', 'Go mod init' },
      },
      l = { '<cmd>GoLint<cr>', 'Run linter' },
      o = { '<cmd>GoPkgOutline<cr>', 'Outline' },
      r = { '<cmd>GoRun<cr>', 'Run' },
      s = { '<cmd>GoFillStruct<cr>', 'Autofill struct' },
      t = {
        name = 'Tests',
        r = { '<cmd>GoTest<cr>', 'Run tests' },
        a = { '<cmd>GoAlt!<cr>', 'Open alt file' },
        s = { '<cmd>GoAltS!<cr>', 'Open alt file in split' },
        v = { '<cmd>GoAltV!<cr>', 'Open alt file in vertical split' },
        u = { '<cmd>GoTestFunc<cr>', 'Run test for current func' },
        f = { '<cmd>GoTestFile<cr>', 'Run test for current file' },
      },
    },
  }, { prefix = '<leader>', mode = 'n', default_options })
  wk.register({
    c = {
      -- name = "Coding",
      j = { "<cmd>'<,'>GoJson2Struct<cr>", 'Json to struct' },
    },
  }, { prefix = '<leader>', mode = 'v', default_options })
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
