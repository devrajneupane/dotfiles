local cmd = require("utils").cmd
return {
	-- auto-resize windows
	{
		"anuvyklack/windows.nvim",
		event = "WinNew",
		dependencies = {
			{ "anuvyklack/middleclass" },
			{ "anuvyklack/animation.nvim", enabled = true },
		},
		config = function()
			vim.o.winwidth = 5
			vim.o.equalalways = false
			require("windows").setup({
				animation = { enable = true, duration = 150 },
			})
		end,
		keys = {
			{ "<leader>z", cmd("WindowsMaximize"), desc = "windows: Zoom" },
			{ "<leader>_", cmd("WindowsMaximizeVertically"), desc = "windows: maximize vertically" },
			{ "<leader>|", cmd("WindowsMaximizeHorizontally"), desc = "windows: maximize horizontally" },
			{ "<leader>=", cmd("WindowsEqualize"), desc = "windows: maximize vertically" },
		},
	},
}
