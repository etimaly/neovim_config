return {
	-- 1. AUTOCOMPLETE (The "Ghost Text")
	-- Connects to Tabby on Port 8080
	{
		"TabbyML/vim-tabby",
		lazy = false,
		enabled = function()
			return vim.env.DISABLE_TABBY == nil
		end,
		dependencies = { "neovim/nvim-lspconfig" },
		init = function()
			-- 1. The Critical Path Config (Keep this!)
			local node_bin = vim.fn.exepath("node")
			local agent_js =
				vim.fn.expand("~/.nvm/versions/node/v24.13.0/lib/node_modules/tabby-agent/dist/node/index.js")

			if node_bin ~= "" and vim.fn.filereadable(agent_js) == 1 then
				vim.g.tabby_agent_start_command = { node_bin, agent_js, "--stdio" }
			else
				-- Fallback if the NVM path is wrong
				vim.notify("Tabby-agent path not found!", vim.log.levels.WARN)
			end

			-- 2. Trigger Settings

			vim.g.tabby_inline_completion_trigger = "auto"
			vim.keymap.set("i", "<C-Space>", function()
				return vim.fn["tabby#Complete"]()
			end, { expr = true })

			-- 3. THE COLOR FIX (This runs automatically now)
			-- This forces the ghost text to be a visible grey (italic)
			vim.cmd([[highlight TabbySuggestion guifg=#909090 gui=italic]])
			-- Wait 800ms after you stop typing before asking the AI
			vim.g.tabby_inline_completion_debounce = 800
		end,
	},

	-- 2. CHAT & AGENT (The Sidebar)
	-- Connects to Ollama on Port 11434
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		lazy = false,
		version = false,
		opts = {
			-- 1. Switch the provider to ollama
			provider = "ollama",

			-- 2. Explicitly tell it to use ollama for suggestions (though we disable them below for Tabby)
			auto_suggestions_provider = "ollama",

			-- 3. The NEW configuration format (Native Provider)
			providers = {
				ollama = {
					-- Note: NO "/v1" at the end for the native provider!
					endpoint = "http://127.0.0.1:11434",
					model = "deepseek-r1:14b",
					timeout = 30000, -- 30 seconds
					temperature = 0,
					max_tokens = 4096,
				},
			},

			-- 4. Behavior settings (Keep Tabby as your autocomplete)
			behaviour = {
				auto_suggestions = false, -- Disable Avante's ghost text so Tabby can do it
				auto_set_highlight_group = true,
				auto_set_keymaps = true,
				auto_apply_diff_after_generation = false,
				support_paste_from_clipboard = true,
			},
		},
		build = "make",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"HakonHarnes/img-clip.nvim",
		},
	},
}
