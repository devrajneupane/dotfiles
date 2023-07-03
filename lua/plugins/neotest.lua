return {
    { "nvim-neotest/neotest-python" },
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            adapters = {
                [ "neotest-python" ] = {
                    dap = { justMyCode = false, console = "integratedTerminal", subProcess = false },
                    pytest_discovery = true,
                },
            },
            status = { virtual_text = true },
            icons = { running_animated = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" } },
            strategies = { integrated = { width = 180 } },
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
        keys = {
            {"[n", function() require('neotest').jump.prev({ status = "failed" }) end, desc = "previous failed test"},
            {"]n", function() require('neotest').jump.next({ status = "failed" }) end, desc = "next failed test"},
            { "<leader>ta", function() require("neotest").run.attach() end, desc = "Attach to nearest test" },
            { "<leader>tr", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run current test file" },
            { "<leader>tR", function() require("neotest").run.run(vim.loop.cwd()) end, desc = "Run all test files" },
            { "<leader>tN", function() require("neotest").run.run() end, desc = "Run nearest test" },
            { "<leader>tT", function() require("neotest").summary.toggle() end, desc = "Toggle summary" },
            { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show output" },
            { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle output panel" },
            { "<leader>tP", function() require("neotest").run.stop() end, desc = "Stop nearest test" },
        },
    },
    {
        "mfussenegger/nvim-dap",
        optional = true,
        keys = {
            { "<leader>td", function() require("neotest").run.run({strategy = "dap"}) end, desc = "Debug nearest" },
        },
    },
}
