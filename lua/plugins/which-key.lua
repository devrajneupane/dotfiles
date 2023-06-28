return {
	{
		"folke/which-key.nvim",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
            window = { winblend = 30 },
            disable = { buftypes = { "nofile", "neo-tree" } },
            show_help = false,
            show_keys = true,
            operators = { gc = "Comments" },
			keymaps = {
				mode = { "n", "v" },
				["]"] = { name = "+next" },
				["["] = { name = "+prev" },
                ["g"] = { name = "+goto" },
                ["<leader>"] = {
                    ['['] = { name = "+swap-prev" },
                    [']'] = { name = "+swap-next" },
                    b = { name = "+buffer 󰈢" },
                    c = { name = "+code  " },
                    f = { name = "+file/find 󰈞 " },
                    g = { name = "+git/gen " },
                    i = { name = "+icon" },
                    l = { name = "+lsp  " },
                    m = { name = "+make" },
                    n = { name = "+notify/noice💥" },
                    r = { name = "+󰑕" },
                    s = { name = "+search/swap   " },
                    t = { name = "+term " },
                    w = { name = "+windows/workspace " },
                    x = { name = "+diagnostics/quickfix🚦" },
                    y = { name = "+yank 󰅍" },
                },
			},
		},
		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)
			wk.register(opts.keymaps)
		end,
		keys = { "<leader>", "g", '"', "'", "`" },
	},
}
