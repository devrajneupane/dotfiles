local utils = require("utils")
local augroup = utils.augroup

-- Jump to the last cursor position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
    desc = "go to last loc when opening a file",
    callback = function(event)
        local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
        local lcount = vim.api.nvim_buf_line_count(event.buf)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "briefly highlight yanked text",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 100, on_visual = true })
    end,
})

--[[ vim.api.nvim_create_autocmd("BufReadCmd", {
    ---@source: https://vim.fandom.com/wiki/Use_gf_to_open_a_file_via_its_URL
    pattern = { 'file:///*' },
    nested = true,
    command = function(event)
        vim.cmd.bdelete({bang = true})
        vim.cmd.edit(vim.uri_to_fname(event.file))
    end
}) ]]

vim.api.nvim_create_autocmd("FileType", {
    group = augroup("GetRelief"),
    pattern = { "help", "man", "noice" },
    callback = function()
        vim.api.nvim_buf_set_keymap(0, "n", "d", "<C-d>", { nowait = true })
        vim.api.nvim_buf_set_keymap(0, "n", "u", "<C-u>", { nowait = true })
        vim.api.nvim_buf_set_keymap(0, "n", "<CR>", "<C-]>", { nowait = true })
        vim.api.nvim_buf_set_keymap(0, "n", "<BS>", "<C-T>", { nowait = true })
    end,
    desc = "navigate help without hurting pinky",
})

vim.api.nvim_create_autocmd("BufWinEnter", {
    group = augroup("close_with_q"),
    callback = function(event)
        local filetypes = {
            "checkhealth",
            "diff",
            "help",
            "lspinfo",
            "man",
            "neotest-output",
            "neotest-output-panel",
            "neotest-summary",
            "netrw",
            "notify",
            "PlenaryTestPopup",
            "qf",
            "query",
            "startuptime",
            "toggleterm",
            "tsplayground",
        }
        local buffers = { "nofile", "help" }
        local filetype = vim.api.nvim_get_option_value("filetype", { buf = event.buf })
        local buftype = vim.api.nvim_get_option_value("buftype", { buf = event.buf })
        if vim.tbl_contains(buffers, buftype) or vim.tbl_contains(filetypes, filetype) then
            utils.map("n", "q", "<cmd>quit<cr>", { buffer = event.buf, nowait = true })
        end
    end,
    desc = "close window with q",
})

vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup("auto_mkdir"),
    desc = "auto create parent directories on save",
    callback = function(event)
        local path = vim.fs.dirname(event.file)
        if vim.fn.isdirectory(path) == 0 then
            vim.fn.mkdir(path, "p")
        end
    end,
})

vim.api.nvim_create_autocmd("TermOpen", {
    group = augroup("term_opts"),
    desc = "disable linenumber and signcolumn for terminal",
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
    end,
})

-- Remove trailing white space on save
vim.cmd([[autocmd BufWritePre * :%s/\s\+$//e]])

-- Auto save files when focus is lost
vim.cmd([[autocmd FocusLost * silent! wa]])

-- Change spell checking hl.
vim.api.nvim_set_hl(0, "SpellBad", { underline = true })

-- disable cursorline on foucs lost
vim.cmd([[
    augroup CursorLine
        au!
        au VimEnter * setlocal cursorlineopt=both
        au WinEnter * setlocal cursorlineopt=both
        au BufWinEnter * setlocal cursorlineopt=both
        au WinLeave * setlocal cursorlineopt=number
        " Auto-cd to the first argv if it's a directory.
        au VimEnter * if isdirectory(argv(0)) | exe 'cd ' . argv(0) | endif
    augroup END
]])

-- Get vim tip
vim.api.nvim_create_user_command(
    "Vtip",
    "echomsg system('curl -s -m 3 https://vtip.43z.one')",
    { desc = "get a vim tip" }
)

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "text", "gitcommit", "markdown", "tex" },
    callback = function(event)
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
        local buftype = vim.api.nvim_get_option_value("buftype", { buf = event.buf })
        if vim.tbl_contains({ "nofile", "help" }, buftype) then
            vim.opt_local.spell = false
        end
    end,
})

vim.api.nvim_create_user_command("Hashbang", function()
    local shells = {
        sh = { "#! /usr/bin/env bash" },
        py = { "#! /usr/bin/env python3" },
    }
    -- NOTE: there could be better way to get extension of current file
    local ext = vim.fn.expand("%:e")
    ext = ext ~= "" and ext or vim.bo.filetype

    if shells[ext] then
        local hb = shells[ext]
        hb[#hb + 1] = ""

        vim.api.nvim_buf_set_lines(0, 0, 0, false, hb)
        vim.api.nvim_create_autocmd("BufWritePost", {
            command = "silent !chmod u+x %",
            buffer = 0,
            once = true,
        })
    end
end, { force = true, desc = "add hashbang to current buffer" })

-- Automatically load diagnostics into location list
-- vim.api.nvim_create_autocmd({ 'DiagnosticChanged' }, {
--   group = vim.api.nvim_create_augroup('diagnostics', { clear = true }),
--   callback = function()
--     vim.diagnostic.setloclist({ open = false })
--   end,
-- })

-- :h DiffOrig
vim.api.nvim_create_user_command("DiffOrig", function()
    local start = vim.api.nvim_get_current_buf()
    vim.cmd("vnew | set buftype=nofile | read ++edit # | 0d_ | diffthis")
    local scratch = vim.api.nvim_get_current_buf()
    vim.cmd("wincmd p | diffthis")

    -- Map `q` for both buffers to exit diff view and delete scratch buffer
    for _, buf in ipairs({ scratch, start }) do
        vim.keymap.set("n", "q", function()
            vim.api.nvim_buf_delete(scratch, { force = true })
            vim.keymap.del("n", "q", { buffer = start })
        end, { buffer = buf })
    end
end, { desc = "diff original file" })

local tab_group = vim.api.nvim_create_augroup("tabs_keybind", { clear = true })
vim.api.nvim_create_autocmd("TabNew", {
    group = tab_group,
    callback = function()
        local tabpages = vim.api.nvim_list_tabpages()
        local count = #tabpages
        vim.keymap.set("n", "<leader>1", "<Cmd>normal 1gt<CR>", { desc = "go to tab 1" })
        vim.keymap.set(
            "n",
            "<leader>" .. count,
            string.format("<Cmd>normal %sgt<CR>", count),
            { desc = "go to tab " .. count }
        )
    end,
    desc = "add keybind to navigate between tabs",
})
vim.api.nvim_create_autocmd("TabClosed", {
    group = tab_group,
    callback = function()
        local tabpages = vim.api.nvim_list_tabpages()
        local count = #tabpages + 1
        vim.keymap.del("n", "<leader>" .. count)
        if count == 2 then
            -- also delete last keybind for tab navigation
            vim.keymap.del("n", "<leader>1")
        end
    end,
    desc = "remove keybind for tabpages",
})
