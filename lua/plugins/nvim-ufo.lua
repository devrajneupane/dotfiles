return {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "BufReadPost",
    config = function()
        vim.o.foldlevel = 99
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true
        -- enable folding capabilities
        require("plugins.lsp.util").capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
        }
        local handler = function(virtText, lnum, endLnum, width, truncate)
            local newVirtText = {}
            local suffix = (" 󰁂 %d "):format(endLnum - lnum)
            local sufWidth = vim.fn.strdisplaywidth(suffix)
            local targetWidth = width - sufWidth
            local curWidth = 0
            for _, chunk in ipairs(virtText) do
                local chunkText = chunk[1]
                local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                if targetWidth > curWidth + chunkWidth then
                    table.insert(newVirtText, chunk)
                else
                    chunkText = truncate(chunkText, targetWidth - curWidth)
                    local hlGroup = chunk[2]
                    table.insert(newVirtText, { chunkText, hlGroup })
                    chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    -- str width returned from truncate() may less than 2nd argument, need padding
                    if curWidth + chunkWidth < targetWidth then
                        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
                    end
                    break
                end
                curWidth = curWidth + chunkWidth
            end
            table.insert(newVirtText, { suffix, "MoreMsg" })
            return newVirtText
        end

        require("ufo").setup({
            -- Use treesitter as fold provider (much faster than lsp on startup)
            provider_selector = function() return { "treesitter", "indent" } end,
            close_fold_kinds = { "imports", "comment", "" },
            fold_virt_text_handler = handler,
            enable_get_fold_virt_text = true, -- idk what it does
            enableFoldEndVirtText = true, -- idk what it does too
            open_fold_hl_timeout = 50,
            preview = {
                win_config = {
                    winblend = 2
                },
                mappings = {
                    scrollB = "<C-b>",
                    scrollF = "<C-f>",
                    scrollU = "<C-u>",
                    scrollD = "<C-d>",
                    switch = "K",
                    jumpTop = '[',
                    jumpBot = ']'
                }
            }
        })
    end,
    keys = {
        { "zR", function() require("ufo").openAllFolds() end, desc = "open all folds" },
        { "zM", function() require("ufo").closeAllFolds() end, desc = "close all folds" },
        -- { "zr", function() require("ufo").openFoldsExceptKinds() end, desc = "open folds except kinds" },
        { 'zm', function() require('ufo').closeFoldsWith() end, desc = "close folds" },
        { 'zI', function() require('ufo').inspect() end, desc = "ufo inspect" },
        { '[o', function() require('ufo').goPreviousStartFold() end, desc = "start fold" },
        { '[O', function() require('ufo').goPreviousClosedFold() end, desc = "close fold" },
        { ']O', function() require('ufo').goNextClosedFold() end, desc = "close fold" },
        {
            "K",
            function()
                if not require("ufo").peekFoldedLinesUnderCursor() then
                    vim.lsp.buf.hover() end end,
            desc = "lsp hover/preview fold",
        },
    },
}
