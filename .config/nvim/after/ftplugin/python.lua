-- just trying to use ftplugin
local bo = vim.bo
bo.makeprg = "python %"

bo.expandtab = true
bo.shiftwidth = 4
bo.tabstop = 4

-- set virtual environment for other plugins to use
vim.defer_fn(function()
    local venv = vim.loop.cwd() .. "/.venv"
    if not vim.loop.fs_stat(venv) then return end
    vim.env.VIRTUAL_ENV = venv
    if not vim.env.VIRTUAL_ENV then return end
    vim.g.python3_host_prog = vim.env.VIRTUAL_ENV .. "/bin/python"
end, 1)
