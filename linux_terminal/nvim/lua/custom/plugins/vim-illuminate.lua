return {
	'RRethy/vim-illuminate',
	init = function()
		require('illuminate').configure({
			delay = 250,
		})
		vim.api.nvim_set_hl(0, "IlluminatedWordText", { bg = "#4d5474" })
		vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bg = "#4d5474" })
		vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = "#4d5474" })

		--- auto update the highlight style on colorscheme change
		vim.api.nvim_create_autocmd({ "ColorScheme" }, {
			pattern = { "*" },
			callback = function(ev)
				vim.api.nvim_set_hl(0, "IlluminatedWordText", { bg = "#4d5474" })
				vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bg = "#4d5474" })
				vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = "#4d5474" })
			end
		})
	end
}
