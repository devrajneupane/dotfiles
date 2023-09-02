local icons = require("utils.icons")
return {
    "folke/noice.nvim",
    event = "UIEnter",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
    opts = {
        presets = {
            long_message_to_split = true,
            inc_rename = true,
            -- lsp_doc_border = true,
            command_palette = true,
            bottom_search = true,
        },
        smart_move = {
            -- noice tries to move out of the way of existing floating windows.
            enabled = true, -- you can disable this behaviour here
            -- add any filetypes here, that shouldn't trigger smart move.
            excluded_filetypes = { "cmp_menu", "cmp_docs" },
        },
        cmdline = {
            format = {
                substitute = { pattern = "^:%%?s/", icon = " ", lang = "regex", title = " Substitute " }, -- ^:[%%]*s/
                input = { icon = " ", lang = "text", view = "cmdline_popup", title = "" },
            },
        },
        popupmenu = {
            kind_icons = icons.kinds,
        },
        format = {
            level = {
                icons = {
                    error = icons.diagnostics.Error,
                    warn = icons.diagnostics.Warn,
                    info = icons.diagnostics.Info,
                },
            },
        },
        lsp = {
            override = {
                -- override the default lsp markdown formatter with Noice
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                -- override the lsp markdown formatter with Noice
                ["vim.lsp.util.stylize_markdown"] = true,
                -- override cmp documentation with Noice
                ["cmp.entry.get_documentation"] = true,
            },
            hover = {
                silent = true, -- do not show message when hover is not available
            },
            progress = {
                format_done = {
                    { " ", hl_group = "NoiceLspProgressSpinner" }, --  󰄬 ✓  
                    { "{data.progress.title} ", hl_group = "NoiceLspProgressTitle" },
                    { "{data.progress.client} ", hl_group = "NoiceLspProgressClient" },
                },
            },
        },
        views = {
            cmdline_popup = {
                position = { row = 5, col = "50%" },
                size = { width = "auto", height = "auto" },
            },
            popupmenu = {
                backend = "nui",
                size = { width = 50 },
            },
            cmdline_popupmenu = {
                position = {
                    row = -5,
                    col = "50%",
                },
            },
            confirm = { -- test
                border = {
                    padding = { 0, 1 },
                    text = { top = " Confirm " },
                },
                enter = true,
            },
            popup = {
                win_options = {
                    scrolloff = 4,
                    wrap = true,
                    winhighlight = {
                        Normal = "Normal",
                        -- FloatBorder = "FloatBorder"
                    },
                },
            },
            split = {
                win_options = { scrolloff = 4, wrap = true },
            },
            hover = {
                -- size = { max_width = 80 },
                border = { style = "rounded" },
                win_options = {
                    scrolloff = 4,
                    wrap = true,
                    winhighlight = {
                        Normal = "Normal",
                        FloatBorder = "NoiceCmdlinePopupBorderCmdline"
                    },
                },
            },
            mini = {
                win_options = {
                    winhighlight = {
                        NoiceMini = "Normal",
                    },
                },
            },
        },
        commands = {
            history = {
                view = "split",
                filter_opts = { reverse = true }, -- show newest entries first
                filter = {}, -- include everything
                opts = {
                    enter = true,
                    -- https://github.com/folke/noice.nvim#-formatting
                    -- format = { "{title} ", "{cmdline} ", "{message}" },
                    format = "details",
                },
            },
            all = {
                view = "split",
                opts = { enter = true, format = "details" },
                filter_opts = { reverse = true },
                filter = {},
            },
            last = {
                filter = {},
            },
        },
        routes = {
            {
                filter = {
                    any = {
                        { event = "msg_show", kind = "search_count" },
                        { event = "msg_show", find = "%d+ line less;" },
                        { event = "msg_show", find = "%d+ fewer lines" },
                        { event = "msg_show", find = "%d+ more lines?;" },
                        { event = "msg_show", find = "written" },
                        { event = "msg_show", find = "^Hunk %d+ of %d+" },
                        -- { event = 'msg_show', find = '%d+ change' },
                        { event = "msg_show", find = "%d+ line" },
                        -- { event = 'msg_show', find = '%d+ more line' },
                        { event = "msg_show", find = "^/%w+ " }, -- prevent search msg being echoed
                        { event = "notify", find = "No information available" }, -- may be useful
                    },
                },
                opts = { skip = true },
            },
            {
                filter = {
                    event = "msg_show",
                    any = {
                        { find = "%d+L, %d+B" },
                        { find = "; after #%d+" },
                        { find = "; before #%d+" },
                        { find = "%d+ lines indented" },
                        { find = "%d+ lines yanked" },
                        { find = "^E486: Pattern not found" }, -- search
                        { find = "No more valid diagnostics to move to" }, -- Diagnostics
                        { find = "Already at %w+ change" },
                    },
                },
                view = "mini",
            },

            -- route long msg to splits
            {
                filter = { event = "msg_show", min_height = 15 },
                view = "split",
            },
        },
    },
    keys = {
        {
            "<S-Enter>",
            function() require("noice").redirect(vim.fn.getcmdline()) end,
            mode = "c",
            desc = "redirect Cmdline",
        },
        {
            "<leader>nl",
            function() require("noice").cmd("last") end,
            desc = "noice last message",
        },
        {
            "<leader>nh",
            function() require("noice").cmd("history") end,
            desc = "noice history",
        },
        {
            "<leader>na",
            function() require("noice").cmd("all") end,
            desc = "noice all",
        },
        {
            "<leader>ne",
            function() require("noice").cmd("errors") end,
            desc = "noice errors",
        },
        {
            "<leader>nt",
            function() require("noice").cmd("telescope") end,
            desc = "noice telescope",
        },
        {
            "<leader>nD",
            function() require("noice").cmd("dismiss") end,
            desc = "noice dismiss!",
        },
        { "<leader>fn", "<leader>nt", remap = true, desc = "noice telescope" },
        {
            "<C-f>",
            function()
                if not require("noice.lsp").scroll(4) then
                    return "<C-f>"
                end
            end,
            silent = true,
            expr = true,
            mode = { "i", "n", "s" },
            desc = "scroll forward",
        },
        {
            "<C-b>",
            function()
                if not require("noice.lsp").scroll(-4) then
                    return "<C-b>"
                end
            end,
            silent = true,
            expr = true,
            mode = { "i", "n", "s" },
            desc = "scroll backward",
        },
    },
}
