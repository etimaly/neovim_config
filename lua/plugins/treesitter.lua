local lang_setup = require("config.languages")

return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	-- Ensure treesitter is loaded before this config runs
	lazy = false,
	config = function()
		-- Use a protected call to avoid crashing if the module is missing
		local status_ok, treesitter_configs = pcall(require, "nvim-treesitter.configs")
		if not status_ok then
			return
		end

		treesitter_configs.setup({
			ensure_installed = lang_setup.get_treesitter_list(),
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
