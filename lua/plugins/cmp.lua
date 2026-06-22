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
