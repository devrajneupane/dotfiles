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
}
