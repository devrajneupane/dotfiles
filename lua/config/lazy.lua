local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    print("Bootstrapping lazy.nvim ..")
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)

-- load lazy
require("lazy").setup({
    spec = {
        { import = "plugins" },
        { import = "plugins.lsp.inlayhints" },
    },
    install = { colorscheme = { "tokyonight-moon", "habamax" } },
    defaults = { lazy = true },
    concurrency = 10,
    diff = { cmd = "terminal_git" }, -- diffview.nvim
    checker = {
        enabled = true,
        notify = false,
        frequency = 259200, -- check for updates every 3 day
    },
    change_detection = { notify = false },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
    ui = {
        border = "rounded",
        custom_keys = {
            -- plugin spec
            ["<localleader>s"] = function(plugin)
                local spec = vim.inspect(plugin)
                require("lazy.util").float_cmd({ "echo", spec }, { ft = "lua" })
            end,
        },
    },
})
