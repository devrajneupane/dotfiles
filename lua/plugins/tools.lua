return {
    -- Imporved yank/put
    {
        "gbprod/yanky.nvim",
        event = "TextYankPost",
        cmd = { "YankyRingHistory", "YankyClearHistory" },
        dependencies = "kkharji/sqlite.lua",
        opts = {
            highlight = { timer = 100 },
            ring = { storage = "sqlite" },
        },
        keys = {
            { "<leader>yy", "<Cmd>YankyRingHistory<CR>", desc = "ring history 🍃" },
            { "<leader>yx", "<Cmd>YankyClearHistory<CR>", desc = "clear history 🍃" },
            { "y", "<Plug>(YankyYank)", mode = { "n", "v", "x" }, desc = "yank text" },
            { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "put text after the cursor" },
            { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "put text before the cursor"},
            { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "p but move cursor after new text"},
            { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "P but move cursor after new text" },
            { "<C-n>", "<Plug>(YankyCycleForward)" , desc = "yanky cycle forward"},
            { "<C-p>", "<Plug>(YankyCycleBackward)", desc = "yanky cycle backward"},
            { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "put below current line" },
            { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "put above current line"},
            { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "put below and increase indent" },
            { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "put below and decrease indent" },
            { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "put above and increase indent" },
            { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "put above and decrease indent" },
            { "=p", "<Plug>(YankyPutAfterFilter)", desc = "put below and reindent"},
            { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "put above and reindent" },
        },
    },

    -- enhanced increment/decrement
    {
        "monaqa/dial.nvim",
        config = function()
            local augend = require("dial.augend")
            local config = require("dial.config")

            local default = {
                augend.constant.alias.alpha,
                augend.constant.alias.Alpha,
                augend.constant.alias.bool,
                augend.integer.alias.decimal_int,
                augend.integer.alias.hex,
                augend.integer.alias.octal,
                augend.integer.alias.binary,
                augend.semver.alias.semver,
                augend.date.alias["%H:%M"],
                augend.date.alias["%H:%M:%S"],
                augend.date.alias["%Y/%m/%d"],
                augend.date.alias["%d/%m/%Y"],
                augend.date.alias["%Y-%m-%d"],
                augend.date.alias["%m/%d/%Y"],
                augend.hexcolor.new({ case = "lower" }),
                augend.decimal_fraction.new({ signed = true }),
                augend.constant.new({ elements = { "and", "or" } }),
                augend.constant.new({ elements = { "yes", "no" } }),
                augend.constant.new({ elements = { "on", "off" } }),
                augend.constant.new({ elements = { "left", "right" } }),
                augend.constant.new({ elements = { "up", "down" } }),
                augend.constant.new({ elements = { "True", "False" } }),
                augend.constant.new({ elements = { "break", "continue" } }),
                augend.constant.new({ elements = { "above", "below" } }),
                augend.constant.new({ elements = { "increase", "decrease" } }),
                augend.constant.new({ elements = { "&&", "||" }, word = false }),
                augend.constant.new({ elements = { "!=", "==" }, word = false }),
                augend.constant.new({ elements = { "SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT" } }),
                augend.constant.new({
                    elements = { "sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday" },
                    preserve_case = true,
                }),
                augend.case.new({
                    types = { "camelCase", "snake_case", "PascalCase", "SCREAMING_SNAKE_CASE" },
                    cyclic = true,
                }),
            }
            config.augends:register_group({
                default = default,
            })

            config.augends:on_filetype({
                markdown = vim.list_extend(default, {
                    -- TODO: Markdown Checkbox Toggle
                    augend.integer.alias.decimal,
                    augend.misc.alias.markdown_header,
                }),
                rust = vim.list_extend(default, {
                    augend.paren.alias.rust_str_literal,
                }),
                typescript = vim.list_extend(default, {
                    augend.constant.new({ elements = { "let", "const" } })
                }),
                lua = vim.list_extend(default, {
                    augend.paren.alias.lua_str_literal,
                }),
            })
        end,
        keys = {
            { "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "increment" },
            { "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "decrement" },
            { "g<C-a>", function() return require("dial.map").inc_gnormal() end, expr = true, desc = "increment" },
            { "g<C-x>", function() return require("dial.map").dec_gnormal() end, expr = true, desc = "decrement" },
            { "<C-a>", function() return require("dial.map").inc_visual() end, mode = "v", expr = true, desc = "increment" },
            { "<C-x>", function() return require("dial.map").dec_visual() end, mode = "v", expr = true, desc = "decrement" },
            { "g<C-a>", function() return require("dial.map").inc_gvisual() end, mode = "v", expr = true, desc = "increment" },
            { "g<C-x>", function() return require("dial.map").dec_gvisual() end, mode = "v", expr = true, desc = "decrement" },
        },
    },

    -- debugging with print() way
    {
        'andrewferrier/debugprint.nvim',
        cmd = "DeleteDebugPrints",
        config = true,
        keys = {
            {"g?p", "g?P", },
            {"g?v", "g?V", mode = {'n', 'v'}},
            {"g?o", "g?O", mode = 'o'},
            { "g?c", "<Cmd>DeleteDebugPrints<CR>", desc = "debugprint clear" },
        },
    },

    -- better interface for diffview
    {
        'sindrets/diffview.nvim',
        cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
        opts = {
            default_args = { DiffviewFileHistory = { '%' } },
            enhanced_diff_hl = true,
            hooks = {
                diff_buf_read = function()
                    local opt = vim.opt_local
                    opt.wrap, opt.list, opt.relativenumber = false, false, false
                    opt.colorcolumn = ""
                end,
            },
            keymaps = {
                view = { q = '<Cmd>DiffviewClose<CR>' },
                file_panel = { q = '<Cmd>DiffviewClose<CR>' },
                file_history_panel = { q = '<Cmd>DiffviewClose<CR>' },
            },
        },
        keys = {
            { '<leader>gD', '<Cmd>DiffviewOpen<CR>', desc = 'diffview: open' },
            { '<leader>gh', [[:'<'>DiffviewFileHistory<CR>]], mode = 'v', desc = 'diffview: file history' },
            { '<leader>gh', '<Cmd>DiffviewFileHistory<CR>', desc = 'diffview: file history' },
        },
    },

    -- split/join blocks of code like arrays, hashes etc.
    {
        -- NOTE: simillar plugin CKolkey/ts-node-action
        "Wansmer/treesj",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        opts = {
            use_default_keymaps = false,
            max_join_length = 160,
        },
        keys = {
            { "<leader>cj", "<cmd>TSJToggle<CR>", desc = "split/join code block" },
            {
                "<leader>cJ",
                function () require('treesj').toggle({ split = { recursive = true } }) end,
                desc = "split/join recursively",
            }
        },
    },

    -- Markdown preview
    {
        "toppair/peek.nvim",
        build = "deno task --quiet build:fast",
        enabled = false,
        keys = {
            {
                "<leader>mp",
                function()
                    local peek = require("peek")
                    if peek.is_open() then
                        peek.close()
                    else
                        peek.open()
                    end
                end,
                ft = "markdown",
                desc = "peek: markdown preview"
            },
        },
    },
    -- Markdown preview
    -- TODO: would be better if preview window open as PWA
    {
        "iamcco/markdown-preview.nvim",
        build = function() vim.fn["mkdp#util#install"]() end,
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        config = function() vim.cmd([[do FileType]]) end,
        keys = {
            {
                "<leader>cp",
                "<Cmd>MarkdownPreviewToggle<cr>",
                ft = "markdown",
                desc = "markdown preview",
            },
        },
    },
}
