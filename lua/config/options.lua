-- TODO: rn it's so messy may be i can group options according to their functionality
-- TODO: see :h vim.opt and set each options accordingly
local opt = vim.opt

-- Remap space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

opt.autowrite = true -- automatically write a file when leaving a modified buffer
opt.autoread = true -- automatically read a file when it was modified outside of Vim
opt.swapfile = false -- don't use swapfile for current buffer

opt.background = "dark" -- the background color birghtness
opt.grepprg = "rg --vimgrep" -- program used for the ":grep" command
opt.grepformat = "%f:%l:%c:%m" -- list of formats for output of 'grepprg"

opt.laststatus = 0
opt.undofile = true -- save undo information in a file
opt.hidden = true -- allows unsaved hidden buffers
opt.diffopt:append("vertical,context:4,indent-heuristic,algorithm:histogram,linematch:60") -- just testing i don't use diff so much

-- opt.winblend = 5 -- Enable pseduo-transparency for the floating window
opt.pumblend = 15 -- Enable pseduo-transparency for the popup menu
opt.pumheight = 15 -- Maximum number of items to show in the popup menu

-- vim.g.border_chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" } -- Rounded corner everywhere
vim.g.floating_window_border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" } -- Rounded corner everywhere
opt.shortmess = "catCoOFIT" -- short messages
opt.matchtime = 3 -- show matching paren faster

opt.thesaurus = vim.fn.stdpath("data") .. "/thesaurus.txt"
opt.dictionary = "/usr/share/dict/cracklib-small"

opt.inccommand = "split" -- live preview of :s results
-- opt.synmaxcol = 300 -- Don't highlight syntax for long lines
opt.whichwrap = "h,l" -- allow cursor to wrap to next/prev line

opt.ignorecase = true -- igore case in search patterns
opt.infercase = true -- adjust case of match for keyword completion
opt.smartcase = true -- no ignore case when pattern has uppercase
opt.showmode = false
opt.showmatch = true -- Show matching brackets.
opt.sidescrolloff = 10 -- minimum number of columns to left and right of cursor
opt.scrolloff = 5 -- minimum numberr of lines above and below cursor

-- indent
opt.preserveindent = true -- preserve indent structure as much as possible
opt.autoindent = true -- take indent for new line from previous line
opt.smartindent = true -- smart autoindenting when starting a new line
opt.copyindent = true -- Make autoindent use the same chars as prev line
opt.shiftwidth = 4 -- number of spaces to use for (auto)indent step

opt.signcolumn = "yes:1" -- always display the signcolumn
opt.sessionoptions = { "buffers", "curdir", "folds", "globals", "tabpages", "winsize", "winpos", "terminal", "localoptions" }
opt.completeopt = {  "menuone", "noselect", "noinsert", "preview" }
opt.termguicolors = true
opt.updatetime = 500 -- used for CursorHold autocmd event
opt.writebackup = false -- don't write backup
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.cursorlineopt = "both"
opt.guicursor = { -- enable mode shapes, "Cursor" highlight, and blinking
    "n-v-c-sm:block-Cursor",
    "i-ci-ve:ver25-lCursor",
    "r-cr-o:hor20-Cursor",
    "a:blinkon0",
}
-- opt.jumpoptions = "stack" -- browser like behavior of jumplist (but sometime it sucks)
opt.virtualedit = "block"
opt.switchbuf = "useopen,uselast" -- window to use when jumping
opt.breakindent = true
opt.formatoptions = "12jcrqlnt"

-- Define pattern for a start of 'numbered' list. This is responsible for
-- correct formatting of lists when using `gw`.
vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]

-- Tab
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftround = true
opt.textwidth = 0
opt.expandtab = true -- turn tab into spaces

opt.cmdheight = 0 -- Make the cmdline disappear when not in use.
opt.list = true -- show <Tab> and <EOL>
opt.syntax = "on" -- syntax highlighting  according to 'filetype' option
opt.spelloptions = { "camel", "noplainbuffer" } -- options for spell checking
opt.complete:append('kspell') -- add spell check options for autocomplete
opt.complete:remove('t') -- don't use tags for completion
opt.spellfile = vim.fn.stdpath("config") .. "/spell/en.utf-8.add" -- files where zg and zw store words

-- Fold
opt.foldcolumn = "1"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldcolumn = "1"
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldtext = "nvim_treesitter#foldtext()"

opt.showbreak = "↳ " -- String to put at the start of lines that have been wrapped
opt.listchars:append({ -- list of string used for list mode
    tab = "» ",
    extends = "❯",
    precedes = "❮",
    nbsp = "⦸", -- ± ␣
    trail = "•", -- ⣿
})
opt.fillchars:append({ -- characters to use for displaying special items
    eob = " ",
    diff = "╱", -- 
    fold = " ",
    foldclose = "",
    foldopen = "",
    foldsep = " ",
})

-- Mouse
opt.mousefocus = true
opt.mousemoveevent = true
if vim.fn.has('nvim-0.10') == 1 then
    opt.smoothscroll = true -- currently works with ^E ^Y and mouse
end

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

-- Experimental
opt.emoji = false

-- Disable health checks for these providers.
for _, provider in ipairs { "node", "perl", "python3", "ruby" } do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end
