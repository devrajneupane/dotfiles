local utils = require('utils')
local augroup = utils.augroup

-- Jump to the last cursor position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
    desc = "go to last cursor position when reopening a file",
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Briefly highlight yanked text",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 100, on_visual = true })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = augroup("GetRelief"),
    pattern = {"help", "man"},
    callback = function()
        vim.api.nvim_buf_set_keymap(0, "n", "d", "<C-d>", { nowait = true,  })
        vim.api.nvim_buf_set_keymap(0, "n", "u", "<C-u>", { nowait = true,  })
    end,
    desc = "scroll inside help without hurting pinky",
})

vim.api.nvim_create_autocmd("BufWinEnter", {
    group = augroup("close_with_q"),
    callback = function(event)
        local filetypes = {
            "",
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
        local filetype = vim.api.nvim_get_option_value("filetype", { buf = event.buf })
        local buftype = vim.api.nvim_get_option_value("buftype", { buf = event.buf })
        if buftype == "nofile" or vim.tbl_contains(filetypes, filetype) then
            utils.map("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true, nowait = true })
        end
    end,
    desc = "Close window with q",
})

vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup("auto_mkdir"),
    desc = "Auto create parent directories on save",
    callback = function(event)
        local path = vim.fs.dirname(vim.api.nvim_buf_get_name(event.buf))
        if vim.fn.isdirectory(path) == 0 then
            vim.fn.mkdir(path, "p")
        end
    end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup("auto_cd"),
    desc = "auto create parent directories on save",
    callback = function(event)
        local path = vim.fs.dirname(vim.api.nvim_buf_get_name(event.buf))
        if vim.fn.isdirectory(path) == 0 then
            vim.fn.mkdir(path, "p")
        end
    end,
})

vim.api.nvim_exec(
    [[
    augroup nvim_opts
    autocmd!
    autocmd TermOpen * setlocal nonumber norelativenumber signcolumn=no
    augroup end
    ]],
    false
)

-- Remove white space on save
vim.cmd([[autocmd BufWritePre * :%s/\s\+$//e]])

-- Auto save files when focus is lost
vim.cmd([[autocmd FocusLost * silent! wa]])

-- Change spell checking hl.
vim.api.nvim_set_hl(0, "SpellBad", { fg = "#FF0000", underline=true })

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
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
        vim.opt_local.spelllang = "en"
    end,
})


vim.api.nvim_create_user_command('Hashbang', function()
    local shells = {
        sh = { "#! /usr/bin/env bash" },
        py = { "#! /usr/bin/env python3" },
    }
    -- INFO: there could be better way to get extension of current file
    local ext = vim.fn.expand('%:e')
    ext = ext ~= '' and ext or vim.bo.filetype

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
