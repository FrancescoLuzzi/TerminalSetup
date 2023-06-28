return {
	-- Set lualine as statusline
	'nvim-lualine/lualine.nvim',
	-- See `:help lualine.txt`
	opts = {
		options = {
			icons_enabled = true,
			theme = 'onedark',
			component_separators = { left = '', right = '' },
			section_separators = { left = '', right = '' },
			globalstatus = true,
		},
		sections = {
			lualine_c = {
				{ 'filename', path = 1 },
				{
					'diagnostics',
					sources = { 'nvim_diagnostic' },
					symbols = {
						error = ' ',
						warn = ' ',
						info = ' '
					}
				},
			},
		},
	},
}
