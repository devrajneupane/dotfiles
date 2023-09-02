-- TODO: add something like <leader>i.. for everything related to info/status like lspinfo, cmpstatus so on
return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
    end,
    opts = {
        window = {
            border = "shadow",
            winblend = 5,
            margin = { 0, 0, 0, 0 },
            padding = { 1, 0, 0, 0 },
        },
        layout = {
            align = "center",
            height = { min = 4, max = 10 }, -- min and max height of the columns
        },
        hidden = { "<Plug>", "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua " },
        disable = { buftypes = { "nofile", "neo-tree" } },
        show_help = false,
        operators = { gc = "comments", ys = "surrounds" },
        triggers_nowait = { "gc", "ys", "<C-X>", "<C-R>"  },
        key_labels = {
            ["<space>"] = "SPC",
            ["<cr>"] = "RET",
            ["<Tab>"] = "TAB",
        },
        -- i think i messed it but still works :)
        keymaps = {
            {
                mode = { "n", "v" },
                ["]"] = { name = "+next" },
                ["["] = { name = "+prev" },
                ["g"] = {
                    name = "+goto",
                    ["?"] = { name = "rot13/debugprint" },
                },
                ["<leader>"] = {
                    ["["] = { name = "+swap " },
                    ["]"] = { name = "+swap " },
                    b = { name = "+buffer 󰈚" }, -- 󰈢
                    d = {
                        name = "debug ",
                        a = { name = "adapter " },
                    },
                    c = { name = "+code " },
                    f = { name = "+find 󰈞 " },
                    g = {
                        name = "+git/gen 󰊢", -- 
                        a = { name = "annotations" },
                    },
                    i = { name = "+icon" },
                    l = { name = "+lsp  " },
                    m = { name = "+make" },
                    n = { name = "+notify💥" },
                    p = { name = "+peek " },
                    q = { name = "+session" },
                    r = { name = "+rename " },
                    s = { name = "+search  " },
                    t = { name = "+term " },
                    u = { name = "+toggle " },
                    w = { name = "+windows/workspace " },
                    x = { name = "+diagnostics/quickfix🚦" },
                    y = { name = "+yank 󰅍" },
                },
            },
            {
                ["<C-X>"] = {
                    mode = "i",
                    ["<C-L>"] = "whole lines",
                    ["<C-N>"] = "current file keywords",
                    ["<C-K>"] = "keywords in 'dictionary'",
                    ["<C-I>"] = "current/included file keywords",
                    ["<C-T>"] = "keywords in thesaurus",
                    ["<C-]>"] = "tags",
                    ["<C-F>"] = "file names",
                    ["<C-D>"] = "definitions or macros", -- which-key uses it to scorll down so can't be used
                    ["<C-V>"] = "vim commands",
                    ["<C-U>"] = "user defined completion", -- which-key uses it to scorll up so can't be used
                    ["<C-O>"] = "omni completion",
                    ["<C-S>"] = "spelling suggestions",
                    ["<C-Z>"] = "stop completion",
                },
            },
        },
    },
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)
        wk.register(opts.keymaps)
    end,
}
