return {
    "nvimtools/none-ls.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local status_ok, null_ls = pcall(require, "null-ls")
        if not status_ok then return end

        local formatting = null_ls.builtins.formatting

        local lang_ok, lang_mod = pcall(require, "config.languages")
        if not lang_ok then return end

        local languages_config = lang_mod.languages
        local sources = {}

        local function register_tools(configured_tools, builtin_category, filetype)
            if not configured_tools then return end

            local tools = type(configured_tools) == "table" and configured_tools or { configured_tools }

            for _, tool_name in ipairs(tools) do
                local tool = builtin_category[tool_name]

                if tool then
                    table.insert(sources, tool.with({ filetypes = { filetype } }))
                else
                    vim.api.nvim_create_autocmd("FileType", {
                        pattern = filetype,
                        callback = function()
                            -- Defer notify to avoid blocking FileType handling.
                            vim.schedule(function()
                                vim.notify(
                                    string.format("[None-ls] Error: Tool '%s' is missing or misconfigured for '%s' files.", tool_name, filetype),
                                    vim.log.levels.ERROR
                                )
                            end)
                        end,
                        once = true,
                    })
                end
            end
        end

        for filetype, config in pairs(languages_config) do
            register_tools(config.formatter, formatting, filetype)
        end

        null_ls.setup({
            sources = sources,
        })
    end,
}
