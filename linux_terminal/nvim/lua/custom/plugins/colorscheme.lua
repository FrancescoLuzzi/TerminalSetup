return {
	'LunarVim/lunar.nvim',
	priority = 1000,
	lazy = false,
	config = function()
		vim.cmd.colorscheme 'lunar'
		-- set background transparent
		local hl_groups = {
			"Normal",
			"SignColumn",
			"NormalNC",
			"TelescopeBorder",
			"NvimTreeNormal",
			"NvimTreeNormalNC",
			"EndOfBuffer",
			"MsgArea",
		}
		for _, name in ipairs(hl_groups) do
			vim.cmd(string.format("highlight %s ctermbg=none guibg=none", name))
		end
		vim.opt.fillchars = "eob: "
	end,
}
