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
    -- enhanced increment/decrement
    {
        "monaqa/dial.nvim",
        config = function()
            local augend = require("dial.augend")
            require("dial.config").augends:register_group({
                default = {
                    augend.integer.alias.decimal_int,
                    augend.integer.alias.hex,
                    augend.integer.alias.octal,
                    augend.integer.alias.binary,
                    augend.date.alias["%Y/%m/%d"],
                    augend.date.alias["%Y-%m-%d"],
                    augend.constant.alias.bool,
                    augend.semver.alias.semver,
                    augend.constant.new({ elements = { "let", "const" } }),
                },
            })
        end,
        keys = {
            { "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
            { "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
        },
    },

    -- Nerd Font Icons, Symbols & Emojis picker
    {
        "ziontee113/icon-picker.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        opts = {
            disable_legacy_commands = true,
        },
        keys = {
            { "<Leader>ip", cmd("IconPickerNormal"), desc = "icon picker" },
            { "A-I", mode = { 'i' }, cmd("IconPickerInsert"), desc = "icon picker" },

        },
    },
}
