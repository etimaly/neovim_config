return {
	"seblyng/roslyn.nvim",
	ft = "cs",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		capabilities.general = capabilities.general or {}
		capabilities.general.positionEncodings = { "utf-16" }
		capabilities.offsetEncoding = { "utf-16" }

		require("roslyn").setup({
			args = {
				"--logLevel=Information",
				"--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
			},
			config = {
				capabilities = capabilities,
				offset_encoding = "utf-16",
				choose_target = function(targets)
					for _, target in ipairs(targets) do
						if target:match("%.sln$") then
							return target
						end
					end
					return targets[1]
				end,
			},
		})
	end,
}
