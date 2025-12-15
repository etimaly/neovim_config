local map = vim.keymap.set
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Force the border specifically for this command
map("i", "<C-k>", function()
	vim.lsp.buf.signature_help({ border = "rounded" })
end, { desc = "Show Signature Help" })
map("n", "K", vim.lsp.buf.hover, { desc = "LSP toggle hover" })

map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "<A-.>", vim.lsp.buf.code_action, { desc = "LSP code action" })

map("n", "<C-q>", ":q <CR>")
map("n", "<C-u>", ":u <CR>")
map("n", "<C-w>", ":w <CR>")

map("n", "<A-j>", ":m .+1<cr>==", { noremap = true, silent = true, desc = "Move line down" })
map("n", "<A-k>", ":m .-2<cr>==", { noremap = true, silent = true, desc = "Move line up" })

-- [NEW] Window Resizing (Control + Arrow Keys)
map("n", "<C-Up>", ":resize -2<CR>", { desc = "Resize Height -" })
map("n", "<C-Down>", ":resize +2<CR>", { desc = "Resize Height +" })
map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Resize Width -" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Resize Width +" })

-- [NEW] Diagnostic Navigation
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Goto Prev Diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Goto Next Diagnostic" })

-- [NEW] Smart Rename: Renames variable under cursor across the whole project
map("n", "<leader>ra", vim.lsp.buf.rename, { desc = "LSP Rename Variable" })

-- [NEW] Format File: Prettifies code (indentation/spacing)
map("n", "<leader>fm", function()
	vim.lsp.buf.format({ async = true })
end, { desc = "LSP Format File" })

-- Toggle File Explorer
-- map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle File Explorer" })

-- OR if you prefer using Space + e to Toggle (instead of just focus)
-- map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle File Explorer" })

-- MAP: Exit Terminal Mode with ESC
map("t", "<ESC>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

map("n", "gl", function()
	vim.diagnostic.open_float({
		focusable = true, -- THIS is the key
		focus = true, -- Automatically jumps into the window
	})
end, { desc = "Show Diagnostic Float" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- ========================
-- NEO-TREE SHORTCUTS
-- ========================

-- <leader>e : Toggle the File Explorer (Open/Close)
map("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle Explorer" })

-- <leader>o : Focus the Explorer (Jump to it without closing)
map("n", "<leader>o", "<cmd>Neotree focus<cr>", { desc = "Focus Explorer" })

-- <leader>E : Reveal current file in Explorer (Find where I am)
map("n", "<leader>E", "<cmd>Neotree reveal<cr>", { desc = "Reveal File in Explorer" })

-- ========================
-- TELESCOPE (SEARCH)
-- ========================

-- <leader>fw : "Find Word" (Type to search project text)
map("n", "<leader>fw", "<cmd>Telescope live_grep<cr>", { desc = "Find Word (Live Grep)" })

-- <leader>ff : "Find Files" (Search by filename)
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })

-- <leader>fc : "Find Cursor" (Find word under cursor)
map("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find Word Under Cursor" })

-- ======================
-- ZEN MODE
-- ======================

map("n", "<leader>z", "<cmd>ZenMode<cr>", { desc = "Toggle zen mode" })

-- ========================
-- GIT (NEOGIT)
-- ========================

-- <leader>gg : Open the Neogit Status Window
map("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Open Neogit" })

-- <leader>gc : Open Commit View immediately
map("n", "<leader>gc", "<cmd>Neogit commit<cr>", { desc = "Git Commit" })

-- <leader>gp : Git Push
map("n", "<leader>gp", "<cmd>Neogit push<cr>", { desc = "Git Push" })

-- ========================
-- FUGITIVE
-- ========================

-- Open the Git Status window (like 'git status' but interactive)
map("n", "<leader>gs", "<cmd>G<cr>", { desc = "Git Status (Fugitive)" })

-- Open Git Blame sidebar
map("n", "<leader>gB", "<cmd>Git blame<cr>", { desc = "Git Blame (Fugitive)" })
