return {
    "lewis6991/gitsigns.nvim",
    ft = { "gitcommit", "diff" },
    init = function()
        -- load gitsigns only when a git file is opened
        vim.api.nvim_create_autocmd({ "BufRead" }, {
            group = vim.api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
            callback = function()
                vim.fn.system("git -C " .. '"' .. vim.fn.expand("%:p:h") .. '"' .. " rev-parse")
                if vim.v.shell_error == 0 then
                    vim.api.nvim_del_augroup_by_name("GitSignsLazyLoad")
                    vim.schedule(function()
                        require("lazy").load({ plugins = { "gitsigns.nvim" } })
                    end)
                end
            end,
        })
    end,
    opts = {
        signs = {
            delete = { text = "-" },
            untracked = { text = "" }, -- ┆
        },
        current_line_blame = true,
        attach_to_untracked = false,
        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
            delay = 1500,
            ignore_whitespace = false,
        },
        preview_config = {
            border = "rounded",
            style = "minimal",
            relative = "cursor",
            row = 0,
            col = 1,
        },
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns
            local map = require("utils").map
            local wk = require("which-key")
            wk.register({
                ["<leader>h"] = { name = "+hunks 󰄶 " },
                ["<leader>ht"] = { name = "+toggle  " },
            })

            map("n", "]c", function()
                if vim.wo.diff then
                    return "]c"
                end
                vim.schedule(function()
                    gs.next_hunk()
                end)
                return "<Ignore>"
            end, { expr = true, buffer = bufnr, desc = "Next hunk" })
            map("n", "[c", function()
                if vim.wo.diff then
                    return "[c"
                end
                vim.schedule(function()
                    gs.prev_hunk()
                end)
                return "<Ignore>"
            end, { expr = true, buffer = bufnr, desc = "Prev hunk" })

            -- Actions
            map({ "n", "v" }, "<leader>hs", "<Cmd>Gitsigns stage_hunk<CR>", { buffer = bufnr, desc = "Stage hunk" })
            map({ "n", "v" }, "<leader>hr", "<Cmd>Gitsigns reset_hunk<CR>", { buffer = bufnr, desc = "Reset hunk" })
            map("n", "<leader>hu", gs.undo_stage_hunk, { buffer = bufnr, desc = "Undo stage hunk" })
            map("n", "<leader>hp", gs.preview_hunk, { buffer = bufnr, desc = "Preview hunk" })

            map("n", "<leader>hS", gs.stage_buffer, { buffer = bufnr, desc = "Stage buffer" })
            map("n", "<leader>hR", gs.reset_buffer, { buffer = bufnr, desc = "Reset buffer" })

            map("n", "<leader>hB", function() gs.blame_line({ full = true }) end, { buffer = bufnr, desc = "Blame line" })
            map("n", "<leader>hb", gs.toggle_current_line_blame, { buffer = bufnr, desc = "Toggle line blame" })

            map("n", "<leader>hd", gs.diffthis, { buffer = bufnr, desc = "Diff against index" })
            map("n", "<leader>hD", function() gs.diffthis("~") end, { buffer = bufnr, desc = "Diff against last commit" })

            map("n", "<leader>hl", gs.setloclist, { buffer = bufnr, desc = "Send hunks to loclist" })
            map("n", "<leader>hq", gs.setqflist, { buffer = bufnr, desc = "Send hunks to qflist" })

            map("n", "<leader>htd", gs.toggle_deleted, { buffer = bufnr, desc = "toggle deleted" })
            map("n", "<leader>hts", gs.toggle_signs, { buffer = bufnr, desc = "toggle signs" })
            map("n", "<leader>htn", gs.toggle_numhl, { buffer = bufnr, desc = "toggle numhl" })
            map("n", "<leader>htl", gs.toggle_linehl, { buffer = bufnr, desc = "toggle linehl" })
            map("n", "<leader>htw", gs.toggle_word_diff, { buffer = bufnr, desc = "toggle word diff" })

            -- Text object
            map({ "o", "x" }, "ih", gs.select_hunk, { buffer = bufnr, desc = "Git Hunk" })
        end,
    },
}
