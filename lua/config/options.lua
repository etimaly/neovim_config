local o = vim.o
o.cursorlineopt = "both" -- to enable cursorline!
-- Set inside autocmds.lua based on file type detection
--vim.cmd "set tabstop=4"
--vim.cmd "set softtabstop=4"
--vim.cmd "set shiftwidth=4"
vim.cmd("set ruler")
vim.cmd("set number") -- Show current line number
vim.cmd("set relativenumber") -- Show relative line numbers

vim.cmd("set foldmethod=expr")
vim.cmd("set foldexpr=nvim_treesitter#foldexpr()")
vim.cmd("set foldenable")

vim.opt.foldlevel = 99 -- Using ufo provider need a large value
vim.opt.foldlevelstart = 99 -- Start with all code unfolded

-- Make the active parameter bold and cyan (adjust color to your liking)
vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", { link = "Search" })
