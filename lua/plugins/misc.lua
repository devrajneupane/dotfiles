return {
	{
		"kylechui/nvim-surround",
		keys = {
			"ys",
			"yS",
			"ds",
			"cs",
			{ "S", mode = "x" },
			{ "gS", mode = "x" },
			{ "<C-g>s", mode = "i" },
			{ "<C-g>S", mode = "i" },
		},
		config = function()
			vim.cmd.highlight("default link NvimSurroundHighlight Todo")
			require("nvim-surround").setup()
		end,
	},
}
