return {
	"hrsh7th/nvim-cmp",
	lazy = false,
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"rafamadriz/friendly-snippets",
		"onsails/lspkind.nvim",
	},
	config = function()
		local cmp_ok, cmp = pcall(require, "cmp")
		local luasnip_ok, luasnip = pcall(require, "luasnip")
		local lspkind_ok, lspkind = pcall(require, "lspkind")
		local completion_item_kind = vim.lsp.protocol.CompletionItemKind

		if not cmp_ok then
			return
		end

		if luasnip_ok then
			require("luasnip.loaders.from_vscode").lazy_load()
		end

		local function trigger_signature_help()
			vim.defer_fn(function()
				for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
					if client:supports_method("textDocument/signatureHelp") then
						vim.lsp.buf.signature_help({ border = "rounded" })
						return
					end
				end
			end, 50)
		end

		local function complete_python_call(entry)
			if vim.bo.filetype ~= "python" then
				return
			end

			local item = entry:get_completion_item()
			if item.insertTextFormat == vim.lsp.protocol.InsertTextFormat.Snippet then
				return
			end

			local is_call = item.kind == completion_item_kind.Function
				or item.kind == completion_item_kind.Method
				or item.kind == completion_item_kind.Constructor

			if not is_call then
				return
			end

			local row, col = unpack(vim.api.nvim_win_get_cursor(0))
			local line = vim.api.nvim_get_current_line()
			if line:sub(col + 1, col + 1) ~= "(" then
				vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { "()" })
				vim.api.nvim_win_set_cursor(0, { row, col + 1 })
			end

			trigger_signature_help()
		end

		cmp.setup({
			snippet = {
				expand = function(args)
					if luasnip_ok then
						luasnip.lsp_expand(args.body)
					end
				end,
			},

			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},

			formatting = {
				format = lspkind_ok and lspkind.cmp_format({
					mode = "symbol_text",
					maxwidth = 50,
					ellipsis_char = "...",
					show_labelDetails = true,
				}) or nil,
			},

			confirmation = {
				default_behavior = cmp.ConfirmBehavior.Replace,
			},

			matching = {
				disallow_partial_fuzzy_matching = false,
			},

			mapping = cmp.mapping.preset.insert({
				["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
				["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
				["<C-Space>"] = cmp.mapping.complete(),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip_ok and luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip_ok and luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),

			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "buffer" },
				{ name = "path" },
			}),
		})

		cmp.event:on("confirm_done", function(event)
			if event.entry and event.entry.source.name == "nvim_lsp" then
				complete_python_call(event.entry)
			end
		end)
	end,
}
