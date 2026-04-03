return {
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			{
				"rcarriga/nvim-notify",
				opts = {
					background_colour = "#1e1e2e", -- Catppuccin Mocha Base color to fix transparency warning
				},
			},
		},
		keys = {
			{ "<leader>nd", "<cmd>Noice dismiss<cr>", desc = "Dismiss All Notifications" },
			{ "<leader>nt", "<cmd>Noice telescope<cr>", desc = "Noice History (Telescope)" },
			{ "<leader>g:", ":Neogit ", desc = "Neogit Command Input" },
			{ "<leader>G:", ":Git ", desc = "Fugitive Command Input" },
		},
		config = function()
			require("noice").setup({
				lsp = {
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
				},
				presets = {
					bottom_search = true,
					command_palette = true,
					long_message_to_split = true,
					inc_rename = false,
					lsp_doc_border = true,
				},
				format = {
					cmdline = { pattern = "^:", icon = "", lang = "vim" },
					filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
				},
				views = {
					cmdline_popup = {
						border = { style = "rounded", padding = { 0, 1 } },
						filter_options = { win_options = { winhighlight = "Normal:Normal,FloatBorder:DiagnosticInfo" } },
					},
					popupmenu = {
						relative = "editor",
						position = { row = 8, col = "50%" },
						size = { width = 60, height = 10 },
						border = { style = "rounded", padding = { 0, 1 } },
						win_options = { winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" } },
					},
				},
				-- NEW: Filter out annoying, harmless Neovim deprecation warnings
				routes = {
					{
						filter = {
							event = "msg_show",
							any = {
								{ find = "position_encoding param is required" },
							},
						},
						opts = { skip = true },
					},
					{
						filter = {
							event = "notify",
							warning = true,
							find = "position_encoding param is required",
						},
						opts = { skip = true },
					},
				},
			})
		end,
	},
}
