return {
  "ray-x/go.nvim",
  dependencies = {
    "ray-x/guihua.lua",
  },
  ft = { "go", "gomod" },
  build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  config = function()
    require("go").setup({
      -- NOTE: all LSP and formatting related options are disabeld.
      -- NOTE: is not related to core.plugins.lsp
      -- NOTE: manages LSP on its own
      go = "go",            -- go command, can be go[default] or go1.18beta1
      goimport = "gopls",   -- goimport command, can be gopls[default] or goimport
      fillstruct = "gopls", -- can be nil (use fillstruct, slower) and gopls
      gofmt = "gofumpt",    -- gofmt cmd,
      lsp_diag_underline = false,
      lsp_codelens = true,  -- set to false to disable codelens, true by default
      lsp_keymaps = false,  -- set to false to disable gopls/lsp keymap
      lsp_diag_hdlr = true, -- hook lsp diag handler
      lsp_document_formatting = false,
      lsp_inlay_hints = {
        enable = false
      }
    })
  end,
}