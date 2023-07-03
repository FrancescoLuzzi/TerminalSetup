return {
	"kiyoon/treesitter-indent-object.nvim",
	keys = {
		{
			"ai",
			"<Cmd>lua require'treesitter_indent_object.textobj'.select_indent_outer()<CR>",
			mode = { "x", "o" },
			desc = "a indent block",
		},
		{
			"aI",
			"<Cmd>lua require'treesitter_indent_object.textobj'.select_indent_outer(true)<CR>",
			mode = { "x", "o" },
			desc = "a line-wise indent block",
		},
		{
			"ii",
			"<Cmd>lua require'treesitter_indent_object.textobj'.select_indent_inner()<CR>",
			mode = { "x", "o" },
			desc = "inner indent",
		},
		{
			"iI",
			"<Cmd>lua require'treesitter_indent_object.textobj'.select_indent_inner(true)<CR>",
			mode = { "x", "o" },
			desc = "inner INDENT",
		},
	},
}
