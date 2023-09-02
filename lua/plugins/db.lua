-- WIP
return {
    {
        "kristijanhusak/vim-dadbod-ui",
        cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection" },
        init = function()
            vim.g.db_ui_show_help = 0
            vim.g.db_ui_use_nerd_fonts = 1
            vim.g.db_ui_show_database_icon = 1
            vim.g.db_ui_win_position = "right"
            vim.g.db_ui_force_echo_notifications = 1
            vim.g.db_ui_auto_execute_table_helpers = 1
            vim.g.db_ui_use_nvim_notify = 1
        end,
        dependencies = {
            { "tpope/vim-dadbod" },
            {
                'kristijanhusak/vim-dadbod-completion',
                ft = { 'sql', 'mysql', 'plsql' },
                config = function()
                    vim.api.nvim_create_autocmd('FileType', {
                        pattern = { 'sql', 'mysql', 'plsql' },
                        group = require('utils').augroup('dadbod_completion'),
                        callback = function()
                            local cmp = require('cmp')
                            cmp.setup.buffer({
                                sources = {
                                    { name = 'vim-dadbod-completion' },
                                    { name = 'buffer' },
                                },
                            })
                        end,
                    })
                end
            },
        },
        keys = {
            { "<leader>Du", "<Cmd>DBUIToggle<CR>", desc = "Toggle DBUI" },
        },
    },

    -- Interactive database client
    {
        "kndndrj/nvim-dbee",
        dependencies = "MunifTanjim/nui.nvim",
        build = function() require("dbee").install() end,
        config = function()
            require("dbee").setup {
                sources = require("dbee.config").default.sources,
                drawer = { disable_help = true },
            }
        end,
        keys = {
            -- Open/close the UI.
            {
                "<leader>DD",
                function()
                    require("dbee").toggle()
                end,
                desc = "toggle DBee ui",
            },
            -- Next/previou page of the results (there are the same mappings that work just inside the results buffer
            -- available in config).
            {
                "<leader>Dn",
                function()
                    require("dbee").next()
                end,
                desc = "next page of results",
            },
            {
                "<leader>DN",
                function()
                    require("dbee").prev()
                end,
                desc = "previous page of results",
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
