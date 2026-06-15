-- LSP server overrides
local server_settings = {
    pyright = {
        settings = {
            python = {
                analysis = { typeCheckingMode = "off" },
            },
        },
    },
    ruff = {
        on_attach = function(client)
            client.server_capabilities.hoverProvider = false
        end,
    },
}

local function force_utf16_capabilities(capabilities)
    capabilities.general = capabilities.general or {}
    capabilities.general.positionEncodings = { "utf-16" }
    capabilities.offsetEncoding = { "utf-16" }
end

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
        -- LSP UI
        -- ==========================================================
        local handlers = {
            ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
            ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
        }

        for method, handler in pairs(handlers) do
            vim.lsp.handlers[method] = handler
        end

        -- ==========================================================
        -- Mason
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

        local lang_ok, lang_setup = pcall(require, "config.languages")
        local install_list = lang_ok and lang_setup.get_mason_list() or {}

        require("mason-tool-installer").setup({
            ensure_installed = install_list,
            auto_update = true,
            run_on_start = true,
        })

        -- ==========================================================
        -- LSP config
        -- ==========================================================
        require("mason-lspconfig").setup({
            automatic_enable = false,
        })

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
        if status_ok then
            local success, default_caps = pcall(function()
                return cmp_nvim_lsp.default_capabilities(capabilities)
            end)
            if success then
                capabilities = default_caps
            end
        end

        force_utf16_capabilities(capabilities)

        local function setup_server(server_name)
            if server_name == "roslyn" then
                return
            end

            local config = {
                capabilities = vim.deepcopy(capabilities),
                offset_encoding = "utf-16",
            }
            local custom = server_settings[server_name]

            if custom then
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

            vim.lsp.config(server_name, config)
            vim.lsp.enable(server_name)
        end

        if lang_ok then
            for _, config in pairs(lang_setup.languages) do
                if type(config.lsp) == "table" then
                    for _, server_name in ipairs(config.lsp) do
                        setup_server(server_name)
                    end
                elseif config.lsp then
                    setup_server(config.lsp)
                end
            end
        end
    end,
}
