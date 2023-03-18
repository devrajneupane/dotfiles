-- Remap space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.background = "dark"
-- vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = false

-- allows unsaved hidden buffers
vim.opt.hidden = true

-- Enable pseduo-transparency for the floating and popup menu
vim.opt.winblend = 15
vim.opt.pumblend = 25
vim.opt.pumheight = 10 -- pop up menu height

-- skip redrawing screen in some cases
-- vim.opt.lazyredraw = true

-- short messages
vim.opt.shortmess = "atIT"

-- show matching paren faster
vim.opt.matchtime = 3

-- write swapfile after 1000 milisecons of inactivity
vim.opt.updatetime = 1000

vim.opt.thesaurus = vim.fn.stdpath("data") .. "/thesaurus.txt"
vim.opt.dictionary = "/usr/share/dict/cracklib-small"

-- live preview of :s results
vim.opt.inccommand = "split"

vim.opt.swapfile = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.showmode = false
vim.opt.showmatch = true -- Show matching brackets.
vim.opt.sidescrolloff = 5 -- minimum number of columns to left and right of cursor
vim.opt.scrolloff = 3 -- minimum numberr of lines above and below cursor

vim.opt.autoindent = true
vim.opt.signcolumn = "yes"
vim.opt.sessionoptions = "buffers,curdir,folds,help,tabpages,terminal,globals"
vim.opt.completeopt = { "menuone", "noselect", "noinsert" }
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.updatetime = 100
vim.opt.writebackup = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "both"
vim.opt.jumpoptions = "view"
vim.opt.virtualedit = "block" -- Useful for selecting a rectangle in Visual mode and editing a table

-- Tab
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.textwidth = 0
vim.opt.expandtab = true

vim.opt.cmdheight = 0 -- Make the cmdline disappear when not in use.
vim.opt.list = true
-- vim.opt.splitkeep = "screen"
vim.opt.syntax = "on"
vim.opt.spelloptions = "camel,noplainbuffer"
vim.opt.foldlevel = 99
vim.o.foldcolumn = "1"
-- vim.o.foldlevelstart = 99
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = true
vim.opt.listchars:append({ tab = "▸ ", extends = "❯", precedes = "❮", nbsp = "±", trail = "⣿" })
vim.opt.fillchars = {
	foldopen = "",
	foldclose = "",
	fold = " ",
	foldsep = " ",
	diff = "/",
	horiz = "⎯",
	horizup = "⎯",
	horizdown = " ",
	vert = " ",
	vertleft = " ",
	vertright = " ",
	verthoriz = " ",
	eob = " ",
}
vim.o.foldcolumn = "1"
vim.opt.mousemoveevent = true

-- Enable filetype detection and filetype-specific plugins and indentation
vim.cmd("filetype plugin indent on")

-- open new split panes to right and bottom, which feels more natural
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Disable text wrap around.
vim.opt.wrap = false

-- Disable VM exit message and statusline.
vim.g.VM_set_statusline = 0
vim.g.VM_silent_exit = 1

-- command completion
vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest,full"
vim.opt.wildignore = "*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx,*DS_STORE,*.db"
