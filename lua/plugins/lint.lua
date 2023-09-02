local uv = vim.uv or vim.loop
return {
    "mfussenegger/nvim-lint",
    ft = {
        "javascript",
        "javascriptreact",
        "lua",
        "python",
        "rst",
        "sh",
        "typescript",
        "typescriptreact",
        "yaml",
    },
    opts = {
        linters_by_ft = {
            javascript = { "eslint_d" },
            javascriptreact = { "eslint_d" },
            markdown = { "markdownlint" },
            lua = { "luacheck" },
            -- python = { "mypy" },
            -- rst = { "rstlint" },
            sh = { "shellcheck" },
            typescript = { "eslint_d" },
            typescriptreact = { "eslint_d" },
            yaml = { "yamllint" },
        },
        linters = {
            -- FIX: linting madness
            -- selene = {
            --     condition = function(ctx)
            --         return vim.fs.find({ "selene.toml" }, { path = ctx.filename, upward = true })[1]
            --     end,
            -- },
            -- luacheck = {
            --     condition = function(ctx)
            --         return vim.fs.find({ ".luacheckrc" }, { path = ctx.filename, upward = true })[1]
            --     end,
            -- },
        },
    },
    config = function(_, opts)
        local lint = require("lint")
        lint.linters_by_ft = opts.linters_by_ft
        for name, linter in pairs(opts.linters) do
            if type(linter) == "table" and type(lint.linters[name]) == "table" then
                lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
            else
                lint.linters[name] = linter
            end
        end
        local timer = assert(uv.new_timer())
        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "TextChanged", "InsertLeave" }, {
            group = vim.api.nvim_create_augroup("Lint", { clear = true }),
            callback = function()
                local bufnr = vim.api.nvim_get_current_buf()
                timer:stop()
                timer:start(
                    500,
                    0,
                    vim.schedule_wrap(function()
                        if vim.api.nvim_buf_is_valid(bufnr) then
                            vim.api.nvim_buf_call(bufnr, function()
                                if not vim.diagnostic.is_disabled() then
                                    lint.try_lint(nil, { ignore_errors = false })
                                end
                            end)
                        end
                    end)
                )
            end,
        })
        lint.try_lint(nil, { ignore_errors = false })
    end,
    keys = {
        {
            "<leader>cl",
            function()
                local linters = require("lint").get_running()
                if #linters == 0 then
                    vim.notify("󰦕 " .. "No linter running", vim.log.levels.WARN)
                    return
                end
                vim.notify("󱉶 " .. table.concat(linters, ", "), vim.log.levels.INFO)
            end,
            desc = "current/running linters",
        },
    },
}
