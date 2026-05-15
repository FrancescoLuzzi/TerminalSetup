local utils = require('utils')

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
  go = 'go',            -- go command, can be go[default] or go1.18beta1
  goimports = 'gopls',  -- goimport command, can be gopls[default] or goimport
  fillstruct = 'gopls', -- can be nil (use fillstruct, slower) and gopls
  gofmt = 'gofumpt',    -- gofmt cmd,
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
    local register_normal = utils.create_keymap_setter('n', bufnr)
    local register_visual = utils.create_keymap_setter('v', bufnr)

    utils.register_keymap_group('<leader>c', 'GolangCoding', bufnr)
    utils.register_keymap_group('<leader>cd', 'Debug', bufnr)
    utils.register_keymap_group('<leader>ch', 'Helper', bufnr)
    utils.register_keymap_group('<leader>ct', 'Tests', bufnr)

    register_normal('<leader>cdc', 'Run current test in debugger', function()
      require('dap-go').debug_test()
    end)
    register_normal('<leader>ce', 'Add if err', '<cmd>GoIfErr<cr>')
    register_normal('<leader>cha', 'Add tags to struct', '<cmd>GoAddTag<cr>')
    register_normal('<leader>chc', 'Test coverage', '<cmd>GoCoverage<cr>')
    register_normal('<leader>chg', 'Generate comment', "<cmd>lua require('go.comment').gen()<cr>")
    register_normal('<leader>chi', 'Go mod init', '<cmd>GoModInit<cr>')
    register_normal('<leader>chr', 'Remove tags to struct', '<cmd>GoRMTag<cr>')
    register_normal('<leader>cht', 'Go mod tidy', '<cmd>GoModTidy<cr>')
    register_normal('<leader>chv', 'Go vet', '<cmd>GoVet<cr>')
    register_normal('<leader>cl', 'Run linter', '<cmd>GoLint<cr>')
    register_normal('<leader>co', 'Outline', '<cmd>GoPkgOutline<cr>')
    register_normal('<leader>cr', 'Run', '<cmd>GoRun<cr>')
    register_normal('<leader>cs', 'Autofill struct', '<cmd>GoFillStruct<cr>')
    register_normal('<leader>cta', 'Open alt file', '<cmd>GoAlt!<cr>')
    register_normal('<leader>ctf', 'Run test for current file', '<cmd>GoTestFile<cr>')
    register_normal('<leader>ctr', 'Run tests', '<cmd>GoTest<cr>')
    register_normal('<leader>cts', 'Open alt file in split', '<cmd>GoAltS!<cr>')
    register_normal('<leader>ctu', 'Run test for current func', '<cmd>GoTestFunc<cr>')
    register_normal('<leader>ctv', 'Open alt file in vertical split', '<cmd>GoAltV!<cr>')
    register_visual('<leader>cj', 'Json to struct', "<cmd>'<,'>GoJson2Struct<cr>")
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
