return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            style = "moon",
            hide_inactive_statusline = true,
            -- dim_inactive = true,
            lualine_bold = true,
            sidebars = { "qf", "help", "terminal", "Trouble" },
            on_highlights = function(hl)
                local colors = require("utils").git_colors
                hl.GitSignsAdd = {
                    fg = colors.GitAdd,
                }
                hl.GitSignsChange = {
                    fg = colors.GitChange,
                }
                hl.GitSignsDelete = {
                    fg = colors.GitDelete,
                }
            end,
        },
        config = function(_, opts)
            local tokyonight = require("tokyonight")
            tokyonight.setup(opts)
            tokyonight.load()
        end,
    },
    {
        "navarasu/onedark.nvim",
        lazy = true,
        config = function()
            require("onedark").setup({
                style = "deep",
                toggle_style_key = "<leader>Ts",
            })
            require("onedark").load()
        end,
    },
    {
        "catppuccin/nvim",
        lazy = true,
        name = "catppuccin",
        opts = {
            integrations = {
                lsp_trouble = true,
                mason = true,
                navic = { enabled = true, custom_bg = "lualine" },
                neotest = true,
                neotree = true,
                noice = true,
                notify = true,
                treesitter_context = true,
                ts_rainbow2 = true,
                which_key = true,
            },
        },
    },
    { "rose-pine/neovim", name = "rose-pine", lazy = true },
    { "Everblush/nvim", name = "everblush", lazy = true },
}
