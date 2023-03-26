return {
    {
        "akinsho/bufferline.nvim",
        event = "UIEnter",
        dependencies = {
            { "tiagovla/scope.nvim",         config = true }, -- scopes buffers to tabs
            { "nvim-tree/nvim-web-devicons", lazy = true },
        },
        config = function()
            local groups = require('bufferline.groups')
            require('bufferline').setup({
                options = {
                    mode = "buffers",
                    sort_by = "insert_after_current",
                    diagnostics = "nvim_lsp",
                    right_mouse_command = "vertical sbuffer %d",
                    show_close_icon = false,
                    show_buffer_close_icons = true,
                    hover = { enabled = true, delay = 0, reveal = { "close" } },
                    offsets = {
                        {
                            text = "File Explorer",
                            filetype = "neo-tree",
                            highlight = "Directory",
                            text_align = "center",
                            separator = true,
                        },
                        {
                            text = "UNDOTREE",
                            filetype = "undotree",
                            highlight = "PanelHeading",
                            separator = true,
                        },
                        {
                            text = " DIFF VIEW",
                            filetype = "DiffviewFiles",
                            highlight = "PanelHeading",
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
                            groups.builtin.pinned:with({ icon = '' }),
                            groups.builtin.ungrouped,
                            {
                                name = "Dependencies",
                                icon = "",
                                highlight = { fg = "#ECBE7B" },
                                matcher = function(buf)
                                    return vim.startswith(buf.path, vim.env.VIMRUNTIME)
                                end,
                            },
                            {
                                name = "Tests",
                                icon = "",
                                -- highlight = { underline = true, sp = "blue" },
                                -- priority = 2,
                                matcher = function(buf)
                                    return buf.filename:find("test")
                                        or buf.filename:match("%_spec")
                                        or buf.filename:match("%_test")
                                end,
                            },
                            {
                                name = "Docs",
                                icon = "",
                                -- highlight = { undercurl = true, sp = "green" },
                                auto_close = false,
                                matcher = function(buf)
                                    if vim.bo[buf.id].filetype == "man" or buf.path:match("man://") then
                                        return true
                                    end
                                    for _, ext in ipairs({ "md", "txt", "org", "norg", "wiki" }) do
                                        if ext == vim.fn.fnamemodify(buf.path, ":e") then return true end
                                    end
                                end,
                            },
                        },
                    },
                },
            })
        end,
        keys = function()
            local cmd = require("utils").cmd
            return {
                { "<leader>b[", cmd("BufferLineMoveNext"), desc = "move next" },
                { "<leader>b]", cmd("BufferLineMovePrev"), desc = "move prev" },
                { "<tab>", cmd("BufferLineCycleNext"), desc = "next buffer" },
                { "<leader><tab>", cmd("BufferLineCyclePrev"), desc = "prev buffer" },
                { "<leader>bp", cmd("BufferLinePick"), desc = "pick buffer" },
                { "<leader>bP", cmd("BufferLineTogglePin"), desc = "pin buffer" },
                { "<leader>bD", cmd("BufferLinePickClose"), desc = "delete buffer" },
                { "<leader>bh", cmd("BufferLineCloseLeft"), desc = "close bufffers to the left" },
                { "<leader>bl", cmd("BufferLineCloseRight"), desc = "close bufffers to the right" },
                { "<leader>bw", cmd("BufferLineCloseRight<CR><Cmd>BufferLineCloseLeft"), desc = "close other bufffers" },
            }
        end,
    },
}
