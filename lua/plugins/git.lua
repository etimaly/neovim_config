return {
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "▎" },
					change = { text = "▎" },
					delete = { text = "" },
					topdelete = { text = "" },
					changedelete = { text = "▎" },
				},
				-- KEYMAPPINGS GO HERE
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					map("n", "]h", gs.next_hunk, { desc = "Next Git Hunk" })
					map("n", "[h", gs.prev_hunk, { desc = "Previous Git Hunk" })

					-- Actions
					map("n", "<leader>gh", gs.preview_hunk, { desc = "Preview Hunk" })
					map("n", "<leader>gb", function()
						gs.blame_line({ full = true })
					end, { desc = "Git Blame Line" })
					map("n", "<leader>gd", gs.diffthis, { desc = "Git Diff" })
				end,
			})
		end,
	},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- Required
			"sindrets/diffview.nvim", -- Optional: Powerful diff view
			"nvim-telescope/telescope.nvim", -- Optional
		},
		config = true, -- Runs require('neogit').setup() automatically
		keys = {
			{ "<leader>gg", "<cmd>Neogit<cr>", desc = "Open Neogit" },
			{ "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Git Commit" },
			{ "<leader>gp", "<cmd>Neogit push<cr>", desc = "Git Push" },
		},
	},
	{
		"tpope/vim-fugitive",
		cmd = "G", -- Load only when you type :G
		keys = {
			-- Open the Git Status window (like 'git status' but interactive)
			{ "<leader>gs", "<cmd>G<cr>", desc = "Git Status (Fugitive)" },
			-- Open Git Blame sidebar
			{ "<leader>gB", "<cmd>Git blame<cr>", desc = "Git Blame (Fugitive)" },
		},
	},
}
