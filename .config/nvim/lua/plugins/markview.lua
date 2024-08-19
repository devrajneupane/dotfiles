return {
    "OXY2DEV/markview.nvim",
    ft = "markdown",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "echasnovski/mini.icons",
    },
    opts = {
        hybrid_modes = { "n", "no" },
    },
    keys = {
        { "<leader>cm", "<Cmd>Markview<CR>", ft = "markdown", desc = "toggle markview" },
    },
}
