return {
    -- Find the enemy and replace them with dark power
    {
        "nvim-pack/nvim-spectre",
        cmd = "Spectre",
        opts = { open_cmd = "80vnew | setlocal nonumber norelativenumber" },
        keys = {
            {
                "<leader>sw",
                function() require("spectre").open_visual({ select_word = true }) end,
                desc = "search current word",
            },
            {
                "<leader>sf",
                function() require("spectre").open_file_search({ select_word = true }) end,
                desc = "search on current file",
            },
            {
                "<leader>ss",
                function() require("spectre").toggle() end,
                desc = "search and replace",
            },
        },
    },
}
