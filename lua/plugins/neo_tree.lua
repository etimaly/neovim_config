return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		lazy = false,

		keys = {
			{
				"<leader>e",
				"<cmd>Neotree toggle<cr>",
				desc = "Toggle Neo-tree",
			},
			{ "<leader>o", "<cmd>Neotree focus<cr>", desc = "Focus Explorer" },
			{ "<leader>E", "<cmd>Neotree reveal<cr>", desc = "Reveal File in Explorer" },
		},

		config = function()
			require("neo-tree").setup({
				popup_border_style = "rounded",
				window = {
					position = "float",
					width = 30,

					mappings = {
						["<esc>"] = "close_window",
						["q"] = "close_window",
					},
				},

				filesystem = {
					filtered_items = {
						visible = true,
						hide_dotfiles = false,
						hide_gitignored = false,
					},
					follow_current_file = {
						enabled = true,
					},
				},
			})
		end,
	},
}
