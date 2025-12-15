local lang_setup = require("config.languages")

-- 1. SERVER SETTINGS
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
}

-- 2. THE PLUGIN
return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "neovim/nvim-lspconfig",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/nvim-cmp", -- <--- ADDED THIS: Forces CMP to be available
  },
  config = function()
    require("mason").setup()

    require("mason-tool-installer").setup({
      ensure_installed = lang_setup.get_mason_list(),
      auto_update = true,
      run_on_start = true,
    })

    require("mason-lspconfig").setup({
      automatic_installation = false,
      handlers = {
        function(server_name)
          local lspconfig = require("lspconfig")

          -- A. Define Capabilities (Safe Method)
          local capabilities = vim.lsp.protocol.make_client_capabilities()

          -- We try to load cmp_nvim_lsp. If it fails, we stick to default capabilities.
          local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
          if status_ok then
            -- We wrap this in another pcall because 'default_capabilities' can crash
            -- if nvim-cmp isn't fully loaded yet.
            local success, default_caps = pcall(function()
              return cmp_nvim_lsp.default_capabilities()
            end)
            if success then
              capabilities = default_caps
            end
          end

          -- B. Global Encoding Fix
          capabilities.offsetEncoding = { "utf-16" }

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
