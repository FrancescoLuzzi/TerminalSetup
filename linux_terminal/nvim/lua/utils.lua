vim.pack.add({
  {
    src = 'https://github.com/folke/which-key.nvim',
    version = 'main',
  },
})

local Utils = {}

Utils.is_windows = vim.fn.has('win32') == 1

--- @class ArrayFromOption
--- @field start number|nil
--- @field stop number

--- @param option ArrayFromOption
--- @param callback fun(index: number): any
Utils.array_from = function(option, callback)
  local result = {}

  for i = option.start or 0, option.stop do
    result[#result + 1] = callback(i)
  end

  return result
end

--- @param func fun()
Utils.once = function(func)
  local called = false
  return function()
    if not called then
      called = true
      func()
    end
  end
end

--- @param name string
Utils.create_augroup = function(name)
  return vim.api.nvim_create_augroup('fluzzi_custom_agroup_' .. name, { clear = true })
end

--- @param name string
--- @param func fun()
Utils.create_usrcmd = function(name, func)
  vim.api.nvim_create_user_command(name, func, { desc = 'usercmd for' .. name })
end

--- @param modes string|string[] Mode "short-name" (see |nvim_set_keymap()|), or a list thereof.
--- @param bufnr number|nil
--- @return fun(mapping:string, desc:string, rhs:string|fun(), opts:vim.keymap.set.Opts|nil)
Utils.create_keymap_setter = function(modes, bufnr)
  return function(mapping, desc, rhs, opts)
    vim.keymap.set(
      modes,
      mapping,
      rhs,
      vim.tbl_extend('force', {
        buffer = bufnr,
        desc = desc,
      }, opts or {})
    )
  end
end

--- @param mapping string
--- @param description string
--- @param bufnr number|nil
Utils.register_keymap_group = function(mapping, description, bufnr)
  local entry = {
    mapping,
    group = description,
  }

  if (bufnr or 0) ~= 0 then
    entry.buffer = bufnr
  end

  require('which-key').add({ entry })
end

return Utils
