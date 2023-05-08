return {
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {
			disable_filetype = { "TelescopePrompt", "vim" },
			check_ts = true, -- enable treesitter
			fast_wrap = {}, -- enable fast_wrap
			map_c_h = true, -- Map the <C-h> key to delete a pair
			map_c_w = true, -- map <c-w> to delete a pair if possible
		},
		config = function(_, opts)
			require("nvim-autopairs").setup(opts)
			--- setup for cmp
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},
	{
		"RRethy/nvim-treesitter-endwise",
		event = "InsertEnter",
		config = function()
			require("nvim-treesitter.configs").setup({
				endwise = {
					enable = true,
				},
			})
		end,
	},
}
