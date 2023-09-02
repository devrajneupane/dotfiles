return {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    enabled = false,
    dependencies = "plenary.nvim",
    opts = function()
        local null_ls = require("null-ls")
        local formatting = null_ls.builtins.formatting
        local diagnostics = null_ls.builtins.diagnostics
        local code_actions = null_ls.builtins.code_actions
        local completion = null_ls.builtins.completion
        return {
            debug = true,
            border = "rounded",
            diagnostics_format = " #{m} • #{s} [#{c}]",
            sources = {
                -- completion.luasnip,
                diagnostics.actionlint,
                diagnostics.hadolint,
                -- diagnostics.shellcheck.with({ filetypes = { "sh", "bash", "zsh" } }),
                diagnostics.selene.with({
                    condition = function(utils)
                        return utils.root_has_file({ "selene.toml" })
                    end,
                }),
                -- formatting.deno_fmt,
                formatting.markdownlint,
                formatting.shfmt,
                formatting.stylua,
                formatting.clang_format,
                formatting.taplo,
                formatting.jq,
                formatting.black.with({ extra_args = { "--fast" } }),
                formatting.prettier.with({ extra_filetypes = { "toml" } }),
            },
        }
    end,
    keys = {
        { "<leader>N", "<Cmd>NullLsInfo<CR>", desc = "null-ls info" },
    },
}
