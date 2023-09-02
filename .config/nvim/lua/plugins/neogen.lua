return {
    "danymat/neogen",
    cmd = "Neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {
        languages = {
            lua = { template = { annotation_convention = 'emmylua' } },
            python = { template = { annotation_convention = 'numpydoc' } },
        },
        snippet_engine = "luasnip",
    },
    keys = {
        {
            "<leader>gaa",
            function()
                require("neogen").generate({ type = "file" })
            end,
            desc = "file",
        },
        {
            "<leader>gac",
            function()
                require("neogen").generate({ type = "class" })
            end,
            desc = "class",
        },
        {
            "<leader>gaf",
            function()
                require("neogen").generate({ type = "func" })
            end,
            desc = "function",
        },
        {
            "<leader>gat",
            function()
                require("neogen").generate({ type = "type" })
            end,
            desc = "type",
        },
    },
}
