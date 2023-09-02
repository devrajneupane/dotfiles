-- TODO: make every keybind related to dap to only appear on which-key popup during active dap session
return {
    -- Debug Adapter Protocol client for Neovim
    "mfussenegger/nvim-dap",
    dependencies = {
        -- UI for nvim-dap
        {
            "rcarriga/nvim-dap-ui",
            opts = {
                force_buffers = false,
                element_mappings = {
                    scopes = {
                        edit = "l",
                    },
                },
                floating = { border = "rounded" },
                layouts = {
                    {
                        elements = {
                            "scopes",
                            "breakpoints",
                            "stacks",
                            "watches",
                        },
                        size = 40,
                        position = "left",
                    },
                    {
                        elements = { "repl", "console" },
                        size = 0.25,
                        position = "bottom",
                    },
                },
            },
            -- stylua: ignore
            config = function(_, opts)
                local dap = require("dap")
                local dapui = require("dapui")
                dapui.setup(opts)
                dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open({}) end
                dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close({}) end
                dap.listeners.before.event_exited["dapui_config"] = function() dapui.close({}) end
            end,
            -- stylua: ignore
            keys = {
                { "<leader>du", function() require("dapui").toggle({}) end, desc = "dap ui" },
                {"<leader>de", function() require("dapui").eval() end, desc = "evaluate expression", mode = {"n", "v"}},
                {"<leader>df", function() require("dapui").float_element() end, desc = "floating element window"},
            },
        },

        -- add virtual text support to nvim-dap
        {
            "theHamsta/nvim-dap-virtual-text",
            opts = {
                all_frames = true,
                virt_text_pos = "eol",
                all_refrences = true, -- test
                commmented = true -- test
            },
        },

        -- An extension for nvim-dap, providing default configurations for python
        {
            "mfussenegger/nvim-dap-python",
            config = function()
                local path = require("mason-registry").get_package("debugpy"):get_install_path()
                require("dap-python").setup(path .. "/venv/bin/python")
            end,
            keys = {
                {
                    "<leader>dap",
                    function() require("dap-python").test_method() end,
                    desc = "python test method",
                },
                {
                    "<leader>daf",
                    function() require("dap-python").test_class() end,
                    desc = "python test class",
                },
                {
                    "<leader>das",
                    function() require("dap-python").debug_selection() end,
                    desc = "python debug selection",
                },
            },
        },
    },
    -- stylua: ignore
    config = function()
        for name, sign in pairs(require("utils.icons").dap) do
            sign = type(sign) == "table" and sign or { sign }
            vim.fn.sign_define(
                "Dap" .. name,
                {
                    text = sign[1],
                    texthl = sign[2] or "DiagnosticInfo",
                    linehl = sign[3],
                    numhl = sign[3],
                }
            )
        end
        -- trigger character .
        vim.cmd [[
        augroup DapRepl
            au!
            au FileType dap-repl lua require('dap.ext.autocompl').attach()
        augroup END
        ]]

        vim.api.nvim_create_autocmd('FileType', {
            group = require('utils').augroup('dap-repl'),
            pattern = 'dap-repl',
            callback = function(args)
                require('dap.ext.autocompl').attach(args.buf)
            end,
            desc = 'dap repl completion',
        })
    end,
    -- stylua: ignore
    keys = {
        { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "toggle breakpoint" },
        { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "breakpoint condition" },
        { "<leader>dL", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end, desc = "log breakpoint" },
        { "<leader>dc", function() require("dap").continue() end, desc = "continue" },
        { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "run to cursor" },
        { "<leader>dg", function() require("dap").goto_() end, desc = "go to line (no execute)" },
        { "<leader>dj", function() require("dap").down() end, desc = "down" },
        { "<leader>dk", function() require("dap").up() end, desc = "up" },
        { "<leader>dl", function() require("dap").run_last() end, desc = "run last" },
        { "<leader>di", function() require("dap").step_into() end, desc = "step into" },
        { "<leader>do", function() require("dap").step_out() end, desc = "step out" },
        { "<leader>dO", function() require("dap").step_over() end, desc = "step over" },
        { "<leader>dp", function() require("dap").pause() end, desc = "pause" },
        { "<leader>dr", function() require("dap").repl.toggle() end, desc = "toggle repl" },
        { "<leader>ds", function() require("dap").session() end, desc = "session" },
        { "<leader>dt", function() require("dap").terminate() end, desc = "terminate" },
        { "<leader>dh", function() require("dap.ui.widgets").hover() end, desc = "widgets" },
        { "<Leader>dw", function() require('dap.ui.widgets').preview() end, desc = "widget preview"},
        { "<Leader>dx", function() require('dap').restart() end, desc = "restart"},
    },
}
