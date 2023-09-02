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

        -- experimental
        _inline2 = false,
        _extmark_signs = true,
        _signs_staged_enable = false,

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
            local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
            local next_hunk_repeat, prev_hunk_repeat = ts_repeat_move.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)

            require('which-key').register({
                ["<leader>h"] = { name = "+git hunk 󰄶 " },
                ["<leader>ht"] = { name = "+toggle  " },
            })

            map({ "n", "x", "o" }, "]h", next_hunk_repeat, { desc = "next hunk" })
            map({ "n", "x", "o" }, "[h", prev_hunk_repeat, { desc = "prev hunk" })

            -- Actions
            map({ "n", "v" }, "<leader>hs", "<Cmd>Gitsigns stage_hunk<CR>", { buffer = bufnr, desc = "stage hunk" })
            map({ "n", "v" }, "<leader>hr", "<Cmd>Gitsigns reset_hunk<CR>", { buffer = bufnr, desc = "reset hunk" })
            map("n", "<leader>hu", gs.undo_stage_hunk, { buffer = bufnr, desc = "undo stage hunk" })
            map("n", "<leader>hp", gs.preview_hunk, { buffer = bufnr, desc = "preview hunk" })

            map("n", "<leader>hS", gs.stage_buffer, { buffer = bufnr, desc = "stage buffer" })
            map("n", "<leader>hR", gs.reset_buffer, { buffer = bufnr, desc = "reset buffer" })

            map("n", "<leader>hB", function() gs.blame_line({ full = true }) end, { buffer = bufnr, desc = "blame line" })
            map("n", "<leader>hb", gs.toggle_current_line_blame, { buffer = bufnr, desc = "toggle line blame" })

            map("n", "<leader>hd", gs.diffthis, { buffer = bufnr, desc = "diff against index" })
            map("n", "<leader>hD", function() gs.diffthis("~") end, { buffer = bufnr, desc = "diff against last commit" })

            map("n", "<leader>hl", gs.setloclist, { buffer = bufnr, desc = "send hunks to loclist" })
            map("n", "<leader>hq", gs.setqflist, { buffer = bufnr, desc = "send hunks to qflist" })

            map("n", "<leader>htd", gs.toggle_deleted, { buffer = bufnr, desc = "toggle deleted" })
            map("n", "<leader>hts", gs.toggle_signs, { buffer = bufnr, desc = "toggle signs" })
            map("n", "<leader>htn", gs.toggle_numhl, { buffer = bufnr, desc = "toggle numhl" })
            map("n", "<leader>htl", gs.toggle_linehl, { buffer = bufnr, desc = "toggle linehl" })
            map("n", "<leader>htw", gs.toggle_word_diff, { buffer = bufnr, desc = "toggle word diff" })

            -- Text object
            map({ "o", "x" }, "ih", gs.select_hunk, { buffer = bufnr, desc = "git hunk" })
        end,
    },
}
