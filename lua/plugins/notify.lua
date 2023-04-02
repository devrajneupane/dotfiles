return {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {
        timeout = 2000,
        fps = 60,
        render = "compact",
        background_colour = "NormalFloat",
        stages = "fade_in_slide_out",
        -- top_down = false,
        max_height = function()
            return math.floor(vim.o.lines * 0.6)
        end,
        max_width = function()
            return math.floor(vim.o.columns * 0.4)
        end,
    },
    keys = {
        {
            "<leader>nd",
            function()
                require("notify").dismiss({ silent = true, pending = true })
            end,
            desc = "dismiss notifications",
        },
    },
}
