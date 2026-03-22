vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.mappings")
require("config.options")
require("config.autocmds")

require("config.lazy")

vim.opt.clipboard = "unnamedplus"

-- Add rounded borders to all LSP floating windows
local border = "rounded"

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })

vim.diagnostic.config({
	float = { border = border },
})
