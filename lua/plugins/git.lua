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
		"sindrets/diffview.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = {
			"DiffviewOpen",
			"DiffviewFileHistory",
			"DiffviewClose",
			"DiffviewToggleFiles",
			"DiffviewFocusFiles",
			"DiffviewRefresh",
		},
		keys = {
			{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
			{ "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
		},
		config = function()
			require("diffview").setup()

			vim.api.nvim_create_user_command("DiffviewClose", function(ctx)
				if not ctx.bang then
					local ok, err = pcall(require("diffview").close)

					if not ok then
						if tostring(err):find("E445", 1, true) then
							vim.notify(
								"Diffview has unwritten changes; write buffers or run :DiffviewClose!",
								vim.log.levels.WARN
							)
						else
							error(err, 0)
						end
					end

					return
				end

				local lib = require("diffview.lib")
				if not lib.get_current_view() then
					return
				end

				local tabnr = vim.fn.tabpagenr()

				if #vim.api.nvim_list_tabpages() == 1 then
					vim.cmd("tabnew")
				end

				vim.cmd("tabclose! " .. tabnr)

				vim.schedule(function()
					lib.dispose_stray_views()
				end)
			end, { bang = true, force = true })
		end,
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
		},
	},

	{ "tpope/vim-fugitive" },
}
