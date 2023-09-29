return {
    {
        "kristijanhusak/vim-dadbod-ui",
        cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection" },
        dependencies = "tpope/vim-dadbod",
        init = function()
            vim.g.db_ui_show_help = 0
            vim.g.db_ui_use_nerd_fonts = 1
            vim.g.db_ui_show_database_icon = 1
            vim.g.db_ui_win_position = "right"
            vim.g.db_ui_force_echo_notifications = 1
            vim.g.db_ui_auto_execute_table_helpers = 1
        end,
        keys = {
            { "<leader>Du", "<Cmd>DBUIToggle<CR>", desc = "Toggle DBUI" },
        },
    },

    -- dadbod completion
    -- TODO: lazy load when databse connection is made instead of filetype
    {
        "kristijanhusak/vim-dadbod-completion",
        ft = { "sql", "mysql", "plsql" },
        dependencies = {
            "tpope/vim-dadbod",
            "kristijanhusak/vim-dadbod-ui",
            "nvim-cmp",
        },
        config = function()
            require("cmp").setup.filetype({ "sql", "mysql", "plsql" }, {
                sources = {
                    { name = "vim-dadbod-completion" },
                },
            })
        end,
    },

    -- Interactive database client
    {
        "kndndrj/nvim-dbee",
        dependencies = "MunifTanjim/nui.nvim",
        build = function()
            require("dbee").install()
        end,
        keys = {
            -- Open/close the UI.
            {
                "<leader>Do",
                function()
                    require("dbee").open()
                end,
                desc = "Open DBee UI",
            },
            {
                "<leader>Dc",
                function()
                    require("dbee").close()
                end,
                desc = "Close DBee UI",
            },
            -- Next/previou page of the results (there are the same mappings that work just inside the results buffer
            -- available in config).
            {
                "<leader>Dn",
                function()
                    require("dbee").next()
                end,
                desc = "Next page of results",
            },
            {
                "<leader>DN",
                function()
                    require("dbee").prev()
                end,
                desc = "Previous page of results",
            },
            -- Run a query on the active connection directly.
            -- { "<leader>D", require("dbee").execute(query), desc = "Run query directly" },
            -- Save the current result to file (format is either "csv" or "json" for now).
            -- { "<leader>D", require("dbee").save(format, file), desc = "" },
        },
    },

    {
        "folke/which-key.nvim",
        optional = true,
        opts = {
            keymaps = {
                ["<leader>D"] = { name = "+DB 󰆼"}
            }
        }
    }
}
