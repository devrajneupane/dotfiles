local prettier = { "prettierd", "prettier" }

return {
    "stevearc/conform.nvim",
    cmd = { "ConformInfo" },
    init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
    opts = {
        formatters_by_ft = {
            css = { prettier },
            graphql = { prettier },
            html = { prettier },
            javascript = { prettier },
            javascriptreact = { prettier },
            json = { prettier },
            jsonc = { prettier },
            lua = { "stylua" },
            markdown = { prettier, "injected" },
            python = function(bufnr)
                if require("conform").get_formatter_info("ruff_format", bufnr).available then
                    return { "ruff_format" }
                else
                    return { "isort", "black" }
                end
            end,
            rust = { "rustfmt" },
            sh = { "shfmt" },
            sql = { "sql_formatter" },
            pgsql = { "sql_formatter" },
            typescript = { prettier },
            typescriptreact = { prettier },
            yaml = { prettier },
            ["_"] = { "trim_whitespace", "trim_newlines" },
        },
        formatters = {
            shfmt = {
                prepend_args = { "-i", "4" },
            },
            -- Dealing with old version of prettierd that doesn't support range formatting
            prettierd = {
                range_args = false,
            },
        },
        log_level = vim.log.levels.TRACE,
        -- format_after_save = { timeout_ms = 5000, lsp_fallback = true },
    },
    keys = {
        {
            "<leader>cf",
            function()
                require("conform").format({ async = true, lsp_fallback = true }, function(err)
                    if not err then
                        if vim.startswith(vim.api.nvim_get_mode().mode:lower(), "v") then
                            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
                        end
                    end
                end)
            end,
            mode = "",
            desc = "format buffer",
        },
        { "<leader>ci", "<Cmd>ConformInfo<CR>", desc = "conform info" },
    },
}
