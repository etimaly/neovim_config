return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	lazy = false,
	config = function()
		-- 1. Safely load the Treesitter configs
		local status_ok, treesitter_configs = pcall(require, "nvim-treesitter.configs")
		if not status_ok then
			return
		end

		-- 2. [THE FIX] Safely load your central languages configuration inside the setup
		local lang_ok, lang_setup = pcall(require, "config.languages")

		-- If languages.lua has a typo, fallback to Neovim's bare-minimum required list so the UI still loads
		local ts_list = lang_ok and lang_setup.get_treesitter_list() or { "c", "lua", "vim", "vimdoc", "query" }

		treesitter_configs.setup({
			ensure_installed = ts_list,

			-- 3. [THE FIX] Turn this off!
			-- Prevents blocking errors on computers missing a C compiler
			auto_install = false,

			-- Install parsers asynchronously (avoids freezing the UI during bulk installs)
			sync_install = false,

			highlight = {
				enable = true,

				-- 4. [BONUS] The Safety Valve: Disable Treesitter on files larger than 100KB
				-- Prevents Neovim from freezing when opening massive minified files or DB dumps
				disable = function(lang, buf)
					local max_filesize = 100 * 1024 -- 100 KB
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
