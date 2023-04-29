local ts_persers = require("utils").ts_persers
return {
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = "CursorMoved",
        config = function()
            require("treesitter-context").setup({
                mode = "topline", -- Line used to calculate context. Choices: 'cursor', 'topline'
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            "HiPhish/nvim-ts-rainbow2",
            "windwp/nvim-ts-autotag",
            "andymass/vim-matchup",
            "RRethy/nvim-treesitter-textsubjects",
            "nvim-treesitter/nvim-treesitter-refactor",
            "nvim-treesitter/nvim-treesitter-textobjects",
            "JoosepAlviste/nvim-ts-context-commentstring",
            { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },
        },
        opts = {
            -- sync_install = true,
            ensure_installed = ts_persers,
            autopairs = { enable = true },
            autotag = { enable = true },
            indent = {
                enable = true,
                -- disable = { "python" },
            },
            context_commentstring = { enable = true, enable_autocmd = false },
            highlight = {
                enable = true,
                use_languagetree = true,
                disable = function(_, buf)
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,
                additional_vim_regex_highlighting = false,
            },
            matchup = {
                enable = true,
                matchup_matchparen_offscreen = { method = "status_manual" },
                matchup_override_vimtex = 1,
            },
            query_linter = {
                enable = true,
                use_virtual_text = true,
                lint_events = { "BufWrite", "CursorHold" },
            },
            playground = {
                enable = true,
                disable = {},
                updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
                persist_queries = false, -- Whether the query persists across vim sessions
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    include_surrounding_whitespace = false,
                    keymaps = {
                        ["a/"] = { query = "@comment.outer", desc = "Select comment" },
                        ["ac"] = { query = "@conditional.outer", desc = "Select outer conditional" },
                        ["ic"] = { query = "@conditional.inner", desc = "Select inner conditional" },
                        ["af"] = { query = "@function.outer", desc = "Select outer part of a function" },
                        ["if"] = { query = "@function.inner", desc = "Select inner part of a function" },
                        ["aP"] = { query = "@parameter.outer", desc = "Select outer part of a parameter" },
                        ["iP"] = { query = "@parameter.inner", desc = "Select inner part of a parameter" },
                        ["aC"] = { query = "@class.outer", desc = "Select outer part of a class" },
                        ["iC"] = { query = "@class.inner", desc = "Select inner part of a class" },
                        ["aL"] = { query = "@loop.outer", desc = "Select outer loop" },
                        ["iL"] = { query = "@loop.inner", desc = "Select inner loop" },
                        ["ae"] = { query = "@block.outer", desc = "Select outer block" },
                        ["ie"] = { query = "@block.inner", desc = "Select inner block" },
                        ["al"] = { query = "@assignment.lhs", desc = "assignment left side" },
                        ["ar"] = { query = "@assignment.rhs", desc = "assignment right side" },
                        ["ao"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
                        ["aR"] = { query = "@call.outer", desc = "outer call" },
                        ["iR"] = { query = "@call.inner", desc = "inner call" },
                        ["aS"] = { query = "@statement.outer", desc = "Select outer statement" },
                        ["iS"] = { query = "@statement.inner", desc = "Select inner statement" },
                    },
                    selection_modes = {
                        ["@parameter.outer"] = "v", -- charwise
                        ["@function.outer"] = "V", -- linewise
                        ["@class.outer"] = "<c-v>", -- blockwise
                    },
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ["]p"] = { query = "@parameter.inner", desc = "swap next parameter" },
                        ["<leader>sf"] = { query = "@function.outer", desc = "swap next function" },
                        ["<leader>sc"] = { query = "@class.outer", desc = "swap next class" },
                        ["<leader>ss"] = { query = "@statement.outer", desc = "swap next statement" },
                        ["<leader>sb"] = { query = "@block.outer", desc = "swap next block" },
                    },
                    swap_previous = {
                        ["[p"] = { query = "@parameter.inner", desc = "Swap previous parameter" },
                        ["<leader>sF"] = { query = "@function.inner", desc = "Swap previous function" },
                        ["<leader>sC"] = { query = "@class.inner", desc = "Swap previous class" },
                        ["<leader>sS"] = { query = "@statement.inner", desc = "Swap previous statement" },
                        ["<leader>sB"] = { query = "@block.inner", desc = "Swap previous block" },
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        ["]m"] = { query = "@function.outer", desc = "Next function start" },
                        ["]]"] = { query = "@class.outer", desc = "Next class start" },
                        ["]/"] = { query = "@comment.outer", desc = "Next Comment Start" },
                        ["]o"] = { query = { "@loop.inner", "@loop.outer" } },
                        ["]S"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
                        ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
                    },
                    goto_next_end = {
                        ["]M"] = { query = "@function.outer", desc = "Next Function End" },
                        ["]["] = { query = "@class.outer", desc = "Next Class End" },
                    },
                    goto_previous_start = {
                        ["[m"] = { query = "@function.outer", desc = "Previous Function Start" },
                        ["[["] = { query = "@class.outer", desc = "Previous Class Start" },
                        ["[/"] = { query = "@comment.outer", desc = "Previous Comment Start" },
                    },
                    goto_previous_end = {
                        ["[M"] = { query = "@function.outer", desc = "Previous Function End" },
                        ["[]"] = { query = "@class.outer", desc = "Previous Class End" },
                    },
                },
                lsp_interop = {
                    enable = true,
                    border = "rounded",
                    floating_preview_opts = {},
                    peek_definition_code = {
                        ["<leader>df"] = { query = "@function.outer", desc = "Peek function defination" },
                        ["<leader>dF"] = { query = "@class.outer", desc = "Peek class defination" },
                    },
                },
            },
            textsubjects = {
                enable = true,
                prev_selection = ",",
                keymaps = {
                    ["."] = "textsubjects-smart",
                    [";"] = "textsubjects-container-outer",
                    ["i;"] = "textsubjects-container-inner",
                },
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "gnn",
                    node_incremental = "grn",
                    scope_incremental = "grc",
                    node_decremental = "grm",
                },
            },
            refactor = {
                highlight_definitions = {
                    enable = true,
                    -- Set to false if you have an `updatetime` of ~100.
                    clear_on_cursor_move = true,
                },
                highlight_current_scope = { enable = false }, -- kinda nice but indentline is okay
                smart_rename = {
                    enable = true,
                    keymaps = {
                        -- smart_rename = "grr",
                        smart_rename = "gR",
                    },
                },
                navigation = {
                    enable = true,
                    keymaps = {
                        -- goto_definition = "gnd",
                        goto_definition_lsp_fallback = "<leader>gd", -- gnd
                        list_definitions = "glD",  -- gnD
                        list_definitions_toc = "gO",
                        goto_next_usage = "<a-*>",
                        goto_previous_usage = "<a-#>",
                    },
                },
            },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
            require("nvim-treesitter.configs").setup({
                rainbow = {
                    enable = true,
                    query = {
                        "rainbow-parens",
                         html = 'rainbow-tags' -- highlight tags instead
                    },
                    disable = { "jsx" },
                    strategy = require("ts-rainbow").strategy.global,
                },
            })
        end,
    },
}
