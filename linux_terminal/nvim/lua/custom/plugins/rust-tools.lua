return {
	'simrat39/rust-tools.nvim',
	dependencies = {
		'neovim/nvim-lspconfig'
	},
	init = function()
		require("rust-tools").setup({
			tools = {
				executor = require("rust-tools/executors").termopen, -- can be quickfix or termopen
				reload_workspace_from_cargo_toml = true,
				inlay_hints = {
					auto = true,
					only_current_line = false,
					show_parameter_hints = true,
					parameter_hints_prefix = "<-",
					other_hints_prefix = "=>",
					max_len_align = false,
					max_len_align_padding = 1,
					right_align = false,
					right_align_padding = 7,
					highlight = "Comment",
				},
			},
		})
	end
}
