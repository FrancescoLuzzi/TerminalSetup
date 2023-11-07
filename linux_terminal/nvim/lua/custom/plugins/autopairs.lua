return {
	'windwp/nvim-autopairs',
	dependencies = { 'hrsh7th/nvim-cmp', 'nvim-treesitter/nvim-treesitter' },
	config = function()
		require("nvim-autopairs").setup({
			check_ts = true,
			disable_filetype = { "sh", "bash", "TelescopePrompt" },
		})
		-- If you want to automatically add `(` after selecting a function or method
		local cmp_autopairs = require('nvim-autopairs.completion.cmp')
		local cmp = require('cmp')
		cmp.event:on(
			'confirm_done',
			cmp_autopairs.on_confirm_done()
		)
	end,
}
