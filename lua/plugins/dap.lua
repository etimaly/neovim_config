return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text",
		"jay-babu/mason-nvim-dap.nvim",
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
		local dap_status, dap = pcall(require, "dap")
		local dapui_status, dapui = pcall(require, "dapui")
		local mason_dap_status, mason_dap = pcall(require, "mason-nvim-dap")

		if not (dap_status and dapui_status) then
			return
		end

		dapui.setup()

		local vt_status, dap_vt = pcall(require, "nvim-dap-virtual-text")
		if vt_status then
			dap_vt.setup({})
		end

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

		if mason_dap_status then
			mason_dap.setup({
				automatic_installation = true,

				handlers = {
					function(config)
						mason_dap.default_setup(config)
					end,
				},
				-- config.languages owns the master install list.
				ensure_installed = {},
			})
		end
	end,
}
