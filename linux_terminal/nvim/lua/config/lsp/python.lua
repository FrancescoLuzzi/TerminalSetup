local M = {}

-- following lua/config/autoformat.lua logics
local group_name = 'kickstart-lsp-format-pyright'
local group = vim.api.nvim_create_augroup(group_name, { clear = true })

local function configure_keymappings(bufnr)
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
    buffer = bufnr,
    callback = function(args)
      require("conform").format({ bufnr = args.buf })
    end,
  })
end

M.customize_opts = function(server_opts)
  local on_attach_orginal_func = server_opts["on_attach"]
  if on_attach_orginal_func == nil then
    server_opts["on_attach"] = function(client, bufnr)
      configure_keymappings(bufnr)
    end
  else
    server_opts["on_attach"] = function(client, bufnr)
      on_attach_orginal_func(client, bufnr)
      configure_keymappings(bufnr)
    end
  end
  return server_opts
end

M.setup = function(server_opts)
  require('lspconfig').pyright.setup(server_opts)
end

return M
