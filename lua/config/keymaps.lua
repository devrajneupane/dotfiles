-- TODO: make normal mode is default mode for all keymaps unless mode is defined explicitly
local utils = require("utils")
local map = utils.map

-- Remap for dealing with word wrap and adds jumps to jump list
map("n", "j", [[(v:count > 1 ? 'm`' . v:count : 'g') . 'j']], { expr = true })
map("n", "k", [[(v:count > 1 ? 'm`' . v:count : 'g') . 'k']], { expr = true })

-- keep cursor centered
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

map("n", "J", "mzJ`z") -- join lines without changing your cursor position

-- i use macro BTW
map("n", "Q", "@qj") -- TODO: would be better to use last recorded macro automatically
map("x", "Q", "<Cmd>norm @q<CR>")

-- Execute macro over a visual region
map("x", "@", function()
    return ":norm⋅@" .. vim.fn.getcharstr() .. "<cr>"
end, { expr = true })

map("n", "<leader>qq", "<Cmd>qa!<CR>", { desc = "exit nvim" })
map("n", "<leader>;", ":= ", { silent = false, desc = "lua cmdline" })

-- Make the single quote work like a backtick
-- FIX: not working, i think some plugin remap this agian. works when mapped through lua cmdline
map("n", "'", "`")

-- Better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

vim.cmd([[nnoremap <C-i> <C-i>]]) -- tmux sucks, and it still sucks

-- Move lines
map("n", "<A-j>", "<Cmd>m .+1<CR>==", { desc = "move line down" })
map("n", "<A-k>", "<Cmd>m .-2<CR>==", { desc = "move line up" })
map("i", "<A-j>", "<esc><Cmd>m .+1<CR>==gi", { desc = "move line down" })
map("i", "<A-k>", "<esc><Cmd>m .-2<CR>==gi", { desc = "move line up" })
map("v", "<A-j>", ":move '>+1<CR>gv=gv", { desc = "move line down" })
map("v", "<A-k>", ":move '<-2<CR>gv=gv", { desc = "move line up" })

-- Saner behavior of n and N
map({ "n", "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "next search result" })
map({ "n", "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "prev search result" })

-- Terminal
map("t", "<C-q>", "<C-\\><C-n><C-w>c", { desc = "close terminal" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "focus top window" })
map("t", "<esc>", "<C-\\><C-n>", { desc = "escape terminal mode" })

-- Yank/Put with system clipboard
-- TODO: may be yanky.nvim do the job
map("n", "gY", [["+Y]], { desc = "yank line to system clipboard" })
map("x", "gy", '"+y', { desc = "yank motion/selection to system clipboard" })
map({ "n", "x" }, "gP", '"+p', { desc = "yank motion/selection to system clipboard" })

-- Copy current file path
map({ "n", "v" }, "<leader>yp", '<Cmd>let @+ = expand("%")<CR>', { desc = "yank relative path" })
map({ "n", "v" }, "<leader>yP", '<Cmd>let @+ = expand("%:p")<CR>', { desc = "yank absolute path" })
map({ "n", "v" }, "<leader>yf", '<Cmd>let @+ = expand("%:t")<CR>', { desc = "yank filename" })

-- quick fix
map("n", "<leader>j", "<Cmd>cprev<CR>zz", { desc = "prev error" })
map("n", "<leader>k", "<Cmd>cnext<CR>zz", { desc = "next error" })
map("n", "<leader>K", "<Cmd>lnext<CR>zz", { desc = "next location" })
map("n", "<leader>J", "<Cmd>lprev<CR>zz", { desc = "next location" })

-- Find and Replace
map(
    { "n", "v" },
    "<leader>sr",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { silent = false, desc = "replace word under cursor" }
)
map("x", "g/", "<esc>/\\%V", { silent = false, desc = "search inside visual selection" })

-- windows
map("n", "<C-k>", "<C-w>k", { desc = "focus top window" })
map("n", "<C-j>", "<C-w>j", { desc = "focus bottom window" })
map("n", "<C-h>", "<C-w>h", { desc = "focus left window" })
map("n", "<C-l>", "<C-w>l", { desc = "focus right window" })
map("n", "<A-h>", "<Cmd>vertical resize -5<CR>", { desc = "vertical resize ⬅" })
map("n", "<A-l>", "<Cmd>vertical resize +5<CR>", { desc = "vertical resize ➡" })
map("n", "<A-,>", "<Cmd>horizontal resize -5<CR>", { desc = "horizontal resize ⬆" })
map("n", "<A-.>", "<Cmd>horizontal resize +5<CR>", { desc = "horizontal resize ⬇" })
map("n", "<leader>wh", "<Cmd>wincmd H<CR>", { desc = "move current window to right" })
map("n", "<leader>wl", "<Cmd>wincmd L<CR>", { desc = "move current window to left" })
map("n", "<leader>wj", "<Cmd>wincmd J<CR>", { desc = "move current window to down" })
map("n", "<leader>wk", "<Cmd>wincmd K<CR>", { desc = "move current window to up" })
map("n", "<leader>wo", "<Cmd>wincmd o<CR>", { desc = "close other windows" })
map("n", "<leader>wc", "<Cmd>wincmd c<CR>", { desc = "close currnet window" })

-- buffers
map("n", "gS", utils.new_scratch_buffer, { desc = "scratch buffer" })
map("n", "<leader>be", "<Cmd>edit!<CR>", { desc = "reload buffer" })
map("n", "<leader>bn", "<Cmd>enew<CR>", { desc = "new buffer" })
map("n", "<leader>bv", "<Cmd>vnew<CR>", { desc = "new buffer in vertical split" })
map("n", "<leader>br", "<Cmd>buffer # | e!<CR>", { desc = "reopen closed buffer" })
map("n", "<leader>bs", "<Cmd>w!<CR>", { desc = "save buffer" })
map({ "n", "v", "i" }, "<C-s>", "<Cmd>silent update<CR>", { desc = "save buffer" })
map("n", "<leader>X", "<Cmd>Hashbang<CR>", { desc = "add hashbang" })
-- map("n", "<leader>bw", cmd"%bdelete<Bar>edit#<Bar>bdelete#", { desc = "close other bufffers " })

-- tabs
map("n", "<Leader>tn", "<Cmd>tabnew<CR>", { desc = "create new tab" })
map("n", "<Leader>tc", "<Cmd>tabclose<CR>", { desc = "close current tab" })
map("n", "<Leader>t0", "<Cmd>tabonly<CR>", { desc = "close all other tab pages" })

-- Disable the search highlight when hitting esc.
map("n", "<Esc>", "<Cmd>noh<CR><Esc>")

-- Mimic shell movements
map({ "i", "c" }, "<C-a>", "<Home>")
map({ "i", "c" }, "<C-e>", "<End>")

map({ "c" }, ":%", "<C-r>=fnameescape(expand('%'))<cr>")
map({ "i", "c" }, "::", "<C-r>=fnameescape(expand('%:p:h'))<cr>/")

map("i", "<S-Enter>", "<C-o>O") -- new line above current line
map("i", "<C-Enter>", "<C-o>o") -- new line below current line

map("n", "0", "getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^'", { expr = true })
map("n", "g>", [[<cmd>set nomore<bar>40messages<bar>set more<CR>]], { desc = "show message history" })
map("n", "gL", utils.execute_lua_line, { desc = "run `lua` line" })

-- Add undo break-points
map("i", ",", ",<C-g>u")
map("i", ".", ".<C-g>u")
map("i", ";", ";<C-g>u")
map("i", ":", ":<C-g>u")
map("i", "!", ";<C-g>u")
map("i", "?", ":<C-g>u")

map("i", "<C-z>", "<C-o>u") -- Undo in insert mode.

---@see: https://stackoverflow.com/a/16481737
map("n", "<leader>cz", "[s1z=", { desc = "correct latest misspelled word" })
map("i", "<M-s>", "<C-g>u<Esc>[s1z=`]a<C-g>u", { desc = "correct latest misspelled word" })

-- motion to operate on entire buffer
map("o", "aE", ":<C-U>normal! mzggVG<CR>`z")
map("x", "aE", ":<C-U>normal! ggVG<CR>")

-- Open Lazy
map("n", "<leader>L", "<Cmd>Lazy<CR>", { desc = "Lazy" })

-- toggle options
map("n", "<leader>un", function() utils.option("relativenumber") end, { desc = "toggle relativenumber" })
map("n", "<leader>uw", function() utils.option("wrap") end, { desc = "toggle wrap" })
map("n", "<leader>us", function() utils.option("spell") end, { desc = "toggle spell" })
map("n", "<leader>ui", vim.show_pos, { desc = "inspect pos" })
map("n", "<leader>ud", utils.toggle_diagnostics, { desc = "toggle diagnostics" })
map("n", "<leader>uq", utils.toggle_quickfix, { desc = "toggle quickfix window" })
map("n", "<leader>ur", vim.cmd.mode, { desc = "clear and redraw screen" })
map("n", "<leader>uL", function() utils.option("list") end, { desc = "toggle list" })
map("n", "<leader>uH", [[<Cmd>TSBufToggle highlight<CR>]], { desc = "toggle highlight"})

map("n", "dd", function()
    return vim.api.nvim_get_current_line():match("^%s*$") and '"_dd' or "dd"
end, { expr = true, desc = "smart dd" })
