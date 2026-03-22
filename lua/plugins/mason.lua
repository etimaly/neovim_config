local lang_setup = require("config.languages")

-- 1. SERVER SETTINGS
-- Custom configurations for specific LSPs
local server_settings = {
	pyright = {
		settings = {
			python = {
				analysis = { typeCheckingMode = "off", ignore = { "*" } },
			},
		},
	},
	ruff = {
		on_attach = function(client)
			client.server_capabilities.hoverProvider = false
		end,
	},
	clangd = {
		capabilities = { offsetEncoding = { "utf-16" } },
	},
	roslyn = { offsetEncoding = { "utf-16" } },
}

-- 2. THE PLUGIN SPEC
return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"neovim/nvim-lspconfig",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/nvim-cmp",
	},
	config = function()
		-- ==========================================================
		-- 1. VISUAL TWEAKS (Borders for Hover/Signature)
		-- ==========================================================
		local handlers = {
			["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
			["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
		}

		for method, handler in pairs(handlers) do
			vim.lsp.handlers[method] = handler
		end

		-- ==========================================================
		-- 2. MASON CORE SETUP
		-- ==========================================================
		require("mason").setup({
			-- Added the Crashdummyy registry so Mason can find 'roslyn'
			registries = {
				"github:mason-org/mason-registry",
				"github:Crashdummyy/mason-registry",
			},
			ui = {
				border = "rounded",
			},
		})

		-- Auto-installs everything defined in your config/languages.lua
		require("mason-tool-installer").setup({
			ensure_installed = lang_setup.get_mason_list(),
			auto_update = true,
			run_on_start = true,
		})

		-- ==========================================================
		-- 3. LSPCONFIG INTEGRATION
		-- ==========================================================
		require("mason-lspconfig").setup({
			automatic_installation = false,
			handlers = {
				function(server_name)
					-- IMPORTANT: Skip roslyn here.
					-- The 'roslyn.nvim' plugin handles its own setup.
					if server_name == "roslyn" then
						return
					end

					local lspconfig = require("lspconfig")

					-- A. Define Capabilities (Safe Method with CMP check)
					local capabilities = vim.lsp.protocol.make_client_capabilities()
					local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
					if status_ok then
						local success, default_caps = pcall(function()
							return cmp_nvim_lsp.default_capabilities()
						end)
						if success then
							capabilities = default_caps
						end
					end

					-- B. Global Encoding Fix (Required for clangd/roslyn)
					capabilities.offsetEncoding = { "utf-8" }

					-- C. Build Config
					local config = { capabilities = capabilities }

					-- D. Apply Custom Settings from the table at the top
					if server_settings[server_name] then
						local custom = server_settings[server_name]
						if custom.settings then
							config.settings = custom.settings
						end
						if custom.on_attach then
							config.on_attach = custom.on_attach
						end
						if custom.capabilities then
							config.capabilities = vim.tbl_deep_extend("force", config.capabilities, custom.capabilities)
						end
					end

					-- Finalize setup for this server
					lspconfig[server_name].setup(config)
				end,
			},
		})
	end,
}
