return {
    "danymat/neogen",
    cmd = "Neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {
        snippet_engine = "luasnip",
    },
    keys = {
        {
            "<leader>gaa",
            function()
                require("neogen").generate({ type = "file" })
            end,
            desc = "generate file annotations",
        },
        {
            "<leader>gac",
            function()
                require("neogen").generate({ type = "class" })
            end,
            desc = "generate class annotations",
        },
        {
            "<leader>gaf",
            function()
                require("neogen").generate({ type = "func" })
            end,
            desc = "generate function annotations",
        },
        {
            "<leader>gat",
            function()
                require("neogen").generate({ type = "type" })
            end,
            desc = "generate type annotations",
        },
    },
}
