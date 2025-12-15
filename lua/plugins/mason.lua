local lang_setup = require("config.languages")

return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"neovim/nvim-lspconfig", -- Mandatory load
	},
	config = function()
		-- 1. Setup Mason Registry
		require("mason").setup()

		-- 2. INSTALLATION (Handled ONLY by tool-installer)
		-- This installs LSPs, Formatters, and Linters all at once.
		require("mason-tool-installer").setup({
			ensure_installed = lang_setup.get_mason_list(),
			auto_update = true,
			run_on_start = true,
		})

		-- 3. CONFIGURATION (Handled by lspconfig)
		require("mason-lspconfig").setup({
			-- CRITICAL FIX: We disable auto-install here because
			-- mason-tool-installer is already doing it above.
			-- This stops the "attempt to call field 'enable'" crash.
			automatic_installation = false,

			handlers = {
				function(server_name)
					local lspconfig = require("lspconfig")
					-- Safe capability loading to prevent crashes
					local capabilities = vim.lsp.protocol.make_client_capabilities()
					local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
					if status_ok then
						capabilities = cmp_nvim_lsp.default_capabilities()
					end

					local config = { capabilities = capabilities }

					-- Custom Settings for specific servers
					if server_name == "pyright" then
						config.settings = {
							python = {
								analysis = {
									typeCheckingMode = "off",
									ignore = { "*" },
								},
							},
						}
					end

					if server_name == "ruff" then
						-- Disable hover so it doesn't fight with Pyright
						config.on_attach = function(client)
							client.server_capabilities.hoverProvider = false
						end
					end

					lspconfig[server_name].setup(config)
				end,
			},
		})
	end,
}
