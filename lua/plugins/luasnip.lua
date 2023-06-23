return {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    dependencies = {
        { "benfowler/telescope-luasnip.nvim" },
        {
            "rafamadriz/friendly-snippets",
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
            end,
        },
    },
    opts = {
        history = false,
        enable_autosnippets = true,
        region_check_events = { "CursorMoved", "CursorMovedI" },
        delete_check_events = { "TextChanged", "TextChangedI" },
        update_events = { "Texchanged", "TextChangedI " },
    },
    config = function()
        local ls = require("luasnip")
        local types = require("luasnip.util.types")

        ls.config.setup({
            ext_opts = {
                [types.choiceNode] = {
                    active = {
                        virt_text = { { "●", "TroubleHint" } },
                    },
                },
                [types.insertNode] = {
                    active = {
                        virt_text = { { "●", "TroubleInformation" } },
                    },
                },
            },
        })

        -- standerized comment snippet
        ls.filetype_extend("typescript", { "tsdoc" })
        ls.filetype_extend("javascript", { "jsdoc" })
        ls.filetype_extend("lua", { "luadoc" })
        ls.filetype_extend("python", { "pydoc" })
        ls.filetype_extend("rust", { "rustdoc" })
        ls.filetype_extend("c", { "cdoc" })
        ls.filetype_extend("cpp", { "cppdoc" })
        ls.filetype_extend("ruby", { "rdoc", "rails" })
        ls.filetype_extend("sh", { "bash", "shelldoc" })

        -- telescope integration
        require("telescope").load_extension("luasnip")
    end,
    keys = {
        {
            "<C-j>",
            function()
                if require("luasnip").jumpable(-1) then
                    require("luasnip").jump(-1)
                end
            end,
            mode = { "i", "s" },
            desc = "previous snippet item",
        },
        {
            "<C-k>",
            function()
                if require("luasnip").expand_or_jumpable() then
                    require("luasnip").expand_or_jump()
                end
            end,
            mode = { "i", "s" },
            desc = "expand current item or jump to next",
        },
        {
            "<C-l>",
            function()
                if require("luasnip").choice_active() then
                    require("luasnip").change_choice(1)
                end
            end,
            mode = { "i", "s" },
            desc = "select within a list of options",
        },
    },
}
