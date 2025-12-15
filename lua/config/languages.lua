local M = {}

-- Key = Language ID (internal)
-- Value = Tools config
M.languages = {
  -- ========================
  -- PYTHON (The "Pro" Stack)
  -- ========================
  python = {
    treesitter = "python",
    -- Pyright for Completion, Ruff for speed/linting
    lsp = { "pyright", "ruff" },
    -- formatter = "ruff", -- ruff already handles it -- Conform calls it 'ruff_format'
    linter = "mypy", -- Nvim-lint calls it 'mypy'
  },

  -- ========================
  -- CORE / WEB
  -- ========================
  lua = {
    treesitter = "lua",
    lsp = "lua_ls",
    formatter = "stylua",
  },
  javascript = {
    treesitter = "javascript",
    lsp = "ts_ls",
    formatter = "prettier",
  },
  typescript = {
    treesitter = "typescript",
    lsp = "ts_ls",
    formatter = "prettier",
  },
  html = {
    treesitter = "html",
    lsp = "html",
    formatter = "prettier",
  },
  css = {
    treesitter = "css",
    lsp = "cssls",
    formatter = "prettier",
  },

  -- ========================
  -- COMPILED / DATA
  -- ========================
  cpp = {
    treesitter = "cpp",
    lsp = "clangd",
    formatter = "clang_format",
  },
  haskell = {
    treesitter = "haskell",
    lsp = "hls", -- Haskell Language Server
    -- formatter = "ormolu", already included in hls -- Standard formatter
  },
  sql = {
    treesitter = "sql",
    lsp = "sqlls",
    formatter = "sql_formatter",
  },
  docker = {
    treesitter = "dockerfile",
    lsp = "dockerls",
    -- formatter = "hadolint",
    linter = "hadolint",
  },
}

-- ========================
-- HELPER FUNCTIONS
-- ========================
M.get_mason_list = function()
  local list = {}

  -- 1. Add overrides/globals
  table.insert(list, "black")

  -- 2. Loop through config
  for _, config in pairs(M.languages) do
    -- Add LSPs
    if config.lsp then
      if type(config.lsp) == "table" then
        for _, v in ipairs(config.lsp) do
          table.insert(list, v)
        end
      else
        table.insert(list, config.lsp)
      end
    end

    -- Add Formatters (Convert underscores back to hyphens for Mason if needed)
    if config.formatter then
      local name = config.formatter
      if name == "clang_format" then
        name = "clang-format"
      end
      if name == "sql_formatter" then
        name = "sql-formatter"
      end

      table.insert(list, name)
    end

    -- Add Linters
    if config.linter then
      table.insert(list, config.linter)
    end
  end
  return list
end

-- ========================
-- TREESITTER LIST GENERATOR (ADD THIS!)
-- ========================
M.get_treesitter_list = function()
  -- Start with default requirements for Neovim itself
  local list = { "vim", "vimdoc", "query", "markdown", "markdown_inline", "regex", "bash" }
  for _, config in pairs(M.languages) do
    if config.treesitter then
      table.insert(list, config.treesitter)
    end
  end
  return list
end

return M
