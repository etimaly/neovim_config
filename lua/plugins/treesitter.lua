return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	lazy = false,
	config = function()
		local status_ok, treesitter_configs = pcall(require, "nvim-treesitter.configs")
		if not status_ok then
			return
		end

		local lang_ok, lang_setup = pcall(require, "config.languages")

		local ts_list = lang_ok and lang_setup.get_treesitter_list() or { "c", "lua", "vim", "vimdoc", "query" }

		treesitter_configs.setup({
			ensure_installed = ts_list,

			auto_install = false,

			sync_install = false,

			highlight = {
				enable = true,

				-- Avoid Treesitter on large generated files.
				disable = function(lang, buf)
					local max_filesize = 100 * 1024
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,
			},

			indent = { enable = true },
		})
	end,
}
