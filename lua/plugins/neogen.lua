return {
	"danymat/neogen",
	cmd = "Neogen",
	opts = {
		snippet_engine = "luasnip",
	},
	keys = {
		{
			"<leader>ng",
			function()
				require("neogen").generate()
			end,
			desc = "Generate docs",
		},
	},
}
