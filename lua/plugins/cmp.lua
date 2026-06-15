return {
	"hrsh7th/nvim-cmp",
	lazy = false,
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"L3MON4D3/LuaSnip",
		"rafamadriz/friendly-snippets",
		"onsails/lspkind.nvim",
	},
	config = function()
		local cmp_ok, cmp = pcall(require, "cmp")
		local luasnip_ok, luasnip = pcall(require, "luasnip")
		local lspkind_ok, lspkind = pcall(require, "lspkind")

		if not cmp_ok then
			return
		end

		if luasnip_ok then
			require("luasnip.loaders.from_vscode").lazy_load()
		end

		local has_words_before = function()
			unpack = unpack or table.unpack
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
		end

		local capture_completion_suffix = function()
			local cursor = vim.api.nvim_win_get_cursor(0)
			local suffix = vim.fn.matchstr(vim.api.nvim_get_current_line():sub(cursor[2] + 1), [[^\k\+]])
			if suffix == "" then
				return nil
			end

			return { row = cursor[1], suffix = suffix }
		end

		local cleanup_completion_suffix = function(captured)
			if not captured then
				return
			end

			vim.schedule(function()
				local cursor = vim.api.nvim_win_get_cursor(0)
				if cursor[1] ~= captured.row then
					return
				end

				local suffix_end = cursor[2] + #captured.suffix
				local line = vim.api.nvim_get_current_line()
				if line:sub(cursor[2] + 1, suffix_end) ~= captured.suffix then
					return
				end
				if cursor[2] < #captured.suffix or line:sub(cursor[2] - #captured.suffix + 1, cursor[2]) ~= captured.suffix then
					return
				end

				vim.api.nvim_buf_set_text(0, cursor[1] - 1, cursor[2], cursor[1] - 1, suffix_end, { "" })
			end)
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

			mapping = cmp.mapping.preset.insert({
				["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
				["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
				["<C-Space>"] = cmp.mapping.complete(),
				["<CR>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						local suffix = capture_completion_suffix()
						cmp.confirm({
							behavior = cmp.ConfirmBehavior.Replace,
							select = true,
						}, function()
							cleanup_completion_suffix(suffix)
						end)
					else
						fallback()
					end
				end, { "i", "s" }),

				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
					elseif luasnip_ok and luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					elseif has_words_before() then
						cmp.complete()
					else
						local key = vim.api.nvim_replace_termcodes("<Tab>", true, false, true)
						vim.api.nvim_feedkeys(key, "n", false)
					end
				end, { "i", "s" }),

				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
					elseif luasnip_ok and luasnip.jumpable(-1) then
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
	end,
}
