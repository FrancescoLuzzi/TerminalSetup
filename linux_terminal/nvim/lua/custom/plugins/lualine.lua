return {
	-- Set lualine as statusline
	'nvim-lualine/lualine.nvim',
	-- See `:help lualine.txt`
	opts = {
		options = {
			icons_enabled = true,
			theme = 'lunar',
			component_separators = { left = '', right = '' },
			section_separators = { left = '', right = '' },
			globalstatus = true,
		},
		sections = {
			lualine_b = {
				'branch',
				'diff',
				{
					'diagnostics',
					sources = { 'nvim_diagnostic' },
					symbols = {
						error = " ",
						warning = " ",
						info = " ",
					}
				}
			},
			lualine_c = {
				{ 'filename', path = 1 }
			},
			lualine_y = {
				{ 'datetime', style = "%H:%M | %d/%m/%y" }
			},
		},
	},
}
