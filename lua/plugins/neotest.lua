return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",

		"nvim-neotest/neotest-python",
		"mrcjkb/neotest-haskell",
		"alfaix/neotest-gtest",
	},
	config = function()
		local neotest = require("neotest")

		neotest.setup({
			icons = {
				passed = " ",
				running = " ",
				failed = " ",
				unknown = " ",
				skipped = " ",
				non_collapsible = "─",
				collapsed = "",
				expanded = "",
				child_prefix = "├",
				final_child_prefix = "╰",
				child_indent = "│",
				final_child_indent = " ",
				compiler = " ",
				env = " ",
				test = " ",
			},

			floating = {
				border = "rounded",
				max_height = 0.8,
				max_width = 0.8,
				options = {},
			},

			summary = {
				animated = true,
				mappings = {
					expand = { "<CR>", "<2-LeftMouse>" },
					expand_all = "e",
					output = "o",
					short = "O",
					attach = "a",
					jumpto = "i",
					stop = "u",
					mark = "m",
					run = "r",
				},
			},

			output = {
				open_on_run = false,
			},

			adapters = {
				-- ====================================================
				-- Python
				-- ====================================================
				require("neotest-python")({
					runner = function()
						if vim.fn.glob("pytest.ini") ~= "" or vim.fn.glob("pyproject.toml") ~= "" then
							return "pytest"
						else
							return "unittest"
						end
					end,

					dap = { justMyCode = false },
				}),

				-- ====================================================
				-- Haskell
				-- ====================================================
				require("neotest-haskell")({
					build_tools = { "cabal" },
				}),

				-- ====================================================
				-- Google Test
				-- ====================================================
				require("neotest-gtest").setup({
					root = require("neotest.lib").files.match_root_pattern(
						"compile_commands.json",
						"CMakeLists.txt",
						".git"
					),
				}),
			},
		})
	end,

	keys = {
		{ "<leader>t", "", desc = "+test" },
		{
			"<leader>tt",
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			desc = "Run File",
		},
		{
			"<leader>tr",
			function()
				require("neotest").run.run()
			end,
			desc = "Run Nearest",
		},
		{
			"<leader>ts",
			function()
				require("neotest").summary.toggle()
			end,
			desc = "Toggle Summary",
		},
		{
			"<leader>to",
			function()
				require("neotest").output.open({ enter = true, auto_close = true })
			end,
			desc = "Show Output (Float)",
		},
		{
			"<leader>tP",
			function()
				require("neotest").output_panel.toggle()
			end,
			desc = "Toggle Output Panel",
		},
	},
}
