return {
    -- Highlight and search todo comments
    {
        "folke/todo-comments.nvim",
        cmd = { "TodoTrouble", "TodoTelescope" },
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            keywords = {
                CHECK = { icon = "󰘽", color = "hint" },
                HACK = { icon = " ", color = "warning" },
                NOTE = { icon = "", color = "hint", alt = { "INFO" } },
                PERF = { icon = "", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                REF = { icon = "", color = "hint", alt = { "REFERENCE" } },
                TEST = { icon = "", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
            },
            highlight = { multiline = false },
        },
        config = true,
        keys = {
            {
                "]t",
                function() require("todo-comments").jump_next() end,
                desc = "todo comment",
            },
            {
                "[t",
                function() require("todo-comments").jump_prev() end,
                desc = "todo comment",
            },
            { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "todo trouble" },
            { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
            { "<leader>xc", "<cmd>execute 'TodoTrouble cwd='.getreg('%')<cr>", desc = "todo current file" },
            { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "find todo" },
        },
    },

    -- Color highlighter
    {
        "NvChad/nvim-colorizer.lua",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            filetypes = { "*" },
            user_default_options = {
                names = false,
                RRGGBBAA = true, -- #RRGGBBAA hex codes
                css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
                css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                mode = "background", -- Available modes for `mode`: foreground, background,  virtualtext
                tailwind = true,
                sass = { enable = true, parsers = { "css" } }, -- Enable sass colors
                virtualtext = "■",
                -- cmp_docs = { always_update = true },
                always_update = true,
            },
            -- buftypes = { "!nofile", "!prompt", "!popup" },
            buftypes = { "!nofile", "!popup" },
        },
    }
}
