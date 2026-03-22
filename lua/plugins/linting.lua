return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		-- 1. Safely load nvim-lint
		local lint_status, lint = pcall(require, "lint")
		if not lint_status then
			return
		end

		-- 2. [THE FIX] Safely load your central languages configuration
		local lang_ok, lang_mod = pcall(require, "config.languages")
		if not lang_ok then
			return
		end

		local linters_by_ft = {}

		-- 3. [THE FIX] Dynamically map everything! No more hardcoding filetypes.
		for filetype, config in pairs(lang_mod.languages) do
			if config.linter then
				-- Normalize: If it's a string, wrap in a table. If it's already a table, keep it.
				-- This prevents nested table crashes!
				local tools = type(config.linter) == "table" and config.linter or { config.linter }
				linters_by_ft[filetype] = tools
			end
		end

		lint.linters_by_ft = linters_by_ft

		-- 4. Set up the auto-linting
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				-- nvim-lint is naturally very safe. If a tool is missing from the computer,
				-- try_lint() just silently aborts rather than crashing Neovim.
				lint.try_lint()
			end,
		})
	end,
}
