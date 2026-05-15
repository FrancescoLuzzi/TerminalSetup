vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind

    if name == 'nvim-treesitter' and (kind == 'update' or kind == 'install') then
      require('go.install').update_all_sync()
    end
  end,
})

vim.pack.add({
  { src = 'https://github.com/ray-x/go.nvim' },
  { src = 'https://github.com/ray-x/guihua.lua' },
})

require('go').setup({
  go = 'go', -- go command, can be go[default] or go1.18beta1
  goimports = 'gopls', -- goimport command, can be gopls[default] or goimport
  fillstruct = 'gopls', -- can be nil (use fillstruct, slower) and gopls
  gofmt = 'gofumpt', -- gofmt cmd,
  diagnostic = {
    underline = false,
  },
  lsp_codelens = true, -- set to false to disable codelens, true by default
  lsp_keymaps = false, -- set to false to disable gopls/lsp keymap
  lsp_document_formatting = false,
  lsp_inlay_hints = {
    enable = false,
  },
})

return {
  on_attach = function(_client, bufnr)
    local keymaps = require('keymaps')
    keymaps.add({
      { '<leader>c', group = 'GolangCoding' },
      { '<leader>cd', group = 'Debug' },
      {
        '<leader>cdc',
        function()
          require('dap-go').debug_test()
        end,
        desc = 'Run current test in debugger',
      },
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
      {
        '<leader>ctf',
        '<cmd>GoTestFile<cr>',
        desc = 'Run test for current file',
      },
      { '<leader>ctr', '<cmd>GoTest<cr>', desc = 'Run tests' },
      {
        '<leader>cts',
        '<cmd>GoAltS!<cr>',
        desc = 'Open alt file in split',
      },
      {
        '<leader>ctu',
        '<cmd>GoTestFunc<cr>',
        desc = 'Run test for current func',
      },
      {
        '<leader>ctv',
        '<cmd>GoAltV!<cr>',
        desc = 'Open alt file in vertical split',
      },
      {
        '<leader>cj',
        "<cmd>'<,'>GoJson2Struct<cr>",
        desc = 'Json to struct',
        mode = 'v',
      },
    }, { buffer = bufnr })
  end,
  settings = {
    gopls = {
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
    cmd = {
      'gopls',
      '-remote.debug=:0',
    },
  },
}
