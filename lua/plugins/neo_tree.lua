return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons", -- optional, but recommended
		},
		lazy = false, -- neo-tree will lazily load itself

		-- Add the keymap directly here so it loads with the plugin
		keys = {
			{
				"<leader>e",
				function()
					-- Check if we are currently focused inside Neo-tree
					if vim.bo.filetype == "neo-tree" then
						local has_zen, zen_view = pcall(require, "zen-mode.view")
						-- If Zen Mode is active, force focus to its window FIRST
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
					-- 1. Change position to float
					position = "float",
					width = 30,

					-- 2. Zen-Safe Mappings
					mappings = {
						["<esc>"] = "close_window_zen_safe",
						["q"] = "close_window_zen_safe",
						["<cr>"] = "open_zen_safe",
						["l"] = "open_zen_safe",
					},
				},

				-- 3. Zen-Safe Commands
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

						-- Let Neo-tree open the file normally
						local fs_commands = require("neo-tree.sources.filesystem.commands")
						fs_commands.open(state)

						-- If Zen Mode was active, ensure it wraps around the new buffer
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
						visible = true, -- Show hidden files?
						hide_dotfiles = false,
						hide_gitignored = false,
					},
					follow_current_file = {
						enabled = true, -- Scroll to current file when opening
					},
				},
			})
		end,
	},
}
