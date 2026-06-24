return {
  "OXY2DEV/markview.nvim",
  lazy = false, -- The author recommends setting this to false for immediate loading
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons", -- Optional, for icons
    -- "saghen/blink.cmp" -- Uncomment if you use blink.cmp for completions
  },
  config = function()
    require("markview").setup({
      -- Explicitly enable the HTML renderer
      html = {
        enable = true,
      },
      preview = {
        -- Add "tex" to the list
        filetypes = { "markdown", "quarto", "rmd", "html", "tex" },
        ignore_buftypes = { "nofile", "prompt", "terminal" },
        ignore_filetypes = { "TelescopePrompt", "TelescopeResults" },
      },
    })
  end,
}
