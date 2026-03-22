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
            registries = {
                "github:mason-org/mason-registry",
                "github:Crashdummyy/mason-registry",
            },
            ui = {
                border = "rounded",
            },
        })

        -- [THE FIX] Safely load your language config inside the setup block
        local lang_ok, lang_setup = pcall(require, "config.languages")
        local install_list = lang_ok and lang_setup.get_mason_list() or {}

        -- Auto-installs everything defined in your config/languages.lua safely
        require("mason-tool-installer").setup({
            ensure_installed = install_list,
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
                    if server_name == "roslyn" then
                        return
                    end

                    local lspconfig = require("lspconfig")

                    -- A. Define Capabilities
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

                    -- B. Global Encoding Fix
                    capabilities.offsetEncoding = { "utf-8" }

                    -- C. Build Config
                    local config = { capabilities = capabilities }

                    -- D. Apply Custom Settings
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

                    lspconfig[server_name].setup(config)
                end,
            },
        })
    end,
}
