return {

    -- copilot
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        build = ":Copilot auth",
        opts = {
            suggestion = { enabled = false },
            panel = { enabled = false, auto_refresh = true },
        },
    },

    {
        "zbirenbaum/copilot-cmp",
        dependencies = "zbirenbaum/copilot.lua",
        opts = {},
        config = function(_, opts)
            local copilot_cmp = require("copilot_cmp")
            copilot_cmp.setup(opts)
            require("utils").on_attach(function(client)
                if client.name == "copilot" then
                    copilot_cmp._on_insert_enter({})
                end
            end)
        end,
    },

    -- ChatGPT
    {
        "jackMort/ChatGPT.nvim",
        cmd = { "ChatGPT", "ChatGPTActAs" },
        opts = { }
    },
    --TODO: huggingface/hfcc.nvim
}
