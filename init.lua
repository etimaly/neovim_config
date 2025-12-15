vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.mappings")
require("config.options")
require("config.autocmds")

require("config.lazy")

vim.opt.clipboard = "unnamedplus"
