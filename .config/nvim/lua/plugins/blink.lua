return {
    -- Performant, batteries-included completion plugin for Neovim
    "saghen/blink.cmp",
    version = "*",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = { "rafamadriz/friendly-snippets" },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        completion = {
            list = {
                selection = { auto_insert = false },
            },
            menu = {
                border = "rounded",
                draw = {
                    columns = {
                        { "label" },
                        { "kind_icon", "kind", gap = 0 },
                        { "source_name" },
                    },
                    components = {
                        kind_icon = {
                            ellipsis = false,
                            text = function(ctx)
                                -- local icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                                -- return icon
                                return require("utils.icons").kinds[ctx.kind]
                            end,
                            highlight = function(ctx)
                                local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                                return hl
                            end,
                        },
                        label = {
                            width = { fill = false, max = 30 },
                            text = function(ctx) return ctx.label end,
                        },
                        source_name = {
                            text = function(ctx)
                                local sources = {
                                    buffer = "[BUF]",
                                    cmdline = "[CMD]",
                                    dap = "[DAP]",
                                    snippets = "[SNIP]",
                                    lsp = "[LSP]",
                                    lazydev = "[LAZY]",
                                    path = "[PATH]",
                                    dadbod = "[DB]",
                                }
                                return sources[ctx.source_name:lower()] .. ctx.label_detail
                            end,
                        },
                    },
                    treesitter = { "lsp" },
                },
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 200,
                window = { border = "rounded" },
            },

            -- Display a preview of the selected item on the current line
            ghost_text = { enabled = true },
        },
        cmdline = {
            completion = { menu = { auto_show = true } },
        },
        keymap = {
            preset = "default",
            ["<C-n>"] = { "select_next", "show", "fallback" },
            ["<C-p>"] = { "select_prev", "fallback" },
            ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
            ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
            -- Show entries only form `snippets` provider
            ["<M-n>"] = { function(cmp) cmp.show({ providers = { "snippets" } }) end },
            -- Show entries only form `lsp` provider
            ["<M-l>"] = { function(cmp) cmp.show({ providers = { "lsp" } }) end },
            -- Toggle documentation
            ["<M-o>"] = {
                function(cmp)
                    if not cmp.show_documentation() then
                        cmp.hide_documentation()
                    end
                end,
            },
        },
        -- Using Noice for now
        -- signature = {
        --     enabled = true,
        --     { window = { border = 'single' }
        -- },
        sources = {
            default = function()
                local success, node = pcall(vim.treesitter.get_node)
                if
                    success
                    and node
                    and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type())
                then
                    return { "buffer", "snippets" }
                else
                    return { "lazydev", "lsp", "path", "snippets", "buffer" }
                end
            end,
            per_filetype = { sql = { "dadbod" } },
            providers = {
                lsp = {
                    async = true,
                    fallbacks = {}, -- Do not fallback to `buffer` provider
                },
                buffer = {
                    min_keyword_length = 3,
                    opts = {
                        -- Show buffer completions from all valid buffer
                        get_bufnrs = function()
                            return vim.iter(vim.api.nvim_list_bufs()):filter(vim.api.nvim_buf_is_valid):totable()
                        end,
                    },
                },
                lazydev = {
                    name = "LazyDev",
                    module = "lazydev.integrations.blink",
                    score_offset = 100, -- show at a higher priority than lsp
                },
                dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
            },
        },
        snippets = { preset = "luasnip" },
        term = {
            enabled = true,
            sources = { "buffer", "path" },
        },
    },
}
