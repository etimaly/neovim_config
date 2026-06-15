local o = vim.o
o.cursorlineopt = "both"
vim.cmd("set ruler")
vim.cmd("set number")
vim.cmd("set relativenumber")

vim.cmd("set foldmethod=expr")
vim.cmd("set foldexpr=nvim_treesitter#foldexpr()")
vim.cmd("set foldenable")

vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", { link = "Search" })
