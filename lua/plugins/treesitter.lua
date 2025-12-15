local lang_setup = require("config.languages")

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = lang_setup.get_treesitter_list(),
      
      -- Add standard requirements manually if desired
      -- ensure_installed = { "vim", "vimdoc", "query", unpack(lang_setup.get_treesitter_list()) },

      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}
