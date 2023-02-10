-- Modes
local all_modes = { 'n', 'i', 'v', 't' }
local exclude_t = { 'n', 'v' }
local exclude_i = { 'n', 'v', 't' }
local n_v       = { 'n', 'v' }
local n_t       = { 'n', 't' }
local n         = 'n'

local map_key = vim.keymap.set

-- Default config for the keymaps.
local default_settings = {
    noremap = true,
    silent = true,
}

--------------------------
-- General key bindings --
--------------------------

-- join lines without changing your cursor position
map_key(n, "J", "mzJ`z")

-- keep cursor centered
map_key(n, "<C-d>", "<C-d>zz")
map_key(n, "<C-u>", "<C-u>zz")
map_key(n, "n", "nzzzv")
map_key(n, "N", "Nzzzv")

-- Move lines
map_key("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map_key("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map_key("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map_key("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map_key("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map_key("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- paste without loosing  buffer
map_key("x", "<leader>p", "\"_dP")

-- Yank into system clipboard
map_key(n, "<leader>Y", [["+Y]])
map_key(n_v, "<leader>y", [["+y]])
map_key(n_v, "<leader>B", [["_d]])

-- quick fix
map_key(n, "<C-k>", "<cmd>cnext<CR>zz")
map_key(n, "<C-j>", "<cmd>cprev<CR>zz")
map_key(n, "<leader>k", "<cmd>lnext<CR>zz")
map_key(n, "<leader>j", "<cmd>lprev<CR>zz")

-- Find and Replace
map_key(n, "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Make current buffer executable
map_key(n, "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Moving windows.
map_key(n_t, '<C-h>', '<Cmd>wincmd h<CR>', default_settings)
map_key(n_t, '<C-j>', '<Cmd>wincmd j<CR>', default_settings)
map_key(n_t, '<C-k>', '<Cmd>wincmd k<CR>', default_settings)
map_key(n_t, '<C-l>', '<Cmd>wincmd l<CR>', default_settings)

-- unbind Q
map_key(n, "Q", "<nop>")

---------------
-- Telescope --
---------------

-- Search for files in current directory.
map_key(exclude_t, '<leader>ff', '<Cmd>Telescope find_files<CR>', default_settings)

-- Grep for a string in the current directory.
map_key(exclude_t, '<leader>tg', '<Cmd>Telescope live_grep<CR>', default_settings)

-- Search for recent files.
map_key(exclude_t, '<leader>fr', '<Cmd>Telescope oldfiles<CR>', default_settings)

-- Buffers.
map_key(exclude_t, '<leader>fp', '<Cmd>Telescope buffers<CR>', default_settings)

-- Finding.
map_key(exclude_t, '<C-f>', '<Cmd>Telescope current_buffer_fuzzy_find previewer=false<CR>', default_settings)

-- Fugitive
map_key(n, "<leader>gs", vim.cmd.Git, default_settings)

-- Toggle the file explorer.
map_key(all_modes, '<F2>', '<Cmd>NvimTreeToggle<CR>', default_settings)
map_key(n, '<Leader>fe', '<Cmd>NvimTreeToggle<CR>', default_settings)
map_key(n, '<Leader>fo', '<Cmd>NvimTreeFindFileToggle<CR>', default_settings)

-- Cheatsheet.
map_key(all_modes, '<F12>', '<Cmd>Cheatsheet<CR>', default_settings)

-- Make executable
map_key(n, "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Tmux
map_key(n, "<leader>tm", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- Sessions.
map_key(n, "<leader>S", ':mksession! ~/.vim/session.vim<CR>', default_settings)
map_key(n, "<leader>R", ':source ~/.vim/session.vim<CR>', default_settings)

-- Resizing windows.
map_key(n, '<A-.>', '<Cmd>vertical resize +5<CR>', default_settings)
map_key(n, '<A-,>', '<Cmd>vertical resize -5<CR>', default_settings)
map_key(n_t, '<A-<>', '<Cmd>horizontal resize +5<CR>', default_settings)
map_key(n_t, '<A->>', '<Cmd>horizontal resize -5<CR>', default_settings)

-- Functions that only saves buffers that has files.
function Save_file()
    local modifiable = vim.api.nvim_buf_get_option(0, 'modifiable')
    if modifiable then
        vim.cmd 'w!'
    end
end

map_key(exclude_t, '<C-s>', '<Cmd>lua Save_file()<CR>', default_settings)

-- Disable the search highlight when hitting esc.
map_key(n, '<Esc>', '<Cmd>noh<CR>', { noremap = false })

-- toggle relative numbering
map_key(n_v, '<leader>ln', '<Cmd>set rnu!<CR>', default_settings)

-- Undo.
map_key(exclude_t, '<C-Z>', '<Cmd>undo<CR>', default_settings)

-- Redo.
map_key(exclude_t, '<C-Y>', '<Cmd>redo<CR>', default_settings)

-------------
-- Zen Mode--
-------------

map_key(n, "<leader>zn", ":TZNarrow<CR>", default_settings)
map_key(n, "<leader>zf", ":TZFocus<CR>", default_settings)
map_key(n, "<leader>zm", ":TZMinimalist<CR>", default_settings)
map_key(n, "<leader>za", ":TZAtaraxis<CR>", default_settings)
map_key("v", "<leader>zn", ":'<,'>TZNarrow<CR>", default_settings)

---------
-- UFO --
---------

map_key(n, "zR", require("ufo").openAllFolds)
map_key(n, "zM", require("ufo").closeAllFolds)

------------
-- Barbar --
------------

-- Move.
map_key(n, '<C-<>', '<Cmd>BufferMovePrevious<CR>', default_settings)
map_key(n, '<C->>', '<Cmd>BufferMoveNext<CR>', default_settings)

-- Closing.
map_key(n, '<C-q>', '<Cmd>BufferDelete<CR>', default_settings)
map_key(n, 'db', '<Cmd>BufferPickDelete<CR>', default_settings)
map_key(n, '<C-w><C-c>', '<Cmd>wincmd c<CR>', default_settings)

-- Selecting.
map_key(n, 'gb', '<Cmd>BufferPick<CR>', default_settings)
map_key(n, '<C-,>', '<Cmd>BufferPrevious<CR>', default_settings)
map_key(n, '<C-.>', '<Cmd>BufferNext<CR>', default_settings)

-- Pin buffer.
map_key(n, '<C-P>', '<Cmd>BufferPin<CR>', default_settings)

---------
-- LSP --
---------

local opts = { remap = false }

-- displays hover information about the symbol under the cursor
map_key(n, "K", function() vim.lsp.buf.hover() end, { remap = false })

-- jumps to the definition of the symbol under the cursor
map_key(n, "gd", function() vim.lsp.buf.definition() end, { silent = true })

-- jumps to the declaration of the symbol under the cursor
map_key(n, "gD", function() vim.lsp.buf.declaration() end, { silent = true })

-- Lists all the references to the symbol under the cursor
map_key(n, "gr", function() vim.lsp.buf.references() end, opts)

-- Selects a code action available at the current cursor position
map_key(n_v, "<leader>gc", function() vim.lsp.buf.code_action() end, opts)

-- Displays signature information about the symbol under the cursor
map_key(n, "<Leader>gh", "<cmd>lua vim.lsp.buf.signature_help()<CR>")

-- Lists all the implementations for the symbol under the cursor
map_key(n, "<Leader>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")

-- Jumps to the definition of the type of the symbol under the cursor
map_key(n, "<Leader>go", "<cmd>lua vim.lsp.buf.type_definition()<CR>")

-- Renames all references to the symbol under the cursor
map_key(n_v, "RR", "<cmd>lua vim.lsp.buf.rename()<CR>", { silent = true })

-- Lists all symbols in the current workspace in the quickfix window.
map_key(n, "<leader>ws", function() vim.lsp.buf.workspace_symbol() end, opts)

-- Format
map_key(n, "<leader>ft", vim.lsp.buf.format)

-- Open Mason graphical status window.
map_key(exclude_i, "<leader>ms", "<Cmd>Mason<CR>", default_settings)

-- Mimic shell movements
map_key('i', '<C-E>', '<ESC>A', default_settings)
map_key('i', '<C-A>', '<ESC>I', default_settings)

--------------
-- Terminal --
--------------

local terminal = require('toggleterm.terminal').Terminal

-- Terminal.
local term = terminal:new({ cmd = "bash", hidden = true, direction = "float" })
map_key(n, "<Leader>t", function() term:toggle() end, default_settings)

-- Btop++.
local btop = terminal:new({ cmd = "btop", hidden = true, direction = "float" })
map_key(n, "<Leader>b", function() btop:toggle() end, default_settings)

-- Nvtop
local nvtop = terminal:new({ cmd = "nvtop", hidden = true, direction = "float" })
map_key(n, "<Leader>n", function() nvtop:toggle() end, default_settings)

------------
-- Vimtex --
------------

map_key(n, "gl", "<Cmd>VimtexView<CR>", default_settings)

-------------
-- Trouble --
-------------

map_key(n, "<leader>d", "<Cmd>TroubleToggle document_diagnostics<CR>", default_settings)
map_key(n, "<leader>D", "<Cmd>TroubleToggle workspace_diagnostics<CR>", default_settings)

-- show diagnostics in a floating window
map_key(n, "<leader>gd", function() vim.diagnostic.open_float() end, opts)

-- Diagnsotic jump
map_key(n, "[d", function() vim.diagnostic.goto_next() end, opts)
map_key(n, "]d", function() vim.diagnostic.goto_prev() end, opts)


-----------------------
-- Working directory --
-----------------------

-- Change the cwd to the directory of the current active buffer.
function _cwd_current_buffer()
    local abs_path = vim.api.nvim_buf_get_name(0)
    local dir = abs_path:match("(.*[/\\])")
    if dir == nil then
        return
    end
    vim.cmd("cd " .. dir)
end

map_key(n_v, "<leader>cd", "<Cmd>lua _cwd_current_buffer()<CR><Cmd>NvimTreeRefresh<CR>", default_settings)

-- Misc
map_key(exclude_i, "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>")
