local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local format_group = augroup("LspFormatting", { clear = true })
local format_clients = {
	["null-ls"] = true,
	ruff = true,
	lua_ls = true,
	hls = true,
	zls = true,
	taplo = true,
	rust_analyzer = true,
}

local function set_indent(width)
	vim.opt_local.shiftwidth = width
	vim.opt_local.tabstop = width
	vim.opt_local.softtabstop = width
	vim.opt_local.expandtab = true
end

autocmd("LspAttach", {
	group = format_group,
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)

		local telescope = require("telescope.builtin")

		-- ==========================================
		-- LSP keymaps
		-- ==========================================
		local map = function(mode, keys, func, opts)
			opts = opts or {}
			opts.buffer = args.buf
			vim.keymap.set(mode, keys, func, opts)
		end

		map("n", "K", vim.lsp.buf.hover, { desc = "LSP toggle hover" })
		map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })

		map("n", "gi", telescope.lsp_implementations, { desc = "Telescope implementation" })
		map("n", "gr", telescope.lsp_references, { desc = "Telescope references" })
		map("n", "gd", telescope.lsp_definitions, { desc = "Telescope definition" })

		map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics (floating window)" })
		map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP code action (Quick fix)" })
		map("n", "<A-.>", vim.lsp.buf.code_action, { desc = "LSP code action" })

		map("n", "[d", vim.diagnostic.goto_prev, { desc = "Goto Prev Diagnostic" })
		map("n", "]d", vim.diagnostic.goto_next, { desc = "Goto Next Diagnostic" })

		map("n", "<leader>ra", vim.lsp.buf.rename, { desc = "LSP Rename Variable" })

		map("n", "<leader>fm", function()
			vim.lsp.buf.format({ async = true })
		end, { desc = "LSP Format File" })

		map("n", "gl", function()
			vim.diagnostic.open_float({
				focusable = true,
				focus = true,
			})
		end, { desc = "Show Diagnostic Float" })

		map("i", "<C-k>", function()
			vim.lsp.buf.signature_help({ border = "rounded" })
		end, { desc = "Show Signature Help" })

		-- ==========================================
		-- Format on save
		-- ==========================================
		if not client or not client.supports_method("textDocument/formatting") then
			return
		end

		local buffer_format_group = augroup("LspFormat_" .. args.buf, { clear = true })
		autocmd("BufWritePre", {
			group = buffer_format_group,
			buffer = args.buf,
			callback = function()
				vim.lsp.buf.format({
					bufnr = args.buf,
					async = false,
					timeout = 500,
					filter = function(c)
						return format_clients[c.name] == true
					end,
				})
			end,
		})
	end,
})

-- 2-space filetypes
autocmd("FileType", {
	pattern = { "lua", "javascript", "typescript", "javascriptreact", "typescriptreact", "html", "css", "json", "yaml", "toml" },
	callback = function()
		set_indent(2)
	end,
})

-- 4-space filetypes
autocmd("FileType", {
	pattern = { "python", "c", "cpp", "rust", "go", "cs", "zig" },
	callback = function()
		set_indent(4)
	end,
})
