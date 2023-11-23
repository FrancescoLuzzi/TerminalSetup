local M = {}


local function configure_keymappings()
  -- configure extra mappings
end

M.customize_opts = function(server_opts)
  local on_attach_orginal_func = server_opts["on_attach"]
  if on_attach_orginal_func == nil then
    server_opts["on_attach"] = function(client, bufnr)
      configure_keymappings()
    end
  else
    server_opts["on_attach"] = function(client, bufnr)
      on_attach_orginal_func(client, bufnr)
      configure_keymappings()
    end
  end
  return server_opts
end

M.setup = function(server_opts)
  require('lspconfig').lemminx.setup(server_opts)
end

return M
