vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.mappings")
require("config.options")
require("config.autocmds")

-- Load Neovim's bundled Lua parser before nvim-treesitter can shadow it.
-- Neovim 0.12 runtime Lua queries require parser fields older installed parsers lack.
local bundled_lua_parser = vim.api.nvim_get_runtime_file("parser/lua.*", false)[1]
if bundled_lua_parser then
  pcall(vim.treesitter.language.add, "lua", { path = bundled_lua_parser })
end

require("config.lazy")

vim.opt.clipboard = "unnamedplus"

-- Add rounded borders to all LSP floating windows
local border = "rounded"

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })

vim.diagnostic.config({
  float = { border = border },
})
