return {
	"mfussenegger/nvim-dap",
	dependencies = {
		-- UI for the debugger
		"rcarriga/nvim-dap-ui",
		-- Virtual text for the debugger (shows values inline)
		"theHamsta/nvim-dap-virtual-text",
		-- Bridge between Mason and nvim-dap
		"jay-babu/mason-nvim-dap.nvim",
		-- Required for dap-ui
		"nvim-neotest/nvim-nio",
	},
	keys = {
		{
			"<leader>db",
			function()
				local ok, dap = pcall(require, "dap")
				if ok then
					dap.toggle_breakpoint()
				end
			end,
			desc = "Toggle Breakpoint",
		},
		{
			"<leader>dc",
			function()
				local ok, dap = pcall(require, "dap")
				if ok then
					dap.continue()
				end
			end,
			desc = "Continue / Start",
		},
		{
			"<leader>di",
			function()
				local ok, dap = pcall(require, "dap")
				if ok then
					dap.step_into()
				end
			end,
			desc = "Step Into",
		},
		{
			"<leader>do",
			function()
				local ok, dap = pcall(require, "dap")
				if ok then
					dap.step_out()
				end
			end,
			desc = "Step Out",
		},
		{
			"<leader>dn",
			function()
				local ok, dap = pcall(require, "dap")
				if ok then
					dap.step_over()
				end
			end,
			desc = "Step Over",
		},
		{
			"<leader>dr",
			function()
				local ok, dap = pcall(require, "dap")
				if ok then
					dap.repl.open()
				end
			end,
			desc = "Open REPL",
		},
		{
			"<leader>du",
			function()
				local ok, dapui = pcall(require, "dapui")
				if ok then
					dapui.toggle()
				end
			end,
			desc = "Toggle DAP UI",
		},
	},
	config = function()
		-- 1. PROTECTIVE REQUIRES
		-- If these fail (e.g., plugin not downloaded yet), the function exits silently
		local dap_status, dap = pcall(require, "dap")
		local dapui_status, dapui = pcall(require, "dapui")
		local mason_dap_status, mason_dap = pcall(require, "mason-nvim-dap")

		if not (dap_status and dapui_status) then
			return
		end

		-- 2. SETUP UI & VIRTUAL TEXT
		dapui.setup()

		local vt_status, dap_vt = pcall(require, "nvim-dap-virtual-text")
		if vt_status then
			dap_vt.setup({})
		end

		-- 3. AUTOMATION: OPEN/CLOSE UI
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		-- 4. MASON-DAP INTEGRATION
		if mason_dap_status then
			mason_dap.setup({
				-- This will look at what's in your languages.lua
				-- (provided mason-tool-installer is running)
				automatic_installation = true,

				handlers = {
					function(config)
						mason_dap.default_setup(config)
					end,

					-- Specialized Python setup to handle different OS paths
					python = function(config)
						local path = vim.fn.exepath("python3")
						if path == "" then
							path = vim.fn.exepath("python")
						end

						if path ~= "" then
							config.adapters = {
								type = "executable",
								command = path,
								args = { "-m", "debugpy.adapter" },
							}
						end
						mason_dap.default_setup(config)
					end,
				},
				-- ensure_installed is empty here because your
				-- M.get_mason_list() in languages.lua handles the master list.
				ensure_installed = {},
			})
		end
	end,
}
