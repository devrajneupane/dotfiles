local trace = vim.log.levels.TRACE
return {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {
        timeout = 2000,
        -- fps = 60,
        render = "compact",
        background_colour = "NormalFloat",
        stages = "fade_in_slide_out",
        -- top_down = false,
        max_height = function() return math.floor(vim.o.lines * 0.6) end,
        max_width = function() return math.floor(vim.o.columns * 0.4) end,
        on_open = function(win)
            vim.api.nvim_win_set_config(win, { zindex = 100 })
        end,
        icons = { DEBUG = "", ERROR = "", INFO = "", TRACE = "", WARN = "" },
        level = vim.log.levels.TRACE, -- minimum severity level
    },
    keys = {
        {
            "<leader>nd",
            function() require("notify").dismiss({ silent = true, pending = true }) end,
            desc = "dismiss notifications",
        },
        {
            "<leader>nc",
            function()
                local history = require("notify").history()
                if #history == 0 then
                    vim.notify("No Notification in this session.", trace, { title = "nvim-notify" })
                    return
                end
                local msg = history[#history].message
                vim.fn.setreg("+", msg)
                vim.notify("Last Notification copied.", trace, { title = "nvim-notify" })
            end,
            desc = "copy last notification",
        },
    },
}
