return {
	'akinsho/bufferline.nvim',
	init = function()
		require('bufferline').setup {
			options = {
				diagnostics = "nvim_lsp",

				diagnostics_indicator = function(_, _, diagnostics, _)
					local result = {}
					local symbols = {
						error = "",
						warning = "",
						info = "",
					}
					for name, count in pairs(diagnostics) do
						if symbols[name] and count > 0 then
							table.insert(result, symbols[name] .. " " .. count)
						end
					end
					local result_str = table.concat(result, " ")
					return #result_str > 0 and result_str or ""
				end

			}
		}
	end
}
