-- Remap space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

opt.autowrite = true -- automatically write a file when leaving a modified buffer
opt.autoread = true -- automatically read a file when it was modified outside of Vim

opt.background = "dark" -- the background color birghtness
opt.grepprg = "rg --vimgrep" -- program used for the ":grep" command
opt.grepformat = "%f:%l:%c:%m" -- list of formats for output of 'grepprg"

opt.laststatus = 0
opt.undofile = true -- save undo information in a file
opt.hidden = true -- allows unsaved hidden buffers
opt.diffopt:append("vertical,linematch:60") -- enable linematch diff algorithm

opt.winblend = 5 -- Enable pseduo-transparency for the floating window
opt.pumblend = 15 -- Enable pseduo-transparency for the popup menu
opt.pumheight = 10 -- Maximum number of items to show in the popup menu

vim.g.border_chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" } -- Rounded corner everywhere
opt.shortmess = "catCoOFIT" -- short messages
opt.matchtime = 3 -- show matching paren faster

opt.thesaurus = vim.fn.stdpath("data") .. "/thesaurus.txt"
opt.dictionary = "/usr/share/dict/cracklib-small"

opt.inccommand = "split" -- live preview of :s results

opt.swapfile = false -- don't use swapfile for current buffer
opt.ignorecase = true -- igore case in search patterns
opt.infercase = true -- adjust case of match for keyword completion
opt.smartcase = true -- no ignore case when pattern has uppercase
opt.showmode = false
opt.showmatch = true  -- Show matching brackets.
opt.sidescrolloff = 5 -- minimum number of columns to left and right of cursor
opt.scrolloff = 5     -- minimum numberr of lines above and below cursor

-- indent
opt.autoindent = true -- take indent for new line from previous line
opt.smartindent = true -- smart autoindenting when starting a new line
opt.copyindent = true -- Make autoindent use the same chars as prev line
opt.shiftwidth = 4 -- number of spaces to use for (auto)indent step

opt.signcolumn = "yes" -- always display the signcolumn
opt.sessionoptions = { "buffers", "curdir", "folds", "tabpages", "winsize", "winpos", "terminal", "localoptions" }
-- opt.completeopt = { "menu", "menuone", "noselect" }
opt.completeopt:append{ 'noinsert', 'menuone', 'noselect', 'preview' }
opt.swapfile = false
opt.termguicolors = true
-- opt.updatetime = 100
opt.writebackup = false
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.cursorlineopt = "both"
opt.jumpoptions = "view" -- preserve view while jumping
opt.virtualedit = "block"
opt.switchbuf = "useopen,uselast"
opt.viewoptions = "cursor,folds,slash,unix"
opt.breakindent = true
opt.formatoptions = "jcroqlnt"

-- Tab
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftround = true
opt.textwidth = 0
opt.expandtab = true

opt.cmdheight = 0 -- Make the cmdline disappear when not in use.
opt.list = true -- show <Tab> and <EOL>
opt.syntax = "on" -- syntax highlighting  according to 'filetype' option
opt.spelloptions = { "camel", "noplainbuffer" } -- options for spell checking
opt.spellfile = vim.fn.stdpath("config") .. "/spell/en.utf-8.add" -- files where zg and zw store words

-- Fold
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldcolumn = "1"
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"

opt.listchars:append({ -- list of string used for list mode
    tab = "» ",
    extends = "❯",
    precedes = "❮",
    nbsp = "±",
    trail = "⣿",
})
opt.fillchars:append({ -- characters to use for the status line, folds and filler lines
    eob = " ",
    fold = " ",
    foldclose = "",
    foldopen = "",
    foldsep = " ",
})
vim.o.foldcolumn = "1"
opt.mousemoveevent = true

-- Enable filetype detection and filetype-specific plugins and indentation
vim.cmd("filetype plugin indent on")

-- open new split panes to right and bottom
opt.splitbelow = true
opt.splitright = true

opt.splitkeep = "screen"

-- Disable text wrap around.
opt.wrap = false

-- Disable VM exit message and statusline.
vim.g.VM_set_statusline = 0
vim.g.VM_silent_exit = 1

-- specifies command line completion
opt.wildmode = "list:longest,full"

-- list of patterns to ignore files for file name completion
opt.wildignore:append({ "*.pyc, *.DS_Store" })

-- Disable health checks for these providers.
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
