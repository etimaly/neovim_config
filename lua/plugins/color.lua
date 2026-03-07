return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000, -- Load this before everything else so the UI doesn't flash
	config = function()
		require("catppuccin").setup({
			flavour = "mocha", -- Options: latte, frappe, macchiato, mocha
			background = {
				light = "latte",
				dark = "mocha",
			},
			transparent_background = true, -- Set to true if you want your terminal bg to show through
			term_colors = true,

			-- INTEGRATIONS
			-- This ensures plugins look good with the theme
			integrations = {
				cmp = true,
				gitsigns = true,
				nvimtree = true,
				treesitter = true,
				mason = true, -- Nice background for Mason
				native_lsp = {
					enabled = true,
					virtual_text = {
						errors = { "italic" },
						hints = { "italic" },
						warnings = { "italic" },
						information = { "italic" },
					},
					underlines = {
						errors = { "underline" },
						hints = { "underline" },
						warnings = { "underline" },
						information = { "underline" },
					},
					inlay_hints = {
						background = true,
					},
				},
			},
		})

		-- Apply the colorscheme
		vim.cmd.colorscheme("catppuccin")
	end,
}
