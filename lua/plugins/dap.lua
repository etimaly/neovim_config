return {
  "mfussenegger/nvim-dap",
  dependencies = {
    -- UI for the debugger
    "rcarriga/nvim-dap-ui",
    -- Virtual text for the debugger (shows values inline)
    "theHamsta/nvim-dap-virtual-text",
    -- Bridge between Mason and nvim-dap
    "jay-babu/mason-nvim-dap.nvim", -- FIXED: jay-babu, not jay-bhoumick
    -- Required for dap-ui
    "nvim-neotest/nvim-nio",
  },
  keys = {
    {
      "<leader>db",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Toggle Breakpoint",
    },
    {
      "<leader>dc",
      function()
        require("dap").continue()
      end,
      desc = "Continue / Start",
    },
    {
      "<leader>di",
      function()
        require("dap").step_into()
      end,
      desc = "Step Into",
    },
    {
      "<leader>do",
      function()
        require("dap").step_out()
      end,
      desc = "Step Out",
    },
    {
      "<leader>dn",
      function()
        require("dap").step_over()
      end,
      desc = "Step Over",
    },
    {
      "<leader>dr",
      function()
        require("dap").repl.open()
      end,
      desc = "Open REPL",
    },
    {
      "<leader>du",
      function()
        require("dapui").toggle()
      end,
      desc = "Toggle DAP UI",
    },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    -- 1. Setup UI
    dapui.setup()

    -- 2. Setup Virtual Text
    require("nvim-dap-virtual-text").setup({})

    -- 3. Open UI automatically when debugging starts
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

    -- 4. Setup Mason Integration
    require("mason-nvim-dap").setup({
      -- Ensures the adapters defined in your tools file are set up
      automatic_installation = true,

      handlers = {
        function(config)
          require("mason-nvim-dap").default_setup(config)
        end,

        -- Custom configurations (Overrides)
        -- specific args for Python
        python = function(config)
          config.adapters = {
            type = "executable",
            command = vim.fn.exepath("python3") or vim.fn.exepath("python"),
            args = { "-m", "debugpy.adapter" },
          }
          require("mason-nvim-dap").default_setup(config)
        end,
      },

      ensure_installed = {},
    })
  end,
}
