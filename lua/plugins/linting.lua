return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint_status, lint = pcall(require, "lint")
		if not lint_status then
			return
		end

		local lang_ok, lang_mod = pcall(require, "config.languages")
		if not lang_ok then
			return
		end

		local linters_by_ft = {}

		for filetype, config in pairs(lang_mod.languages) do
			if config.linter then
				local tools = type(config.linter) == "table" and config.linter or { config.linter }
				linters_by_ft[filetype] = tools
			end
		end

		lint.linters_by_ft = linters_by_ft

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
