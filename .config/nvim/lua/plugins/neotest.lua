return {
    -- An extensible framework for interacting with tests within NeoVim
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-treesitter/nvim-treesitter",
        -- Adpaters
        "nvim-neotest/neotest-python",
    },
    opts = {
        status = { signs = false, virtual_text = true },
        output = { open_on_run = true },
        icons = {
            failed = "✘",
            passed = "✔",
            running_animated = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
        },
        strategies = { integrated = { width = 180 } },
        discovery = {
            filter_dir = function(dir) return not vim.startswith(dir, "node_modules") end,
        },
        quickfix = {
            open = function()
                if require("lazy.core.config").plugins["trouble.nvim"] ~= nil then
                    vim.cmd("Trouble quickfix")
                else
                    vim.cmd("copen")
                end
            end,
        },
    },
    config = function(_, opts)
        opts = vim.tbl_deep_extend("force", {
            adapters = {
                require("rustaceanvim.neotest"),
                require("neotest-python")({
                    dap = { justMyCode = false, console = "integratedTerminal", subProcess = false },
                    pytest_discover_instances = true,
                }),
            },
        }, opts)
        require("neotest").setup(opts)
    end,
    -- stylua: ignore
    keys = {
        { "<leader>o", "", desc = "neotest" },
        { "<leader>oo", "", desc = "output" },
        { "[n", function() require("neotest").jump.prev() end, desc = "previous test" },
        { "]n", function() require("neotest").jump.next() end, desc = "next test" },
        { "[N", function() require("neotest").jump.prev({ status = "failed" }) end, desc = "previous failed test" },
        { "]N", function() require("neotest").jump.next({ status = "failed" }) end, desc = "next failed test" },
        { "<leader>oa", function() require("neotest").run.attach() end, desc = "attach to nearest test" },
        { "<leader>on", function() require("neotest").run.run() end, desc = "run nearest test" },
        { "<leader>ob", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "run tests in %" },
        { "<leader>oc", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "run tests in cwd" },
        { "<leader>od", function() require("neotest").run.run({vim.fn.expand("%"), strategy = "dap"}) end, desc = "debug curren file" },
        { "<leader>ol", function() require("neotest").run.run_last() end, desc = "run last test" },
        { "<leader>os", function() require("neotest").summary.toggle() end, desc = "toggle summary" },
        { "<leader>om", function() require("neotest").summary.run_marked() end, desc = "run all marked positions" },
        { "<leader>ooo", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "show output" },
        { "<leader>oop", function() require("neotest").output_panel.toggle() end, desc = "toggle output panel" },
        { "<leader>ooc", function() require("neotest").output_panel.clear() end, desc = "clear output panel" },
        { "<leader>ot", function() require("neotest").run.stop() end, desc = "stop nearest test" },
        { "<leader>ow", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "toggle watching in %" },
    },
}
