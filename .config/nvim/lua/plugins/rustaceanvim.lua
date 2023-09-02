return {
    {
        "mrcjkb/rustaceanvim",
        version = "^3", -- Recommended
        ft = { "rust" },
        config = function()
            vim.g.rustaceanvim = {
                tools = {
                    hover_actions = {
                        auto_focus = false,
                    },
                },
                server = {
                    settings = {
                        ["rust-analyzer"] = {
                            cargo = {
                                allFeatures = true,
                                loadOutDirsFromCheck = true,
                                runBuildScripts = true,
                            },
                            -- Add clippy lints for Rust.
                            checkOnSave = {
                                allFeatures = true,
                                command = "clippy",
                                extraArgs = { "--no-deps" },
                            },
                            procMacro = {
                                enable = true,
                                ignored = {
                                    ["async-trait"] = { "async_trait" },
                                    ["napi-derive"] = { "napi" },
                                    ["async-recursion"] = { "async_recursion" },
                                },
                            },
                        },
                    },
                },
            }
        end,
    },
    {
        "saecki/crates.nvim",
        event = "BufRead Cargo.toml",
        dependencies = "nvim-lua/plenary.nvim",
        config = function()
            local crates = require("crates")
            crates.setup({
                src = {
                    cmp = { enabled = true },
                },
            })
            crates.show()
            vim.api.nvim_create_autocmd("BufRead", {
                group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
                pattern = "Cargo.toml",
                callback = function()
                    require("cmp").setup.buffer({ sources = { { name = "crates" } } })
                end,
            })
        end,
    },
}
