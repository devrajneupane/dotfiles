return {
	"nvim-neo-tree/neo-tree.nvim",
	cmd = "Neotree",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-tree/nvim-web-devicons", lazy = true },
		{ "MunifTanjim/nui.nvim", lazy = true },
	},
	init = function()
		vim.g.neo_tree_remove_legacy_commands = true

		if vim.fn.argc() == 1 then
			---@diagnostic disable-next-line: param-type-mismatch
			local stat = vim.loop.fs_stat(vim.fn.argv(0))
			if stat and stat.type == "directory" then
				require("neo-tree").foucs()
			end
		end
	end,
	opts = {
		auto_clean_after_session_restore = true,
		popup_border_style = "rounded",
		open_files_do_not_replace_types = { "help", "terminal", "trouble", "qf" },
		filesystem = {
			bind_to_cwd = false,
			follow_current_file = true,
			hijack_netrw_behaviour = "open_current",
            use_libuv_file_watcher=true,
			filtered_items = {
				visible = true, -- grey out dotfiles
				hide_dotfiles = false,
			},
		},
		window = {
			width = 30,
			-- mappings = {
			-- 	["<space>"] = false, -- disable space
			-- },
		},
		default_component_configs = {
			indent = {
				with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
				expander_collapsed = "",
				expander_expanded = "",
				expander_highlight = "NeoTreeExpander",
			},
		},
	},
	keys = {
		{ "<leader>e", "<Cmd>Neotree reveal toggle<CR>", desc = "Neotree toggle" },
		{ "<leader>fe", "<Cmd>Neotree reveal toggle<CR>", desc = "Neotree toggle" },
		{ "<leader>bb", "<Cmd>Neotree toggle show buffers right<CR>", desc = "Neotree buffers" },
		{ "<leader>fo", "<Cmd>Neotree reveal_file=%<CR>", desc = "Neotree reveal current file" },
	},
}
