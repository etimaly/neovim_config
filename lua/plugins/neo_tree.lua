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
				function()
					if vim.bo.filetype == "neo-tree" then
						local has_zen, zen_view = pcall(require, "zen-mode.view")
						-- Return focus to Zen before closing Neo-tree.
						if has_zen and zen_view.win and vim.api.nvim_win_is_valid(zen_view.win) then
							vim.api.nvim_set_current_win(zen_view.win)
						end
						vim.cmd("Neotree close")
					else
						vim.cmd("Neotree toggle")
					end
				end,
				desc = "Toggle Neo-tree (Zen-Safe)",
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
						["<esc>"] = "close_window_zen_safe",
						["q"] = "close_window_zen_safe",
						["<cr>"] = "open_zen_safe",
						["l"] = "open_zen_safe",
					},
				},

				-- Zen-safe commands
				commands = {
					close_window_zen_safe = function()
						local has_zen, zen_view = pcall(require, "zen-mode.view")
						if has_zen and zen_view.win and vim.api.nvim_win_is_valid(zen_view.win) then
							vim.api.nvim_set_current_win(zen_view.win)
						end
						vim.cmd("Neotree close")
					end,

					open_zen_safe = function(state)
						local has_zen, zen_view = pcall(require, "zen-mode.view")
						local is_zen_active = has_zen and zen_view.win and vim.api.nvim_win_is_valid(zen_view.win)

						local fs_commands = require("neo-tree.sources.filesystem.commands")
						fs_commands.open(state)

						-- Reopen Zen around the selected buffer.
						if is_zen_active then
							vim.defer_fn(function()
								if not (zen_view.win and vim.api.nvim_win_is_valid(zen_view.win)) then
									require("zen-mode").toggle()
								end
							end, 10)
						end
					end,
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
