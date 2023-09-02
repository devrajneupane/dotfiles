-- explain shell command
vim.keymap.set({ "n", "x" }, "<localleader>E", function()
    local site = "https://explainshell.com/explain?cmd="
    local text = vim.api.nvim_get_current_line()
    if vim.fn.mode():find("[Vv]") then
        vim.cmd.normal({ '"zy', bang = true })
        text = vim.fn.getreg("z")
    end
    vim.fn.system({ "xdg-open", site .. text })
end, { desc = " explain shell", buffer = true })
