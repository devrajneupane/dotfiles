return {
    -- configurable 'statuscolumn' and click handlers
    {
        "luukvbaal/statuscol.nvim",
        event = "BufReadPost",
        config = function()
            local builtin = require("statuscol.builtin")
            require("statuscol").setup({
                bt_ignore = { "terminal", "nofile" },
                relculright = true,
                segments = {
                    {
                        text = { builtin.foldfunc, " " },
                        condition = { true, builtin.not_empty },
                        click = "v:lua.ScFa",
                    },
                    {
                        sign = {
                            name = { ".*" },
                            namespace = { ".*" },
                            maxwidth = 1,
                            colwidth = 2,
                            wrap = true,
                            auto = true,
                        },
                        click = "v:lua.ScSa",
                    },
                    { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
                    {
                        sign = {
                            name = { "GitSigns*", "Todo*" },
                            namespace = { "gitsigns_extmark_signs_" },
                            maxwidth = 1,
                            colwidth = 1,
                            wrap = true,
                            auto = true,
                        },
                        click = "v:lua.ScSa",
                    },
                },
            })
        end,
    },

    --Rainbow delimiters for Neovim with Tree-sitter
    {
        "HiPhish/rainbow-delimiters.nvim",
        event = "BufReadPre",
        config = function()
            local rainbow = require("rainbow-delimiters")
            vim.g.rainbow_delimiters = {
                strategy = {
                    [""] = rainbow.strategy["global"],
                    vim = rainbow.strategy["local"],
                    html = rainbow.strategy['local'],
                },
                query = {
                    [""] = "rainbow-delimiters",
                    lua = "rainbow-blocks",
                    query = function(bufnr) -- test
                        -- Use blocks for read-only buffers like in `:InspectTree`
                        local is_nofile = vim.bo[bufnr].buftype == 'nofile'
                        return is_nofile and 'rainbow-blocks' or 'rainbow-delimiters'
                    end
                },
                priority = {
                    [""] = 110,
                    lua = 210,
                },
                highlight = {
                    "RainbowDelimiterRed",
                    "RainbowDelimiterCyan",
                    "RainbowDelimiterOrange",
                    "RainbowDelimiterGreen",
                    "RainbowDelimiterBlue",
                    "RainbowDelimiterViolet",
                    "RainbowDelimiterYellow",
                },
            }
        end,
    },

    -- indent guides
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "BufReadPre",
        main = "ibl",
        opts = {
            scope = {
                show_start = false,
                show_end = false,
                include = {
                    node_type = { lua = { "table_constructor" } }, -- "return_statement",
                },
                highlight = {
                    "RainbowDelimiterCyan",
                    "RainbowDelimiterRed",
                    "RainbowDelimiterYellow",
                    "RainbowDelimiterBlue",
                    "RainbowDelimiterOrange",
                    "RainbowDelimiterGreen",
                    "RainbowDelimiterViolet",
                }
            },
            indent = {
                char = "│", -- ▏
                -- tab_char = "│", -- tabs
                priority = 11,
            },
            exclude = {
                filetypes = { "neo-tree-popup", "toggleterm", "undotree" },
            },
        },
        -- NOTE: idk why but integration with rainbow_delimeters make nvim so laggy
        -- config = function(_, opts)
            -- local highlight = {
            --     "RainbowDelimiterRed",
            --     "RainbowDelimiterYellow",
            --     "RainbowDelimiterBlue",
            --     "RainbowDelimiterOrange",
            --     "RainbowDelimiterGreen",
            --     "RainbowDelimiterViolet",
            --     "RainbowDelimiterCyan",
            -- }
            -- opts.scope.highlight = highlight
            -- vim.g.rainbow_delimeters = { highlight = highlight }
            -- require('ibl').setup(opts)
            -- local hooks = require('ibl.hooks')
            -- hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
            -- hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
        -- end,
        keys = {
            {
                "<leader>cc",
                function() -- WIP
                    local bufnr = vim.api.nvim_get_current_buf()
                    local config = require("ibl.config").get_config(bufnr)
                    local scope = require("ibl.scope").get(bufnr, config)
                    vim.print(scope:range(0))
                    -- if scope then
                    --     vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { scope:range(0)})
                    -- end
                end,
                desc = "jump to current context",
            },
        },
    },

    -- improve the default vim.ui interfaces
    {
        "stevearc/dressing.nvim",
        init = function()
            vim.ui.select = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.select(...)
            end
            vim.ui.input = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.input(...)
            end
        end,
        opts = {
            select = {
                get_config = function(opts)
                    if opts.kind == "codeaction" or opts.kind == "codelens" then
                        return {
                            backend = "builtin", -- nui
                            --[[ nui = {
                                relative = "cursor",
                                max_width = 40,
                            }, ]]
                            builtin = {
                                relative = "cursor",
                                max_height = 0.33,
                                min_height = 5,
                                max_width = 0.40,
                                mappings = { ["q"] = "Close" },
                                win_options = {
                                    winhighlight = "FloatBorder:LspFloatWinBorder,DressingSelectIdx:LspInfoTitle,MatchParen:Ignore",
                                    winblend = 5,
                                },
                            },
                        }
                    end
                end,
                backend = { "telescope", "builtin" },
            },
        },
    },
}
