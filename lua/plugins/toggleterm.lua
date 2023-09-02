return {
    {
        "akinsho/toggleterm.nvim",
        cmd = { "ToggleTerm", "TermExec" },
        opts = {
            open_mapping = "<C-\\>",
            shade_terminals = false,
            size = function(term)
                if term.direction == "vertical" then
                    return math.floor(vim.o.columns * 0.3)
                elseif term.direction == "horizontal" then
                    return math.floor(vim.o.lines * 0.4)
                end
            end,
            autochidr = true,
            start_in_insert = true,
            persist_mode = true,
            insert_mapping = false,
            persist_size = false,
            close_on_exit = true,
            float_opts = {
                border = "rounded",
                winblend = 10,
                width = math.floor(vim.o.columns * 0.8),
                height = math.floor(vim.o.lines * 0.8),
            },
            winbar = {
                enabled = true,
                name_formatter = function(term) --  term: Terminal
                    return term.name
                end
            },
            -- highlights = {
            --     FloatBorder = { link = 'FloatBorder' },
            --     NormalFloat = { link = 'NormalFloat' },
            -- },
        },

        -- FIX: doesn't work this way during first setup
        keys = function()
            local terminal = require("toggleterm.terminal").Terminal
            local function term(opts)
                return terminal:new({
                    cmd = opts.cmd,
                    direction = opts.direction or "float",
                    hidden = opts.hidden or true,
                })
            end
            local lazygit = terminal:new({
                cmd = 'lazygit',
                dir = 'git_dir',
                hidden = true,
                direction = 'float',
            })
            local python_repl = terminal:new({
                cmd = 'python',
                hidden = true,
                direction = 'float',
            })
            return {
                { "<leader>tt", "<Cmd>ToggleTerm<CR>", desc = "toggle terminal" },
                { "<leader>tf", "<Cmd>ToggleTerm direction=float<CR>", desc = "toggle terminal float" },
                { "<leader>th", "<Cmd>ToggleTerm size=20 direction=horizontal<CR>", desc = "toggleterm horizontal split" },
                { "<leader>tv", "<Cmd>ToggleTerm size=80 direction=vertical<CR>", desc = "toggleterm vertical split" },
                { "<leader>tb", function() term({cmd = "btop"}):toggle() end, desc = "toggle btop++" },
                { "<leader>tH", function() term({cmd = "htop"}):toggle() end, desc = "toggle htop" },
                { "<leader>tl", function() term({cmd = "lua"}):toggle() end, desc = "life is too short to open terminal and type lua" },
                { "<leader>tg", function() lazygit:toggle() end, desc = "toggle lazygit" },
                { "<leader>tp", function() python_repl:toggle() end, desc = "toggle python repl" },
            }
        end,
    },

    -- Open files from terminal buffers without creating a nested session
    {
        "willothy/flatten.nvim",
        lazy = false,
        priority = 999,
        opts = {
            window = {
                open = "alternate"
            },
            callbacks = {
                block_end = function() require('toggleterm').toggle() end,
                post_open = function(_, winnr, _, is_blocking)
                    if is_blocking then
                        require('toggleterm').toggle()
                    else
                        vim.api.nvim_set_current_win(winnr)
                    end
                end,
            },
        },
    },
}
