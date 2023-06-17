return {
    -- Highlight and search todo comments
    {
        "folke/todo-comments.nvim",
        cmd = { "TodoTrouble", "TodoTelescope" },
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            keywords = {
                REFERENCE = { icon = "", color = "hint" },
            },
            highlight = { multiline = false },
        },
        config = true,
        keys = {
            {
                "]t",
                function()
                    require("todo-comments").jump_next()
                end,
                desc = "Next todo comment",
            },
            {
                "[t",
                function()
                    require("todo-comments").jump_prev()
                end,
                desc = "Previous todo comment",
            },
            { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
            { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
            { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
        },
    },

    -- Color highlighter
    {
        "NvChad/nvim-colorizer.lua",
        event = { "BufReadPost" },
        opts = {
            filetypes = { "*" },
            user_default_options = {
                names = false,
                RRGGBBAA = true,                               -- #RRGGBBAA hex codes
                css_fn = true,                                 -- Enable all CSS *functions*: rgb_fn, hsl_fn
                css = true,                                    -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                mode = "background",                           -- Available modes for `mode`: foreground, background,  virtualtext
                tailwind = true,
                sass = { enable = true, parsers = { "css" } }, -- Enable sass colors
                virtualtext = "■",
                cmp_docs = { always_update = true },
            },
            buftypes = { "!nofile", "!prompt", "!popup" },
        },
    }
}
