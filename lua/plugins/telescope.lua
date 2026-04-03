return {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		-- <leader>fw : "Find Word" (Type to search project text)
		{ "<leader>fw", "<cmd>Telescope live_grep<cr>", desc = "Find Word (Live Grep)" },
		-- <leader>ff : "Find Files" (Search by filename)
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
		-- <leader>fc : "Find Cursor" (Find word under cursor)
		{ "<leader>fc", "<cmd>Telescope grep_string<cr>", desc = "Find Word Under Cursor" },
		-- In your keymaps or within the Telescope/Git config
		{ "<leader>gc", "<cmd>Telescope commands<cr>", desc = "Git Commands Palette" },
	},
	defaults = {
		borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
	},
}
