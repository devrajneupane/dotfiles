---@see: https://github.com/nvim-treesitter/nvim-treesitter/issues/4767
return {
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = "BufReadPost",
        opts = {
            mode = "topline",
            multiline_threshold = 4,
            separator = '─', -- ─
            on_attach = function()
                vim.api.nvim_set_hl(0, "TreesitterContext", { link = "Normal" })
            end
        },
        keys = {
            {"<leader>cx", function() require('treesitter-context').toggle() end, desc = "toggle code context"},
            { "<leader>cC", function() require("treesitter-context").go_to_context() end, desc = "jump to code context" },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        -- build = ":TSUpdate",
        build = function()
            require("nvim-treesitter.install").update({ with_sync = true })()
        end,
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            "windwp/nvim-ts-autotag",
            "andymass/vim-matchup",
            "nvim-treesitter/nvim-treesitter-refactor",
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        init = function(plugin)
            -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
            require("lazy.core.loader").add_to_rtp(plugin)
            require("nvim-treesitter.query_predicates")
        end,
        opts = {
            ensure_installed = {
                "vim", "vimdoc", "markdown", "markdown_inline", "regex",
                -- "comment", -- IDK why comment perser slows nvim
                "query", "bash", "lua", "html", "json", "yaml", "javascript",
                "python", "rust", "typescript",
            },
            auto_install = true,
            autopairs = { enable = true },
            autotag = { enable = true },
            indent = { enable = true }, -- disable = { "python" },
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
                additional_vim_regex_highlighting = { 'sql', 'org' },
            },
            matchup = {
                enable = true,
                matchup_matchparen_offscreen = { method = "status_manual" }, -- status_manual
                matchup_matchparen_deferred = 1,
                matchup_surround_enabled = 0, -- ds% and cs% cause a catastrophe
                matchup_transmute_enabled = 1 -- :h transmute
            },
            query_linter = {
                enable = true,
                use_virtual_text = true,
                lint_events = { "BufWrite", "CursorHold" },
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    include_surrounding_whitespace = false,
                    -- Do i need all ?  idk
                    keymaps = {
                        ["aF"] = { query = "@custom-capture", desc = "test-py-capture" }, -- test
                        ["aA"] = { query = "@assignment.outer", desc = "assignment" },
                        ["iA"] = { query = "@assignment.inner", desc = "assignment" },
                        ["ah"] = { query = "@assignment.lhs", desc = "assignment lhs" },
                        ["aL"] = { query = "@assignment.rhs", desc = "assignment rhs" },
                        ["ae"] = { query = "@block.outer", desc = "block" },
                        ["ie"] = { query = "@block.inner", desc = "block" },
                        ["ak"] = { query = "@call.outer", desc = "call" },
                        ["ik"] = { query = "@call.inner", desc = "call" },
                        ["ac"] = { query = "@class.outer", desc = "class" },
                        ["ic"] = { query = "@class.inner", desc = "class" },
                        ["a/"] = { query = "@comment.outer", desc = "comment" },
                        ["i/"] = { query = "@comment.inner", desc = "comment" },
                        ["a?"] = { query = "@conditional.outer", desc = "conditional" },
                        ["i?"] = { query = "@conditional.inner", desc = "conditional" },
                        ["af"] = { query = "@function.outer", desc = "function" },
                        ["if"] = { query = "@function.inner", desc = "function" },
                        ["al"] = { query = "@loop.outer", desc = "loop" },
                        ["il"] = { query = "@loop.inner", desc = "loop" },
                        ["in"] = { query = "@number.inner", desc = "number" },
                        ["aa"] = { query = "@parameter.outer", desc = "parameter" },
                        ["ia"] = { query = "@parameter.inner", desc = "parameter" },
                        ["ar"] = { query = "@return.outer", desc = "return" },
                        ["ir"] = { query = "@return.inner", desc = "return" },
                        ["ao"] = { query = "@scope", query_group = "locals", desc = "scope" },
                        ["aS"] = { query = "@statement.outer", desc = "statement" },
                        ["iS"] = { query = "@statement.inner", desc = "statement" },
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
                        ["<leader>]a"] = { query = "@assignment.inner", desc = "assignment" },
                        ["<leader>]b"] = { query = "@block.outer", desc = "block" },
                        ["<leader>]c"] = { query = "@class.outer", desc = "class" },
                        ["<leader>]f"] = { query = "@function.outer", desc = "function" },
                        ["<leader>]p"] = { query = "@parameter.inner", desc = "parameter" },
                    },
                    swap_previous = {
                        ["<leader>[a"] = { query = "@assignment.inner", desc = "assignment" },
                        ["<leader>[b"] = { query = "@block.outer", desc = "block" },
                        ["<leader>[c"] = { query = "@class.outer", desc = "class" },
                        ["<leader>[f"] = { query = "@function.outer", desc = "function" },
                        ["<leader>[p"] = { query = "@parameter.inner", desc = "parameter" },
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        ["]b"] = { query = "@block.outer", desc = "block start" },
                        ["]?"] = { query = "@conditional.outer", desc = "conditional start" },
                        ["]/"] = { query = "@comment.outer", desc = "comment start" },
                        ["]C"] = { query = "@class.outer", desc = "class start" },
                        ["]f"] = { query = "@function.outer", desc = "function start" },
                        ["]z"] = { query = "@fold", query_group = "folds", desc = "fold start" },
                        ["]l"] = { query = "@loop.outer", desc = "loop start" },
                        ["]a"] = { query = "@parameter.inner", desc = "parameter start" },
                        ["]S"] = { query = "@scope", query_group = "locals", desc = "scope" },
                    },
                    goto_next_end = {
                        ["]A"] = { query = "@parameter.outer", desc = "parameter end" },
                        ["]F"] = { query = "@function.outer", desc = "function end" },
                        ["]L"] = { query = "@loop.inner", desc = "loop end" },
                    },
                    goto_previous_start = {
                        ["[/"] = { query = "@comment.outer", desc = "comment start" },
                        ["[?"] = { query = "@conditional.outer", desc = "conditional start" },
                        ["[a"] = { query = "@parameter.inner", desc = "parameter start" },
                        ["[b"] = { query = "@block.outer", desc = "block start" },
                        ["[C"] = { query = "@class.outer", desc = "class start" },
                        ["[f"] = { query = "@function.outer", desc = "function start" },
                        ["[l"] = { query = "@loop.outer", desc = "loop start" },
                        ["[S"] = { query = "@scope", query_group = "locals", desc = "scope" },
                        ["[z"] = { query = "@fold", query_group = "folds", desc = "fold start" },
                    },
                    goto_previous_end = {
                        ["[A"] = { query = "@parameter.outer", desc = "parameter end" },
                        ["[B"] = { query = "@block.outer", desc = "block end" },
                        ["[F"] = { query = "@function.outer", desc = "function end" },
                        ["[L"] = { query = "@loop.outer", desc = "loop end" },
                    },
                },
                lsp_interop = {
                    enable = true,
                    border = "rounded",
                    -- floating_preview_opts = {},
                    peek_definition_code = {
                        ["<leader>pf"] = { query = "@function.outer", desc = "peek function defination" },
                        ["<leader>pc"] = { query = "@class.outer", desc = "peek class defination" },
                        ["<leader>pp"] = { query = "@parameter.inner", desc = "peek parameter" }, -- :)
                    },
                },
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    -- init_selection = "<CR>",
                    node_incremental = "v", -- "<CR>",
                    node_decremental = "V", -- "<BS>",
                    scope_incremental = "<M-CR>",
                },
            },
            refactor = {
                -- alternative RRethy/vim-illuminate
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
                        smart_rename = "<leader>rs",
                    },
                },
                navigation = {
                    enable = true,
                    keymaps = {
                        goto_definition_lsp_fallback = "gd", -- gnd
                        list_definitions = "gl", -- gnD
                        list_definitions_toc = "gO",
                        goto_next_usage = "]]", -- <A-n>
                        goto_previous_usage = "[[", -- <A-p>
                    },
                },
            },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)

            local map = require("utils").map
            local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

            -- Repeat movement with ; and ,
            map({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
            map({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

            -- make builtin f, F, t, T also repeatable with ; and ,
            -- FIX: dot repeat breaks if previous action includes following motion and idk why
            map({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
            map({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
            map({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
            map({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
        end,
    },
}
