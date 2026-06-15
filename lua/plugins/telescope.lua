return {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{ "<leader>fw", "<cmd>Telescope live_grep<cr>", desc = "Find Word (Live Grep)" },
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
		{ "<leader>fc", "<cmd>Telescope grep_string<cr>", desc = "Find Word Under Cursor" },
		{ "<leader>gc", "<cmd>Telescope commands<cr>", desc = "Git Commands Palette" },
	},
	opts = {
		defaults = {
			borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
		},
	},
}
