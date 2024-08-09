return {
    { "nvim-tree/nvim-web-devicons", opts = { default = true } },
    { "Fymyte/rasi.vim", ft = "rasi", dependencies = { "nvim-treesitter/nvim-treesitter" } },
    { "kovetskiy/sxhkd-vim", ft = "sxhkd" },
    { "justinsgithub/wezterm-types" },


    -- undo history visualizer
    {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        init = function()
            vim.g.undotree_WindowLayout = 2
            vim.g.undotree_ShortIndicators = 1
            vim.g.undotree_TreeNodeShape = ""
            vim.g.undotree_HelpLine = 0
            vim.g.undotree_TreeVertShape = "│"
            vim.g.undotree_TreeReturnShape = ""
            vim.g.undotree_TreeSplitShape = ""
            -- vim.g.undotree_DiffCommand = "delta"
        end,
        keys = {
            { "<leader>ut", "<Cmd>UndotreeToggle<CR>", desc = "toggle undotree" },
        },
    },

    -- auto save and restore sessions
    -- olimorris/persisted.nvim
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts = {
            options = {
                "buffers",
                "curdir",
                "folds",
                "globals",
                "help",
                "skiprtp",
                "tabpages",
                "winsize",
                "winpos",
                "terminal",
                "localoptions",
            },
        },
        keys = {
            {
                "<leader>qs",
                function()
                    require("persistence").load()
                end,
                desc = "restore session",
            },
            {
                "<leader>ql",
                function()
                    require("persistence").load({ last = true })
                end,
                desc = "restore last session",
            },
            {
                "<leader>qd",
                function()
                    require("persistence").stop()
                end,
                desc = "don't save current session",
            },
        },
    },

    -- comments
    {
        "numToStr/Comment.nvim",
        -- event = "BufReadPost",
        dependencies = {
            {
                "JoosepAlviste/nvim-ts-context-commentstring",
                opts = {
                    enabled_autocmd = false,
                },
            },
        },
        config = function()
            require("Comment").setup({
                ignore = "^$", -- ignores empty lines

                -- Comment.nvim already supports treesitter out-of-the-box for all the languages except tsx/jsx
                pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
                    or vim.bo.commentstring,
            })
        end,
        keys = {
            { "gcc", desc = "toggle line comment" },
            { "gc", mode = { "n", "x" }, desc = "toggle comment" },
            { "gb", mode = { "n", "x" }, desc = "comment toggle blockwise" },
            -- comment text object https://github.com/numToStr/Comment.nvim/issues/22#issuecomment-1272569139
            {
                "u",
                function()
                    local utils = require("Comment.utils")

                    local row = vim.api.nvim_win_get_cursor(0)[1]

                    local comment_str = require("Comment.ft").calculate({
                        ctype = utils.ctype.linewise,
                        range = {
                            srow = row,
                            scol = 0,
                            erow = row,
                            ecol = 0,
                        },
                        cmotion = utils.cmotion.line,
                        cmode = utils.cmode.toggle,
                    }) or vim.bo.commentstring
                    local l_comment_str, r_comment_str = utils.unwrap_cstr(comment_str)

                    local is_commented = utils.is_commented(l_comment_str, r_comment_str, true)

                    local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)
                    if next(line) == nil or not is_commented(line[1]) then
                        return
                    end

                    local comment_start, comment_end = row, row
                    repeat
                        comment_start = comment_start - 1
                        line = vim.api.nvim_buf_get_lines(0, comment_start - 1, comment_start, false)
                    until next(line) == nil or not is_commented(line)
                    comment_start = comment_start + 1
                    repeat
                        comment_end = comment_end + 1
                        line = vim.api.nvim_buf_get_lines(0, comment_end - 1, comment_end, false)
                    until next(line) == nil or not is_commented(line)
                    comment_end = comment_end - 1

                    vim.cmd(string.format("normal! %dGV%dG", comment_start, comment_end))
                end,
                mode = "o",
                desc = "comment",
            },
        },
    },

    -- nvim-surround
    {
        "kylechui/nvim-surround",
        -- event = "BufReadPost",
        config = function()
            vim.cmd.highlight("default link NvimSurroundHighlight Sneak")
            require("nvim-surround").setup({
                move_cursor = false,
                -- indent_lines = false,
            })
        end,
        keys = { { 'S', mode = 'v' }, { '<C-g>s', mode = 'i' }, '<C-g>S', 'ys', 'yss', 'yS', 'cs', 'ds' },
    },

    -- structural search and replace
    {
        "cshuaimin/ssr.nvim",
        opts = {
            border = "rounded",
            min_width = 50,
            min_height = 5,
            max_width = 120,
            max_height = 25,
            keymaps = {
                close = "q",
                next_match = "n",
                prev_match = "N",
                replace_confirm = "<cr>",
                replace_all = "<leader><cr>",
            },
        },
        keys = {
            {
                "<leader>sR",
                function()
                    require("ssr").open()
                end,
                mode = { "n", "x" },
                desc = "structural search and replace",
            },
        },
    },

    -- incremental rename
    {
        "smjonas/inc-rename.nvim",
        cmd = "IncRename",
        config = true,
        keys = {
            {
                "<leader>rr",
                function() return string.format(":IncRename %s", vim.fn.expand("<cword>")) end,
                expr = true,
                silent = false,
                desc = "incremental rename",
            },
        },
    },

    -- Nerd Font Icons, Symbols & Emojis picker
    {
        "ziontee113/icon-picker.nvim",
        -- enabled = false,
        cmd = { "IconPickerNormal", "IconPickerYank" },
        opts = {
            disable_legacy_commands = true,
        },
        keys = {
            { "<leader>fi", "<Cmd>IconPickerNormal nerd_font_v3<CR>", desc = "icon picker" },
            { "<A-i>", "<Cmd>IconPickerInsert<CR>", mode = { "i" }, desc = "icon picker" },
        },
    },

    -- spellcheck dictionary for programmers
    {
        "psliwka/vim-dirtytalk",
        build = ":DirtytalkUpdate",
        ft = "Markdown",
        config = function()
            vim.opt.spelllang:append("programming")
        end,
    },

    -- CellularAutomaton
    {
        "eandrju/cellular-automaton.nvim",
        cmd = "CellularAutomaton",
        config = function()
            local ca = require("cellular-automaton")
            ca.register_animation({
                fps = 60,
                name = "slide",
                update = function(grid)
                    for i = 1, #grid do
                        local prev = grid[i][#grid[i]]
                        for j = 1, #grid[i] do
                            grid[i][j], prev = prev, grid[i][j]
                        end
                    end
                    return true
                end,
            })

            -- taken from TJ's config :)
            ca.register_animation({
                fps = 30,
                name = "scramble",

                update = function(grid)
                    local function is_alphanumeric(c)
                        return c >= "a" and c <= "z" or c >= "A" and c <= "Z" or c >= "0" and c <= "9"
                    end

                    local scramble_word = function(word)
                        local chars = {}
                        while #word ~= 0 do
                            local index = math.random(1, #word)
                            table.insert(chars, word[index])
                            table.remove(word, index)
                        end
                        return chars
                    end
                    for i = 1, #grid do
                        local scrambled = {}
                        local word = {}
                        for j = 1, #grid[i] do
                            local c = grid[i][j]
                            if not is_alphanumeric(c.char) then
                                if #word ~= 0 then
                                    for _, d in pairs(scramble_word(word)) do
                                        table.insert(scrambled, d)
                                    end
                                    word = {}
                                end
                                table.insert(scrambled, c)
                            else
                                table.insert(word, c)
                            end
                        end

                        grid[i] = scrambled
                    end
                    return true
                end,
            })

            local screensaver = function(grid, swapper)
                local get_character_cols = function(row)
                    local cols = {}
                    for i = 1, #row do
                        if row[i].char ~= " " then
                            table.insert(cols, i)
                        end
                    end

                    return cols
                end

                for i = 1, #grid do
                    local cols = get_character_cols(grid[i])
                    if #cols > 0 then
                        local last_col = cols[#cols]
                        local prev = grid[i][last_col]
                        for _, j in ipairs(cols) do
                            prev = swapper(prev, i, j)
                        end
                    end
                end
            end

            ca.register_animation({
                fps = 50,
                name = "screensaver",
                update = function(grid)
                    screensaver(grid, function(prev, i, j)
                        grid[i][j], prev = prev, grid[i][j]
                        return prev
                    end)

                    return true
                end,
            })

            ca.register_animation({
                fps = 50,
                name = "screensaver-inplace-hl",
                update = function(grid)
                    screensaver(grid, function(prev, i, j)
                        grid[i][j].char, prev.char = prev.char, grid[i][j].char
                        return prev
                    end)

                    return true
                end,
            })

            ca.register_animation({
                fps = 50,
                name = "screensaver-inplace-char",
                update = function(grid)
                    screensaver(grid, function(prev, i, j)
                        grid[i][j].hl_group, prev.hl_group = prev.hl_group, grid[i][j].hl_group
                        return prev
                    end)
                    return true
                end,
            })
        end,
        keys = {
            { "<leader>mr", "<Cmd>CellularAutomaton make_it_rain<CR>", desc = "make it rain" },
            { "<leader>mg", "<Cmd>CellularAutomaton game_of_life<CR>", desc = "game of life" },
            { "<leader>ms", "<Cmd>CellularAutomaton slide<CR>", desc = "make it slide" },
        },
    },

    -- WPM calculator
    {
        "jcdickinson/wpm.nvim",
        event = "InsertEnter",
        config = true,
    },
}
