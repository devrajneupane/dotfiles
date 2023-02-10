---------------------------
-- Trouble (diagnostics) --
---------------------------

require 'trouble'.setup {
    padding = true,
    height = 11,
    use_diagnostic_signs = false,
    position = 'bottom',
    signs = {
        error = " ",
        warning = " ",
        hint = " ",
        information = " ",
        other = " "
    },
    auto_preview = false
}

-- Make trouble update to the current buffer.
vim.cmd [[ autocmd BufEnter * TroubleRefresh ]]

------------
-- Fidget --
------------

require"fidget" .setup {
    window = {
        relative = "editor"
    }
}
