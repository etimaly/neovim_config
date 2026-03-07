return {
	"seblyng/roslyn.nvim",
	ft = "cs",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("roslyn").setup({
			args = {
				"--logLevel=Information",
				"--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
			},
			config = {
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
				choose_target = function(targets)
					for _, target in ipairs(targets) do
						-- Prioritize the Unity .sln file
						if target:match("%.sln$") then
							return target
						end
					end
					return targets[1] -- Fallback to the first target found
				end,
			},
		})
	end,
}
