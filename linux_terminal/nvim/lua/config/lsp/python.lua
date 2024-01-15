local M = {}

local function pip_install()
  vim.ui.input(
    { prompt = 'Install packages (separated by space): ' },
    function(packages)
      vim.cmd("!pip install " .. packages)
    end
  )
end

local function pip_freeze()
  if vim.loop.os_uname().sysname:match("Windows") then
    vim.cmd('!pip freeze | Out-File -Encoding UTF8 ' .. vim.loop.cwd() .. '/requirements.txt')
  else
    vim.cmd('!pip freeze > ' .. vim.loop.cwd() .. '/requirements.txt')
  end
end

local function configure_keymappings(bufnr)
  -- attach my LSP configs keybindings
  local wk = require("which-key")
  local default_options = { silent = true }
  wk.register({
    c = {
      name = "PythonCoding",
      p = {
        name = "Pip commands",
        i = { pip_install, "Install package" },
        r = { pip_freeze, "Generate requirements.txt" },

      },
    },
  }, { prefix = "<leader>", mode = "n", default_options })
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
