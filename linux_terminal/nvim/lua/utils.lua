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

return Utils
