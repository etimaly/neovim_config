return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false,                 -- neo-tree will lazily load itself
    config = function()
      require("neo-tree").setup({
        window = {
          position = "left",
          width = 30,
        },
        filesystem = {
          filtered_items = {
            visible = true, -- Show hidden files?
            hide_dotfiles = false,
            hide_gitignored = false,
          },
          follow_current_file = {
            enabled = true, -- Scroll to current file when opening
          },
        },
      })
    end,
  },
}
