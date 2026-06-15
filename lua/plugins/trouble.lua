return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
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
		auto_close = true,
		restore_focus = true,
	},
}
