return {
	'simrat39/rust-tools.nvim',
	dependencies = {
		'neovim/nvim-lspconfig',
		{
			"saecki/crates.nvim",
			version = "v0.3.0",
			dependencies = { "nvim-lua/plenary.nvim" },
			init = function()
				require("crates").setup {
					-- null_ls = {
					-- 	enabled = true,
					-- 	name = "crates.nvim",
					-- },
					popup = {
						border = "rounded",
					},
				}
			end,
			'nvim-lua/popup.nvim'
		}
	},
}
