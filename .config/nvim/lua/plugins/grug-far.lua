return {
    -- Find And Replace plugin for neovim
    "MagicDuck/grug-far.nvim",
    opts = {
        headerMaxWidth = 80,
        transient = true,
        keymaps = { help = "?", close = "q" },
    },
    cmd = "GrugFar",
    keys = function()
        local grug = require("grug-far")
        return {
            {
                "<leader>ss",
                function()
                    local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
                    grug.grug_far({
                        prefills = {
                            filesFilter = ext and ext ~= "" and "*." .. ext or nil,
                        },
                    })
                end,
                mode = { "n", "v" },
                desc = "search and replace",
            },
            {
                "<leader>sw",
                function()
                    grug.grug_far({
                        prefills = { search = vim.fn.expand("<cword>") },
                    })
                end,
                mode = { "n", "v" },
                desc = "search and replace cword",
            },
            {
                "<leader>sf",
                function()
                    grug.grug_far({
                        prefills = { paths = vim.fn.expand("%") },
                    })
                end,
                mode = { "n", "v" },
                desc = "search and replace in current file",
            },
        }
    end,
}
