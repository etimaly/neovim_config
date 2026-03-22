return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",

		-- ADAPTERS
		"nvim-neotest/neotest-python", -- Supports Pytest and Unittest
		"mrcjkb/neotest-haskell", -- Haskell (Cabal/Stack/Dune)
		"alfaix/neotest-gtest", -- Google Test
	},
	config = function()
		local neotest = require("neotest")

		neotest.setup({
			adapters = {
				-- ====================================================
				-- 1. Python (Pytest & Unittest)
				-- ====================================================
				require("neotest-python")({
					-- Dynamic runner determination based on file existence
					runner = function()
						if vim.fn.glob("pytest.ini") ~= "" or vim.fn.glob("pyproject.toml") ~= "" then
							return "pytest"
						else
							return "unittest"
						end
					end,

					-- Debugging settings (requires nvim-dap)
					dap = { justMyCode = false },

					-- Custom criteria to recognize test files if defaults fail
					-- is_test_file = function(file_path) ... end
				}),

				-- ====================================================
				-- 2. Haskell
				-- ====================================================
				require("neotest-haskell")({
					-- Default build tool is 'cabal', but you can change to 'stack'
					build_tools = { "cabal" },
				}),

				-- ====================================================
				-- 3. Google Test (C++)
				-- ====================================================
				require("neotest-gtest").setup({
					-- Helps the adapter find your compiled test executables.
					-- It looks for compile_commands.json or .git by default.
					root = require("neotest.lib").files.match_root_pattern(
						"compile_commands.json",
						"CMakeLists.txt",
						".git"
					),
					-- If your tests are not recognized, run :ConfigureGtest to map them manually
				}),
			},
		})
	end,

	-- Keybindings
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
			desc = "Show Output",
		},
	},
}
