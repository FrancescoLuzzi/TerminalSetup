return {
	'rbong/vim-flog',
	init = function()
		vim.keymap.set(
			'n', '<leader>gg', '<cmd>Flog',
			{ desc = '[G]it [G]raph' })
	end
}
