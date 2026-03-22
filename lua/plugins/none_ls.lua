return {
    "nvimtools/none-ls.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local status_ok, null_ls = pcall(require, "null-ls")
        if not status_ok then return end

        local formatting = null_ls.builtins.formatting
        local diagnostics = null_ls.builtins.diagnostics

        local lang_ok, lang_mod = pcall(require, "config.languages")
        if not lang_ok then return end
        
        local languages_config = lang_mod.languages
        local sources = {}

        -- 2. Smart Helper: Registers tools and queues file-specific errors
        local function register_tools(configured_tools, builtin_category, filetype)
            if not configured_tools then return end

            local tools = type(configured_tools) == "table" and configured_tools or { configured_tools }

            for _, tool_name in ipairs(tools) do
                local tool = builtin_category[tool_name]
                
                if tool then
                    table.insert(sources, tool.with({ filetypes = { filetype } }))
                else
                    -- THE FIX: Queue an error to fire ONLY when this specific filetype is opened
                    vim.api.nvim_create_autocmd("FileType", {
                        pattern = filetype,
                        callback = function()
                            -- vim.schedule waits for the UI to fully draw so it doesn't cause a "Hit ENTER" block
                            vim.schedule(function()
                                vim.notify(
                                    string.format("[None-ls] Error: Tool '%s' is missing or misconfigured for '%s' files.", tool_name, filetype),
                                    vim.log.levels.ERROR
                                )
                            end)
                        end,
                        once = true, -- Set to true so it only yells at you once per session
                    })
                end
            end
        end

        -- 3. Loop through your central config
        for filetype, config in pairs(languages_config) do
            register_tools(config.formatter, formatting, filetype)
            register_tools(config.linter, diagnostics, filetype)
        end

        -- 4. Standard Setup
        null_ls.setup({
            sources = sources,
            on_attach = function(client, bufnr)
                if client.supports_method("textDocument/formatting") then
                    local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
                    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                    
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = augroup,
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({
                                bufnr = bufnr,
                                filter = function(f_client)
                                    return f_client.name == "null-ls"
                                end,
                                async = false,
                            })
                        end,
                    })
                end
            end,
        })
    end,
}
