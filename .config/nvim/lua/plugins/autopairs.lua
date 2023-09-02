return {
    {
        "windwp/nvim-autopairs",
        dependencies = { "hrsh7th/nvim-cmp" },
        event = "InsertEnter",
        opts = {
            disable_filetype = { "TelescopePrompt", "vim" },
            check_ts = true, -- enable treesitter
            fast_wrap = {}, -- enable fast_wrap
            map_c_h = true, -- Map the <C-h> key to delete a pair
            map_c_w = true, -- map <c-w> to delete a pair if possible
            close_triple_quotes = true,
            ts_config = { -- test
                lua = { "string" }, -- it will not add a pair on that treesitter node
                javascript = { "template_string" },
            },
        },
        config = function(_, opts)
            local npairs = require("nvim-autopairs")
            local Rule = require("nvim-autopairs.rule")

            -- Add parentheses after selecting function or method item
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())

            npairs.setup(opts)

            -- Add spaces between parentheses
            local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
            npairs.add_rules({
                Rule(" ", " "):with_pair(function(args)
                    local pair = args.line:sub(args.col - 1, args.col)
                    return vim.tbl_contains({
                        brackets[1][1] .. brackets[1][2],
                        brackets[2][1] .. brackets[2][2],
                        brackets[3][1] .. brackets[3][2],
                    }, pair)
                end),
            })
            for _, bracket in pairs(brackets) do
                npairs.add_rules({
                    Rule(bracket[1] .. " ", " " .. bracket[2])
                        :with_pair(function()
                            return false
                        end)
                        :with_move(function(args)
                            return args.prev_char:match(".%" .. bracket[2]) ~= nil
                        end)
                        :use_key(bracket[2]),
                })
            end

            -- Arrow key on javascript
            -- FIX: not working
            npairs.add_rules({
                Rule("%(.*%)%s*%=>$", " {  }", { "typescript", "typescriptreact", "javascript" })
                    :use_regex(true)
                    :set_end_pair_length(2),
            })
        end,
    },

    -- Wisely add "end" in Ruby, Vimscript, Lua, etc.
    {
        "RRethy/nvim-treesitter-endwise",
        event = "InsertEnter",
        config = function()
            require("nvim-treesitter.configs").setup({
                endwise = {
                    enable = true,
                },
            })
        end,
    },
}
