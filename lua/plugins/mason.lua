return {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    opts = {
        max_concurrent_installers = 10,
        PATH = "append",
        pip = {
            upgrade_pip = true,
        },
        ui = {
            width = 0.8,
            height = 0.8,
            border = "rounded",
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✘",
            },
        },
        ensure_installed = {
            "bash-language-server",
            "clang-format",
            "codelldb",
            "dockerfile-language-server",
            "eslint-lsp",
            "html-lsp",
            "json-lsp",
            "lua-language-server",
            "markdownlint",
            "prettier",
            "ruff-lsp",
            "shfmt",
            "stylua",
            "taplo",
        },
    },
    config = function(_, opts)
        require("mason").setup(opts)
        local mr = require("mason-registry")
        mr:on("package:install:success", function()
            vim.defer_fn(function()
                -- trigger FileType event to possibly load this newly installed LSP server
                require("lazy.core.handler.event").trigger({
                    event = "FileType",
                    buf = vim.api.nvim_get_current_buf(),
                })
            end, 100)
        end)
        local function ensure_installed()
            for _, tool in ipairs(opts.ensure_installed) do
                local package = mr.get_package(tool)
                if not package:is_installed() then
                    package:install()
                end
            end
        end
        if mr.refresh then
            mr.refresh(ensure_installed)
        else
            ensure_installed()
        end
    end,
    keys = {
        { "<leader>M", "<Cmd>Mason<CR>", desc = "Mason" },
    },
}
