return {
    -- A snazzy bufferline for Neovim
    {
        "akinsho/bufferline.nvim",
        event = "UIEnter",
        dependencies = {
            { "tiagovla/scope.nvim", config = true }, -- scopes buffers to tabs
            { "nvim-tree/nvim-web-devicons", lazy = true },
        },
        config = function()
            local bufferline = require('bufferline')
            local groups = bufferline.groups
            local normal = vim.api.nvim_get_hl(0, { name = 'BufferOffset' })
            normal.fg = normal.bg
            vim.api.nvim_set_hl(0, 'BufferLineOffsetSeparator', normal)
            require("bufferline").setup({
                options = {
                    mode = "buffers",
                    sort_by = "insert_after_current",
                    diagnostics = "nvim_lsp",
                    close_command = function(buf_id) require('mini.bufremove').delete(buf_id, false) end,
                    right_mouse_command = "vertical sbuffer %d",
                    show_close_icon = false,
                    show_buffer_close_icons = true,
                    hover = { enabled = true, delay = 0, reveal = { "close" } },
                    always_show_bufferline = false,
                    style_preset = { 2 },
                    move_wraps_at_ends = true, -- test
                    diagnostics_indicator = function (count, level)
                        level = level:match('warn') and 'warn' or level
                        level = require('utils').title_case(level)
                        return (require('utils.icons').diagnostics[level] or '?') .. ' ' .. count
                    end,
                    diagnostics_update_in_insert = false,
                    offsets = {
                        {
                            text = "NEO-TREE",
                            filetype = "neo-tree",
                            text_align = "center",
                            separator = true,
                        },
                        {
                            text = "UNDOTREE",
                            filetype = "undotree",
                            separator = true,
                        },
                        {
                            text = '󰆼 DATABASE VIEWER',
                            filetype = 'dbui',
                            separator = true,
                        },
                        {
                            text = " DIFF VIEW",
                            filetype = "DiffviewFiles",
                            separator = true,
                        },
                        {
                            filetype = "toggleterm",
                            separator = false,
                        },
                    },
                    groups = {
                        options = { toggle_hidden_on_enter = true },
                        items = {
                            groups.builtin.pinned:with({ icon = "" }), -- 📌
                            groups.builtin.ungrouped,
                            {
                                name = "deps",
                                icon = "",
                                highlight = { fg = "#ECBE7B" },
                                matcher = function(buf) return vim.startswith(buf.path, vim.env.VIMRUNTIME) end,
                            },
                            {
                                name = "tests",
                                icon = "",
                                matcher = function(buf)
                                    local name = buf.name
                                    return name:match("[_%.]spec")
                                        or name:match("[_%.]test")
                                        or buf.name:match("%_test")
                                end,
                            },
                            {
                                name = "docs",
                                icon = "",
                                -- highlight = { undercurl = true, sp = "green" },
                                auto_close = false,
                                matcher = function(buf)
                                    if vim.bo[buf.id].filetype == "man" or buf.path:match("man://") then
                                        return true
                                    end
                                    for _, ext in ipairs({ "md", "txt", "org", "norg", "wiki" }) do
                                        if ext == vim.fn.fnamemodify(buf.path, ":e") then
                                            return true
                                        end
                                    end
                                end,
                            },
                        },
                    },
                },
            })
        end,
        keys = {
            { "<leader>b[", "<Cmd>BufferLineMovePrev<CR>", desc = "move prev" },
            { "<leader>b]", "<Cmd>BufferLineMoveNext<CR>", desc = "move next" },
            { "<tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "next buffer" },
            { "<leader><tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "prev buffer" },
            { "<leader>bp", "<Cmd>BufferLinePick<CR>", desc = "pick buffer" },
            { "<leader>bP", "<Cmd>BufferLineTogglePin<CR>", desc = "pin buffer" },
            { "<leader>bc", "<Cmd>BufferLinePickClose<CR>", desc = "delete buffer" },
            { "<leader>bh", "<Cmd>BufferLineCloseLeft<CR>", desc = "close bufffers to the left" },
            { "<leader>bl", "<Cmd>BufferLineCloseRight<CR>", desc = "close bufffers to the right" },
            { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "close other bufffers" },     -- %bd|e#
        }
    },

    -- Buffer removing (unshow, delete, wipeout), which saves window layout
    {
        "echasnovski/mini.bufremove",
        keys = {
            { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "delete buffer" },
            { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "delete buffer!" },
        },
    }
}
