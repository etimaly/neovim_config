local map = vim.keymap.set

-- ==========================================
-- Command / Escape
-- ==========================================
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })

-- ==========================================
-- File / Session
-- ==========================================
map("n", "<C-w>", "<cmd>w<cr>", { silent = true, desc = "Save" })
map("n", "<C-q>", "<cmd>q<cr>", { silent = true, desc = "Quit" })
map("n", "<C-u>", "<cmd>u<cr>", { silent = true, desc = "Undo" })

-- ==========================================
-- Window navigation
-- ==========================================
map("n", "<A-h>", "<C-w>h", { desc = "Go to Left Window" })
map("n", "<A-j>", "<C-w>j", { desc = "Go to Lower Window" })
map("n", "<A-k>", "<C-w>k", { desc = "Go to Upper Window" })
map("n", "<A-l>", "<C-w>l", { desc = "Go to Right Window" })

-- Window resizing
map("n", "<A-H>", "<cmd>vertical resize -2<cr>", { desc = "Resize Width -" })
map("n", "<A-J>", "<cmd>resize +2<cr>", { desc = "Resize Height +" })
map("n", "<A-K>", "<cmd>resize -2<cr>", { desc = "Resize Height -" })
map("n", "<A-L>", "<cmd>vertical resize +2<cr>", { desc = "Resize Width +" })

-- ==========================================
-- Text movement
-- ==========================================
map("n", "<C-j>", "<cmd>m .+1<cr>== ", { desc = "Move line down" })
map("n", "<C-k>", "<cmd>m .-2<cr>== ", { desc = "Move line up" })
map("v", "<C-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "<C-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- ==========================================
-- Word jumping
-- ==========================================
map("i", "<C-Up>", "<C-o>{", { desc = "Jump paragraph up" })
map("i", "<C-Down>", "<C-o>}", { desc = "Jump paragraph down" })
map("i", "<C-BS>", "<C-w>", { desc = "Delete previous word" })
map("i", "<C-H>", "<C-w>", { desc = "Delete previous word" })

-- ==========================================
-- Clipboard / Void
-- ==========================================
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete to Void" })
map("x", "<leader>p", [["_dP]], { desc = "Paste over (Keep original)" })

-- ==========================================
-- Terminal
-- ==========================================
map("n", "<leader>st", "<cmd>terminal<cr>", { desc = "Open Terminal" })
map("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit Terminal Mode" })
