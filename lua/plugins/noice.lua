return {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
    opts = {
        presets = {
            command_palette = true,
            long_message_to_split = true,
            inc_rename = true,
            lsp_doc_border = true,
        },
        commands = {
            all = {
                view = "split",
                opts = { enter = true, format = "details" },
                filter = {},
            },
        },
        format = {
            level = {
                icons = false,
            },
        },
        notify = {
            replace = true,
        },
        lsp = {
            override = {
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true,
            },
            documentation = {
                opts = {
                    border = { style = "rounded" },
                    position = {
                        row = 2,
                    },
                    win_options = {
                        winhighlight = {
                            NormalFloat = "Normal",
                        },
                    },
                },
            },
        },
        views = {
            cmdline_popup = {
                position = {
                    row = 5,
                    col = "50%",
                },
                size = {
                    width = 60,
                    height = "auto",
                },
            },
            popupmenu = {
                relative = "editor",
                position = {
                    row = 8,
                    col = "50%",
                },
                size = {
                    width = 60,
                    height = 10,
                },
                border = {
                    style = "rounded",
                    padding = { 0, 1 },
                },
                win_options = {
                    winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
                },
            },
        },
        routes = {
            -- its so annoying to me
            {
                filter = {
                    event = { "msg_show" },
                    find = "%d+ lines %-%-(%d+)%%%-%-",
                },
                opts = { skip = true },
                -- view = "mini",
            },
            -- now you know that :w writes the file
            {
                filter = {
                    event = { "msg_show" },
                    kind = "",
                    find = "written",
                },
                opts = { skip = true },
            },
            {
                filter = {
                    event = "msg_show",
                    find = "%d+L, %d+B",
                },
                view = "mini",
            },
            -- skip search_count messages instead of showing them as virtual text
            {
                filter = { event = "msg_show", kind = "search_count" },
                opts = { skip = true },
            },

            -- route long notifications to splits
            {
                filter = {
                    event = "notify",
                    min_height = 10,
                },
                view = "split",
            },
        },
    },
    keys = {
        { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
        { "<leader>nl", function() require("noice").cmd("last") end, desc = "Noice last message" },
        { "<leader>nh", function() require("noice").cmd("history") end, desc = "Noice history" },
        { "<leader>na", function() require("noice").cmd("all") end, desc = "Noice all" },
        { "<leader>ne", function() require("noice").cmd("errors") end, desc = "Noice errors" },
        { "<leader>nt", function() require("noice").cmd("telescope") end, desc = "Noice telescope" },
        {
            "<c-f>",
            function()
                if not require("noice.lsp").scroll(4) then
                    return "<c-f>"
                end
            end,
            silent = true,
            expr = true,
            desc = "Scroll forward",
            mode = { "i", "n", "s" },
        },
        {
            "<c-b>",
            function()
                if not require("noice.lsp").scroll(-4) then
                    return "<c-b>"
                end
            end,
            silent = true,
            expr = true,
            desc = "Scroll backward",
            mode = { "i", "n", "s" },
        },
    },
}
