return {
  'RRethy/vim-illuminate',
  init = function()
    require('illuminate').configure({
      delay = 250,
      filetypes_denylist = {
        'alpha',
        'DressingInput',
        'fugitive',
        'lazy',
        'mason',
        'NvimTree',
        'TelescopePrompt',
        'toggleterm',
      },
    })
    local illuminate_bg = '#4f4536'
    vim.api.nvim_set_hl(0, 'IlluminateWordText', { bg = illuminate_bg })
    vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { bg = illuminate_bg })
    vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { bg = illuminate_bg })

    --- auto update the highlight style on colorscheme change
    vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
      pattern = { '*' },
      callback = function(ev)
        vim.api.nvim_set_hl(0, 'IlluminatedWordText', { bg = illuminate_bg })
        vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { bg = illuminate_bg })
        vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { bg = illuminate_bg })
      end,
    })
  end,
}
