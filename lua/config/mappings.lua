local map = vim.keymap.set
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<leader>st", ":terminal<CR>", { desc = "Open terminal in new split" })
map("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode to normal mode" })

-- Paste over selected text without losing the original yanked text
map("x", "<leader>p", [["_dP]], { desc = "Paste and keep current register" })

-- Delete text into the "void" register (doesn't overwrite your copy)
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yanking" })

map("n", "<C-q>", ":q <CR>")
map("n", "<C-u>", ":u <CR>")
map("n", "<C-w>", ":w <CR>")

map("n", "<A-j>", ":m .+1<cr>==", { noremap = true, silent = true, desc = "Move line down" })
map("n", "<A-k>", ":m .-2<cr>==", { noremap = true, silent = true, desc = "Move line up" })

-- ==========================================
-- Modern Editor Keymaps (Arrows & Navigation)
-- ==========================================

-- 1. Window Resizing (Control + Shift + Arrows)
-- Note: If these don't work, check your terminal emulator's shortcut settings!
map("n", "<A-Up>", ":resize -2<CR>", { desc = "Resize Height -" })
map("n", "<A-Down>", ":resize +2<CR>", { desc = "Resize Height +" })
map("n", "<A-Left>", ":vertical resize -2<CR>", { desc = "Resize Width -" })
map("n", "<A-Right>", ":vertical resize +2<CR>", { desc = "Resize Width +" })

-- 2. Jumping in Text - Normal Mode (Control + Arrows)
map("n", "<C-Left>", "b", { desc = "Jump word backward" })
map("n", "<C-Right>", "w", { desc = "Jump word forward" })
map("n", "<C-Up>", "{", { desc = "Jump paragraph up" })
map("n", "<C-Down>", "}", { desc = "Jump paragraph down" })

-- 3. Jumping in Text - Insert Mode (Control + Arrows)
-- Uses <C-o> to let you jump around without leaving Insert mode
map("i", "<C-Left>", "<C-o>b", { desc = "Jump word backward" })
map("i", "<C-Right>", "<C-o>w", { desc = "Jump word forward" })
map("i", "<C-Up>", "<C-o>{", { desc = "Jump paragraph up" })
map("i", "<C-Down>", "<C-o>}", { desc = "Jump paragraph down" })

-- 4. Modern Backspace (Control + Backspace)
-- Deletes the entire previous word while typing
map("i", "<C-BS>", "<C-w>", { desc = "Delete previous word" })

-- MAP: Exit Terminal Mode with ESC
map("t", "<ESC>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
