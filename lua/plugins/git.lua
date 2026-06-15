return {
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns
				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				map("n", "]h", gs.next_hunk, { desc = "Next Hunk" })
				map("n", "[h", gs.prev_hunk, { desc = "Prev Hunk" })

				map("n", "<leader>ghp", gs.preview_hunk, { desc = "Preview Hunk" })
				map("n", "<leader>ghs", gs.stage_hunk, { desc = "Stage Hunk" })
				map("n", "<leader>ghu", gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
				map("n", "<leader>ghr", gs.reset_hunk, { desc = "Reset Hunk" })
				map("n", "<leader>gb", function()
					gs.blame_line({ full = true })
				end, { desc = "Blame Line" })
			end,
		},
	},

	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("neogit").setup({
				integrations = {
					diffview = true,
					telescope = true,
				},
				kind = "tab",
			})
		end,
		keys = {
			{ "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit Status" },
			{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
			{ "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
		},
	},

	{ "tpope/vim-fugitive" },
}
