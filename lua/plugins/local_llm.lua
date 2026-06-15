return {
	-- Tabby autocomplete
	{
		"TabbyML/vim-tabby",
		lazy = false,
		enabled = function()
			return vim.env.DISABLE_TABBY == nil
		end,
		dependencies = { "neovim/nvim-lspconfig" },
		init = function()
			local node_bin = vim.env.TABBY_NODE_BIN or vim.fn.exepath("node")
			local agent_js =
				vim.env.TABBY_AGENT_PATH
				or vim.fn.expand("~/.nvm/versions/node/v24.13.0/lib/node_modules/tabby-agent/dist/node/index.js")

			if node_bin ~= "" and vim.fn.executable(node_bin) == 1 and vim.fn.filereadable(agent_js) == 1 then
				vim.g.tabby_agent_start_command = { node_bin, agent_js, "--stdio" }
			else
				vim.notify("Tabby-agent path not found!", vim.log.levels.WARN)
			end

			vim.g.tabby_inline_completion_trigger = "auto"
			vim.keymap.set("i", "<C-Space>", function()
				return vim.fn["tabby#Complete"]()
			end, { expr = true })

			vim.cmd([[highlight TabbySuggestion guifg=#909090 gui=italic]])
			vim.g.tabby_inline_completion_debounce = 800
		end,
		config = function()
			local ok, tabby_lsp = pcall(require, "tabby.lsp.nvim_lsp")
			if not ok then
				return
			end

			tabby_lsp.request_inline_completion = function(params)
				local client = vim.lsp.get_clients({ name = "tabby" })[1]
				if not client then
					return 0
				end

				local inline_completion_params = vim.lsp.util.make_position_params(0, client.offset_encoding or "utf-16")
				inline_completion_params.context = {
					triggerKind = params.trigger_kind,
				}

				local request_id
				_, request_id = client.request("textDocument/inlineCompletion", inline_completion_params, function(_, result)
					vim.fn["tabby#lsp#nvim_lsp#CallInlineCompletionCallback"](request_id, result)
				end)

				return request_id
			end
		end,
	},

	-- Avante chat
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		lazy = false,
		version = false,
		opts = {
			provider = "ollama",

			auto_suggestions_provider = "ollama",

			providers = {
				ollama = {
					endpoint = "http://127.0.0.1:11434",
					model = "deepseek-r1:14b",
					timeout = 30000,
					temperature = 0,
					max_tokens = 4096,
				},
			},

			behaviour = {
				auto_suggestions = false,
				auto_set_highlight_group = true,
				auto_set_keymaps = true,
				auto_apply_diff_after_generation = false,
				support_paste_from_clipboard = false,
			},
		},
		build = "make",
			dependencies = {
				"nvim-treesitter/nvim-treesitter",
				"stevearc/dressing.nvim",
				"nvim-lua/plenary.nvim",
				"MunifTanjim/nui.nvim",
			},
		},
	}
