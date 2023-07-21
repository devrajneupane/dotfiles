return {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = {
        use_diagnostic_signs = true,
        auto_jump = { "loclist", "quickfix", "lsp_definitions", "lsp_references", "lsp_type_definitions" },
        auto_fold = true,
        padding = false,
    },
    keys = {
        { "<leader>xx", "<Cmd>TroubleToggle<CR>", desc = "toggle 🚦" },
        { "<leader>xd", "<Cmd>TroubleToggle document_diagnostics<cr><CR>", desc = "document diagnostics🚦" },
        { "<leader>xw", "<Cmd>TroubleToggle workspace_diagnostics<cr><CR>", desc = "workspace diagnostics🚦" },
        { "<leader>xl", "<Cmd>TroubleToggle loclist<CR>", desc = "location list🚦" },
        { "<leader>xq", "<Cmd>TroubleToggle quickfix<CR>", desc = "quickfix list🚦" },
        { "<leader>xr", "<cmd>TroubleToggle lsp_references<cr>", desc = "Lsp references (Trouble)" },
        {
            "[q",
            function()
                local trouble = require("trouble")
                if trouble.is_open() then
                    trouble.previous({ skip_groups = true, jump = true })
                else
                    vim.cmd.cprev()
                end
            end,
            desc = "prev trouble/quickfix item",
        },
        {
            "]q",
            function()
                local trouble = require("trouble")
                if trouble.is_open() then
                    trouble.next({ skip_groups = true, jump = true })
                else
                    vim.cmd.cnext()
                end
            end,
            desc = "next trouble/quickfix item",
        },
    },
}
