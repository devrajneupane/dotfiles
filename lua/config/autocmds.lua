-- go to last cursor position when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 50,
            on_visual = true
        })
    end
})

vim.api.nvim_exec(
    [[
    augroup nvim_opts
    autocmd!
    autocmd TermOpen * setlocal nonumber norelativenumber signcolumn=no
    " Auto-create parent directories. excluding URIs
    autocmd BufWritePre,FileWritePre * if @% !~# '\(://\)' | call mkdir(expand('<afile>:p:h'), 'p') | endif
    augroup end
    ]],
    false
)

-- Jump to the last cursor position when reopening a file
vim.cmd([[
    if has("autocmd")
        autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
    endif
]])

-- Remove whitespace on save
-- vim.api.nvim_command([[autocmd BufWritePre * lua vim.fn.system(':%s/\\s\\+$//e')]])
vim.cmd([[autocmd BufWritePre * :%s/\s\+$//e]])

-- Auto save files when focus is lost
vim.cmd([[autocmd FocusLost * silent! wa]])

-- Don't auto commenting new lines
vim.cmd([[autocmd BufEnter * set fo-=c fo-=r fo-=o]])

-- Change spell checking hl.
vim.cmd("hi SpellBad gui=underline")

-- Disable the cursorline when a window is not focused.
-- Keep the number highlight.
vim.cmd([[
    augroup CursorLine
        au!
        au VimEnter * setlocal cursorlineopt=both
        au WinEnter * setlocal cursorlineopt=both
        au BufWinEnter * setlocal cursorlineopt=both
        au WinLeave * setlocal cursorlineopt=number
    augroup END
]])

-- Save read-only files
vim.cmd("command! -nargs=1 Sudow w !sudo tee % >/dev/null")

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "text", "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
		vim.opt_local.spelllang = "en"
	end,
})
