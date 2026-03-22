return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- Remove 'cmd = "Trouble"' and let 'keys' handle the lazy loading
	keys = {
		{
			"<leader>xx",
			function()
				require("trouble").toggle("diagnostics")
			end,
			desc = "Diagnostics (Trouble)",
		},
		{
			"<leader>xX",
			function()
				require("trouble").toggle({ mode = "diagnostics", filter = { buf = 0 } })
			end,
			desc = "Buffer Diagnostics (Trouble)",
		},
		{
			"<leader>cs",
			function()
				require("trouble").toggle("symbols")
			end,
			desc = "Symbols (Trouble)",
		},
		{
			"<leader>cl",
			function()
				require("trouble").toggle({ mode = "lsp", focus = false, win = { position = "right" } })
			end,
			desc = "LSP Definitions / references / ... (Trouble)",
		},
		{
			"<leader>xL",
			function()
				require("trouble").toggle("loclist")
			end,
			desc = "Location List (Trouble)",
		},
		{
			"<leader>xQ",
			function()
				require("trouble").toggle("qflist")
			end,
			desc = "Quickfix List (Trouble)",
		},
	},
	opts = {
		-- Automatically close the list when you have no diagnostics left
		auto_close = true,
		-- Restore focus to the window you were in after closing Trouble
		restore_focus = true,
	},
}
