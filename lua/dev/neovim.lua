-- Set space as leader.
vim.g.mapleader = " "

-- Do not show the current mode in cmdline.
vim.cmd("set noshowmode")

-- Clipboard.
-- vim.cmd('set clipboard+=unnamedplus')

-- Enable mouse input.
vim.cmd("set mouse=a")

-- hide buffers with unsaved changes without being prompted
vim.cmd("set hidden")

-- highlight on yank
vim.api.nvim_exec(
	[[
    augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=50, on_visual=true}
    augroup end
]],
	false
)

-- jump to the last position when reopening a file
vim.cmd([[
    if has("autocmd")
        autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
    endif
]])

-- live preview of :s results
vim.cmd('set inccommand = "split"')

-- Keep the sign column open.
vim.cmd("set signcolumn=yes")

-- patterns to ignore ignored when expanding wildcards
vim.cmd('set wildignore += "*.o,*.pyc,*.rej,*.so"')

-- remove whitespace on save
vim.cmd([[autocmd BufWritePre * :%s/\s\+$//e]])

-- open new split panes to right and bottom, which feels more natural
vim.cmd("set splitbelow splitright")

-- completion options
vim.cmd('set completeopt = "menuone,noselect,noinsert"')

-- Syntax.
vim.cmd("set number")
vim.cmd("set relativenumber")
vim.cmd("set cursorline")
vim.cmd("set cursorlineopt=both")
vim.cmd("set hlsearch")
vim.cmd("set ignorecase")
vim.cmd("set smartcase")
vim.cmd("set showmatch") -- Show matching brackets.

-- Tab
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set shiftround")
vim.cmd("set textwidth=0")
vim.cmd("set expandtab")
vim.cmd("set autoindent")
vim.cmd("set smartindent")

-- Enable filetype detection and filetype-specific plugins and indentation
vim.cmd("filetype plugin indent on")

-- show lines above and below cursor (when possible)
vim.cmd("set scrolloff=5")
-- keep 30 columns visible left and right of the cursor at all times
vim.cmd("set sidescrolloff=2")

-- make backspace behave normal
-- vim.cmd('set backspace="indent,start,eol"')

-- Disable text wrap around.
vim.cmd("set nowrap")

-- tab completion for files/bufferss
vim.cmd("set wildmode=longest,list")
vim.cmd("set wildmenu")

-- save read-only files
vim.cmd("command! -nargs=0 Sudow w !sudo tee % >/dev/null")

-- skip redrawing screen in some cases
vim.cmd("set lazyredraw")

-- don't auto commenting new lines
vim.cmd([[autocmd BufEnter * set fo-=c fo-=r fo-=o]])

-- Enables 24-bit RGB color
vim.cmd("set termguicolors")

-- Make the cmdline disappear when not in use.
vim.cmd("set cmdheight=0")

-- Disable VM exit message and statusline.
vim.g.VM_set_statusline = 0
vim.g.VM_silent_exit = 1

-- Neovim fill characters.
vim.opt.fillchars = {
	horiz = "⎯",
	horizup = "⎯",
	horizdown = " ",
	vert = " ",
	vertleft = " ",
	vertright = " ",
	verthoriz = " ",
	eob = " ",
}

-- Enable spell checking for latex.
vim.cmd([[
    autocmd FileType tex setlocal spell
    autocmd FileType tex setlocal spelllang=en
    ]])

-- Change spell checking hl.
vim.cmd("hi SpellBad gui=underline")

-- Set wrap for specific file types.
vim.cmd("autocmd FileType markdown setlocal wrap")
vim.cmd("autocmd FileType tex setlocal wrap")

-- Enable pseduo-transparency for the floating and popup menu
vim.cmd("set winblend=25")
vim.cmd("set pumblend=25")
