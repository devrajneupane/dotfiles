local utils = require("utils")
local function map(modes, lhs, rhs, options)
    local default_options = { silent = true, noremap = true }
    options = options and vim.tbl_extend("keep", options, default_options) or default_options
    vim.keymap.set(modes, lhs, rhs, options)
end

--------------------------
-- General key bindings --
--------------------------

-- join lines without changing your cursor position
map("n", "J", "mzJ`z")

-- keep cursor centered
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Remap command key
map({ "n", "v" }, "<leader><leader>", ":")
map({ "n", "v" }, "<C-P>", ":")

-- Move lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { expr = true, desc = "Move line down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { expr = true, desc = "Move line up" })

-- Paste without loosing clipboard in visual mode
map("v", "<leader>p", '"_dP', { desc = "paste without loosing clipboard" })

-- Yank into system clipboard
map("n", "<leader>Y", [["+Y]])
map({ "n", "v" }, "<leader>y", [["+y]])
map({ "n", "v" }, "<leader>B", [["_d]])

-- quick fix
map("n", "<leader>K", "<cmd>cnext<CR>zz", { desc = "display the next error" })
map("n", "<leader>J", "<cmd>cprev<CR>zz", { desc = "display the previous error" })
map("n", "<leader>k", "<cmd>lnext<CR>zz")
map("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Copy current file path
map({ "n", "v" }, "<leader>cp", '<cmd>let @+ = expand("%")<CR>', { desc = "copy relative path of current file" })
map({ "n", "v" }, "<leader>cP", '<cmd>let @+ = expand("%:p")<CR>', { desc = "copy absolute path of current file" })

-- Find and Replace
map(
    { "n", "v" },
    "<leader>s",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Find and Replace word under cursor" }
)

-- Make current buffer executable
map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { desc = "make current file executable" })

-- Navigate buffers
map("n", "<C-M-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<C-M-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Save file
map({ "i", "v", "n" }, "<C-s>", "<cmd>w!<cr><esc>", { desc = "Save file" })

-- Disable the search highlight when hitting esc.
map("n", "<Esc>", "<Cmd>noh<CR>")

---------------
-- Telescope --
---------------

-- Search for recent files.
map({ "n", "v" }, "<leader>fr", "<Cmd>Telescope oldfiles<CR>")

-- Buffers.
map({ "n", "v" }, "<leader>fb", "<Cmd>Telescope buffers<CR>")

-- Resizing windows.
map("n", "<A-.>", "<Cmd>vertical resize +5<CR>")
map("n", "<A-,>", "<Cmd>vertical resize -5<CR>")
map("n", "<A-<>", "<Cmd>horizontal resize +5<CR>")
map("n", "<A->>", "<Cmd>horizontal resize -5<CR>")

-- CLose buffer
map({ "i", "v", "n" }, "<C-M-w>", "<cmd>bd!<cr><esc>", { desc = "Close buffer" })

-- Tab
map("n", "<Leader>tn", ":tabnew<CR>")
map("n", "<Leader>tc", ":tabclose<CR>")

-- Undo in insert mode.
map("i", "<c-z>", "<c-o>u")

-- Exit neovim
map({ "i", "v", "n" }, "<M-q>", "<cmd>qa<cr>", { desc = "Exit Vim" })
-- map({ "i", "v", "n" }, "<C-M-q>", "<cmd>qa!<cr>", { desc = "Exit without saving any changes" })

-- toggle relative numbering
map({ "n", "v" }, "<leader>ln", "<Cmd>set rnu!<CR>", { desc = "toggle relativenumber" })

---------
-- LSP --
---------

local opts = { remap = false }

-- displays hover information about the symbol under the cursor
map("n", "K", function()
    vim.lsp.buf.hover()
end, { remap = false })

-- jumps to the definition of the symbol under the cursor
map("n", "gd", function()
    vim.lsp.buf.definition()
end)

-- jumps to the declaration of the symbol under the cursor
map("n", "gD", function()
    vim.lsp.buf.declaration()
end)

-- Lists all the references to the symbol under the cursor
map("n", "gr", function()
    vim.lsp.buf.references()
end, opts)

-- Selects a code action available at the current cursor position
map("n", "<leader>gc", function()
    vim.lsp.buf.code_action()
end, opts)

-- Displays signature information about the symbol under the cursor
map("n", "<Leader>gh", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { desc = "display signature information" })

-- Lists all the implementations for the symbol under the cursor
map("n", "<Leader>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")

-- Jumps to the definition of the type of the symbol under the cursor
map("n", "<Leader>go", "<cmd>lua vim.lsp.buf.type_definition()<CR>")

-- Renames all references to the symbol under the cursor
map("n", "RR", "<cmd>lua vim.lsp.buf.rename()<CR>", { silent = true })

-- Lists all symbols in the current workspace in the quickfix window.
map("n", "<leader>ws", function()
    vim.lsp.buf.workspace_symbol()
end, opts)

-- LSP format
map("n", "<leader>ft", function()
    vim.lsp.buf.format({ async = false })
    vim.api.nvim_command("write")
end, { desc = "Lsp formatting" })

-- Open Lazy
map({ "n", "v" }, "<leader>L", "<Cmd>Lazy<CR>", { desc = "open lazy window" })

-- Open Mason graphical status window.
map({ "n", "v" }, "<leader>M", "<Cmd>Mason<CR>", { desc = "open mason window" })

-- Mimic shell movements
map("i", "<C-E>", "<ESC>A")
map("i", "<C-A>", "<ESC>I")

-- Sessions.
local session_file = vim.fn.stdpath("data") .. "/sessions/session.vim"
map("n", "<leader>S", ":mksession!" .. session_file .. "<CR>", { desc = "save current session" })
map("n", "<leader>R", ":source" .. session_file .. "<CR>", { desc = "reload last session" })

-- toggle options
map("n", "<leader>tw", function()
    utils.toggle("wrap")
end, { desc = "Toggle Word Wrap" })
map("n", "<leader>ts", function()
    utils.toggle("spell")
end, { desc = "Toggle Spelling" })
map("n", "<leader>tl", function()
    utils.toggle("relativenumber")
end, { desc = "Toggle Line Numbers" })
map("n", "<leader>td", utils.toggle_diagnostics, { desc = "Toggle Diagnostics" })
map("n", "<leader>q", utils.toggle_quickfix, { desc = "Toggle Quickfix Window" })
