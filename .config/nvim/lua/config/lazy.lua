-- Add binaries installed by mason to path.
vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.stdpath("data") .. "/mason/bin"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.print("Bootstrapping lazy.nvim ..")
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
    spec = { { import = "plugins" } },
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
                "2html_plugin",
                "getscript",
                "getscriptPlugin",
                "gzip",
                "logiPat",
                "matchit",
                "matchparen",
                -- TODO: i need to learn more about netrw
                -- "netrw",
                -- "netrwFileHandlers",
                -- "netrwPlugin",
                -- "netrwSettings",
                "rplugin",
                "rrhelper",
                "tar",
                "tarPlugin",
                "tohtml",
                "tutor",
                "vimball",
                "vimballPlugin",
                "zip",
                "zipPlugin",
            },
        },
    },
    ui = {
        border = "rounded",
        icons = {
            task = "✓",
        },
        custom_keys = {
            -- plugin spec
            ["<localleader>s"] = function(plugin)
                local spec = vim.inspect(plugin)
                require("lazy.util").float_cmd({ "echo", spec }, { ft = "lua" })
            end,
        },
    },
})
