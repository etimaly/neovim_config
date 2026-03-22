return {
	"folke/zen-mode.nvim",
	keys = {
		{ "<leader>z", "<cmd>ZenMode<cr>", desc = "Toggle zen mode" },
	},
	opts = {
		window = {
			backdrop = 0.95, -- shade the background of the other windows
			width = 120,
		},
	},
}
