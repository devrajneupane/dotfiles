return {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    version = "v2.*",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
        history = true,
        enable_autosnippets = true,
        region_check_events = { "CursorMoved", "CursorHold", "InsertEnter" },
        delete_check_events = { "TextChanged", "TextChangedI" }, -- InsertLeave
        update_events = { "Texchanged", "TextChangedI " },
        -- use treesitter for getting the current filetype
        ft_func = function()
            return require('luasnip.extras.filetype_functions').from_cursor_pos() or vim.split(vim.bo.filetype, ".", true)
        end,
    },
    config = function()
        local ls = require("luasnip")
        local types = require("luasnip.util.types")
        local extras = require("luasnip.extras")
        local fmt = require("luasnip.extras.fmt").fmt

        ls.config.setup({
            ext_opts = {
                [types.choiceNode] = {
                    active = {
                        hl_mode = "combine",
                        virt_text = { { "●", "Operator" } }, -- BufferVisibleINFO
                    },
                },
                [types.insertNode] = {
                    active = {
                        hl_mode = "combine",
                        virt_text = { { "●", "Type" } }, -- BufferVisibleHINT
                    },
                },
            },
            snip_env = {
                fmt = fmt,
                m = extras.match,
                t = ls.text_node,
                f = ls.function_node,
                c = ls.choice_node,
                d = ls.dynamic_node,
                i = ls.insert_node,
                l = extras.lambda,
                snippet = ls.snippet,
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

        require("luasnip.loaders.from_lua").lazy_load()
        require("luasnip.loaders.from_vscode").lazy_load()

        -- telescope integration
        require("telescope").load_extension("luasnip")

        -- disable node highlight
        vim.api.nvim_create_autocmd("InsertLeave", {
            callback = function()
                if
                    require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
                    and not require("luasnip").session.jump_active
                then
                    require("luasnip").unlink_current()
                end
            end,
        })
    end,
    keys = {
        {
            "<C-j>",
            function()
                if require("luasnip").jumpable(-1) then
                    require("luasnip").jump(-1)
                else
                    -- sometimes i forget my keyboard has Enter key
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-j>", true, true, true), "n")
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
                else
                    -- i don't want to loose digraphs
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-k>", true, true, true), "n")
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
