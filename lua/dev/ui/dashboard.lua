local config = {}

config.mru = {}
config.mru.limit = 10

config.project = {}
config.project.limit = 5

config.shortcut = {
	{
		desc = "  New file ",
		action = "enew",
		group = "@string",
		key = "n",
	},
	{
		desc = "   Update ",
		action = "PackerSync",
		group = "@string",
		key = "u",
	},
	{
		desc = "   File/path ",
		action = "Telescope find_files find_command=rg,--hidden,--files",
		group = "@string",
		key = "f",
	},
	{
		desc = "   Quit ",
		action = "q!",
		group = "@macro",
		key = "q",
	},
}

config.header = {
	"███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
	"████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
	"██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
	"██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
	"██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
	"╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
}

config.footer = {
	"Great ideas often receive violent opposition from mediocre minds. - Albert Einstein",
}

config.packages = {}
config.packages.enable = true

-- padding
config.packages.bottom_padding = 3
config.packages.top_padding = 1
config.header_bottom_padding = 3
config.footer_top_padding = 3

-- Setup.
require("dashboard").setup({
	theme = "hyper",
	config = config,
})

-- local quote, author = require("dev.utils").quote()
-- local conf_file = vim.fn.stdpath("cache") .. "/dashboard/conf"
-- local file = assert(io.open(conf_file, "r+"))
-- local content = file:read("*all")
-- file:close()

-- local data = vim.json.decode(content)
-- data.config.footer = { quote .. " -" .. author }

-- local file = assert(io.open(conf_file, "w"))
-- file:write(vim.json.encode(data))
-- file:close()
