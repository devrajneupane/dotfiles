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
            on_highlights = function(hl, c)
                local colors = require("utils.icons").git_colors
                local prompt = "#2d3149"
                hl.GitSignsAdd = {
                    fg = colors.GitAdd,
                }
                hl.GitSignsChange = {
                    fg = colors.GitChange,
                }
                hl.GitSignsDelete = {
                    fg = colors.GitDelete,
                }
                hl.TelescopeNormal = {
                    bg = c.bg_dark,
                    fg = c.fg_dark,
                }
                hl.TelescopeBorder = {
                    bg = c.bg_dark,
                    fg = c.bg_dark,
                }
                hl.TelescopePromptNormal = {
                    bg = prompt,
                }
                hl.TelescopePromptBorder = {
                    bg = prompt,
                    fg = prompt,
                }
                hl.TelescopePromptTitle = {
                    bg = c.red,
                    -- fg = c.green,
                }
                hl.TelescopePreviewTitle = {
                    bg = c.bg_dark,
                    fg = c.bg_dark,
                }
                hl.TelescopeResultsTitle = {
                    bg = c.bg_dark,
                    fg = c.bg_dark,
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
    {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = true,
        opts = {
            dark_variant = "moon",
        },
    },
}
