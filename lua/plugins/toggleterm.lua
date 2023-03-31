return {
	{
		"akinsho/toggleterm.nvim",
		cmd = { "ToggleTerm", "TermExec" },
		opts = {
			shade_terminals = false,
			size = function(term)
				if term.direction == "vertical" then
					return math.floor(vim.o.columns * 0.3)
				elseif term.direction == "horizontal" then
					return math.floor(vim.o.lines * 0.4)
				end
			end,
			float_opts = {
				border = "rounded",
				winblend = 10,
				width = math.floor(vim.o.columns * 0.8),
				height = math.floor(vim.o.lines * 0.8),
			},
		},

		-- FIX: doesn't work this way during first setup
		keys = function()
			local terminal = require("toggleterm.terminal").Terminal
			local term = function(cmd, direction)
				return terminal:new({ cmd = cmd, direction = direction or "float" })
			end
			return {
				{ "<leader>tt", "<CMD>ToggleTerm<CR>", desc = "Toggle Terminal" },
				{ "<leader>tf", "<CMD>ToggleTerm direction=float<CR>", desc = "Toggle terminal float" },
				{
					"<leader>tb",
					function()
						term("btop"):toggle()
					end,
					desc = "Toggle btop++",
				},
				{
					"<leader>th",
					function()
						term("htop"):toggle()
					end,
					desc = "Toggle htop",
				},
			}
		end,
	},
    -- Open files from terminal buffers without creating a nested session
	{
		"willothy/flatten.nvim",
		lazy = false,
		priority = 999,
		config = true,
	},
}
