local M = {}

M.languages = {
  -- ========================
  -- Python
  -- ========================
  python = {
    treesitter = "python",
    lsp = { "pyright", "ruff" },
    linter = "mypy",
    dap = "debugpy",
  },

  cs = {
    treesitter = "c_sharp",
    -- roslyn.nvim handles setup outside lspconfig.
    lsp = "roslyn",
    formatter = "csharpier",
    dap = "netcoredbg",
  },

  -- ========================
  -- Core / Web
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
    dap = "js-debug-adapter",
  },
  typescript = {
    treesitter = "typescript",
    lsp = "ts_ls",
    formatter = "prettier",
    dap = "js-debug-adapter",
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
  json = {
    treesitter = "json",
    lsp = "jsonls",
    formatter = "prettier",
  },
  yaml = {
    treesitter = "yaml",
    lsp = "yamlls",
    formatter = "prettier",
  },
  toml = {
    treesitter = "toml",
    lsp = "taplo",
  },

  -- ========================
  -- Compiled / Data
  -- ========================
  rust = {
    treesitter = "rust",
    lsp = "rust_analyzer",
    dap = "codelldb",
  },
  zig = {
    treesitter = "zig",
    lsp = "zls",
  },
  cpp = {
    treesitter = "cpp",
    lsp = "clangd",
    formatter = "clang_format",
    dap = "codelldb",
  },
  haskell = {
    treesitter = "haskell",
    lsp = "hls",
  },
  sql = {
    treesitter = "sql",
    lsp = "sqlls",
    formatter = "sql_formatter",
  },
  docker = {
    treesitter = "dockerfile",
    lsp = "dockerls",
  },
}

-- ========================
-- Mason tools
-- ========================
M.get_mason_list = function()
  local list = {}
  local seen = {}

  local function add(name)
    if not seen[name] then
      table.insert(list, name)
      seen[name] = true
    end
  end

  add("black")

  for _, config in pairs(M.languages) do
    if config.lsp then
      if type(config.lsp) == "table" then
        for _, v in ipairs(config.lsp) do
          add(v)
        end
      else
        add(config.lsp)
      end
    end

    if config.formatter then
      local name = config.formatter
      if name == "clang_format" then
        name = "clang-format"
      end
      if name == "sql_formatter" then
        name = "sql-formatter"
      end

      add(name)
    end

    if config.linter then
      if type(config.linter) == "table" then
        for _, v in ipairs(config.linter) do
          add(v)
        end
      else
        add(config.linter)
      end
    end

    if config.dap then
      add(config.dap)
    end
  end
  return list
end

-- ========================
-- Treesitter parsers
-- ========================
M.get_treesitter_list = function()
  local list = { "vim", "vimdoc", "query", "markdown", "markdown_inline", "regex", "bash" }
  for _, config in pairs(M.languages) do
    if config.treesitter then
      table.insert(list, config.treesitter)
    end
  end
  return list
end

return M
