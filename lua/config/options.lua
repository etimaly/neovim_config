local o = vim.o
o.cursorlineopt = "both" -- to enable cursorline!
-- Set inside autocmds.lua based on file type detection
--vim.cmd "set tabstop=4"
--vim.cmd "set softtabstop=4"
--vim.cmd "set shiftwidth=4"
vim.cmd("set ruler")
vim.cmd("set number") -- Show current line number
vim.cmd("set relativenumber") -- Show relative line numbers

-- Make the active parameter bold and cyan (adjust color to your liking)
vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", { link = "Search" })
