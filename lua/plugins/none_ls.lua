return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local null_ls = require("null-ls")
		local formatting = null_ls.builtins.formatting
		local diagnostics = null_ls.builtins.diagnostics

		local languages_config = require("config.languages").languages
		local sources = {}

		for filetype, config in pairs(languages_config) do
			-- 1. Setup Formatter
			if config.formatter then
				-- TRY to find the formatter in standard builtins
				local tool = formatting[config.formatter]

				-- SPECIAL FIX FOR RUFF
				if config.formatter == "ruff" and not tool then
					-- Some versions call it ruff_format, some call it ruff
					tool = formatting.ruff_format or formatting.ruff
				end

				if tool then
					table.insert(sources, tool.with({ filetypes = { filetype } }))
				else
					vim.notify("None-ls: Formatter not found in builtins: " .. config.formatter, vim.log.levels.WARN)
				end
			end

			-- 2. Setup Linter
			if config.linter then
				local tool = diagnostics[config.linter]
				if tool then
					table.insert(sources, tool.with({ filetypes = { filetype } }))
				else
					vim.notify("None-ls: Linter not found: " .. config.linter, vim.log.levels.WARN)
				end
			end
		end

		null_ls.setup({
			sources = sources,
			on_attach = function(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ bufnr = bufnr, async = false })
						end,
					})
				end
			end,
		})
	end,
}
