local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local format_group = augroup("LspFormatting", { clear = true })

autocmd("LspAttach", {
  group = format_group,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    if client.supports_method("textDocument/formatting") then
      autocmd("BufWritePre", {
        group = format_group,
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({
            bufnr = args.buf,
            async = false,
            timeout = 200,
            filter = function(c)
              -- ADD "hls" HERE:
              return c.name == "null-ls" or c.name == "ruff" or c.name == "lua_ls" or c.name == "hls"
            end,
          })
        end,
      })
    end
  end,
})

-- 2 Spaces: Lua, Javascript, TypeScript, HTML, CSS, JSON
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua", "javascript", "typescript", "javascriptreact", "typescriptreact", "html", "css", "json" },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.expandtab = true
  end,
})

-- 4 Spaces: Python, C, C++, Rust, Go
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "c", "cpp", "rust", "go" },
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.expandtab = true
  end,
})
