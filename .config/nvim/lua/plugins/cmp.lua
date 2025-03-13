-- TODO: keybind to expand/supress width of cmp menu
return {
    -- "hrsh7th/nvim-cmp",
    "iguanacucumber/magazine.nvim",
    name = "nvim-cmp",
    event = { "InsertEnter" },
    cmd = "CmpStatus",
    enabled = false,
    dependencies = {
        -- "hrsh7th/cmp-buffer",
        -- "hrsh7th/cmp-cmdline", -- NOTE: Cmdline popup doesn't seem to cooperate with noice
        -- "hrsh7th/cmp-nvim-lsp",
        { "iguanacucumber/mag-cmdline", name = "cmp-cmdline", event = "CmdlineEnter" },
        { "iguanacucumber/mag-nvim-lsp", name = "cmp-nvim-lsp", opts = {} },
        { "iguanacucumber/mag-buffer", name = "cmp-buffer" },
        { "https://codeberg.org/FelipeLema/cmp-async-path", name = "async_path" },
        -- "hrsh7th/cmp-path",
        "saadparwaiz1/cmp_luasnip",
    },
    opts = function()
        local cmp = require("cmp")
        local ls = require("luasnip")
        local compare = cmp.config.compare
        -- local copilot = require("copilot.suggestion")
        -- local defaults = require("cmp.config.default")()
        -- local winhighlight = 'Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None'

        -- from lukas-reineke/cmp-under-comparator
        ---@param entry1 cmp.Entry
        ---@param entry2 cmp.Entry
        ---@return boolean | nil
        ---@diagnostic disable-next-line: inject-field
        compare.underscore = function(entry1, entry2)
            local _, entry1_under = entry1.completion_item.label:find("^_+")
            local _, entry2_under = entry2.completion_item.label:find("^_+")
            entry1_under = entry1_under or 0
            entry2_under = entry2_under or 0
            if entry1_under > entry2_under then
                return false
            elseif entry1_under < entry2_under then
                return true
            end
        end
        -- local function deprioritize_snippet(entry1, entry2)
        --     if entry1:get_kind() == types.lsp.CompletionItemKind.Snippet then return false end
        --     if entry2:get_kind() == types.lsp.CompletionItemKind.Snippet then return true end
        -- end

        local has_words_before = function()
            local unpack = unpack or table.unpack
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        return {
            ---See https://www.reddit.com/r/neovim/comments/1f1rxtx/share_a_tip_to_improve_your_experience_in_nvimcmp/
            performance = {
                debounce = 0,
                throttle = 15,
                -- fetching_timeout = 300,
                -- confirm_resolve_timeout = 40,
                async_budget = 0.5,
                -- max_view_entries = 50,
            },
            completion = { completeopt = vim.o.completeopt },
            snippet = {
                expand = function(args) ls.lsp_expand(args.body) end,
            },
            formatting = {
                format = function(entry, vim_item)
                    local kinds = require("utils.icons").kinds
                    local max_width = { abbr = 25, menu = 40 }
                    local sources = {
                        buffer = "[BUF]",
                        cmdline = "[CMD]",
                        dap = "[DAP]",
                        luasnip = "[SNIP]",
                        nvim_lsp = "[LSP]",
                        -- path = "[PATH]",
                        async_path = "[PATH]",
                        -- ["vim-dadbod-completion"] = "[DB]",
                    }
                    local source = sources[entry.source.name]
                    if source then
                        vim_item.kind = (kinds[vim_item.kind] or "") .. vim_item.kind
                        vim_item.menu = source .. " " .. (vim_item.menu or "")
                    else
                        vim_item.menu = entry.source.name
                    end

                    -- truncate abbr and menu if they are longer than max width
                    for _, key in ipairs({ "abbr", "menu" }) do
                        local width, item = max_width[key], vim_item[key]
                        if vim.api.nvim_strwidth(item) > width then
                            vim_item[key] = vim.fn.strcharpart(item, 0, width) .. ""
                        end
                    end

                    return vim_item
                end,
            },
            sources = cmp.config.sources({
                {
                    name = "nvim_lsp",
                    max_item_count = 30,
                    -- hide all text entries from lsp :h cmp-config.sources[n].entry_filter
                    entry_filter = function(entry, _)
                        return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
                    end,
                },
                {
                    name = "luasnip",
                    -- Don't show snippet completions in comments or strings.
                    entry_filter = function()
                        local ctx = require("cmp.config.context")
                        local in_string = ctx.in_syntax_group("String") or ctx.in_treesitter_capture("string")
                        local in_comment = ctx.in_syntax_group("Comment") or ctx.in_treesitter_capture("comment")

                        return not in_string and not in_comment
                    end,
                },
            }, {
                -- { name = "path" },
                { name = "async_path" },
                {
                    name = "buffer",
                    -- keyword_length = 3,
                    -- max_item_count = 10,
                    option = {
                        show_source = true, -- shows in a popup window the file the file this completion is from
                        -- Buffer completion from all visible buffers
                        get_bufnrs = function()
                            return vim.iter(vim.api.nvim_list_wins())
                                :map(function(win) return vim.api.nvim_win_get_buf(win) end)
                                :filter(function(buf)
                                    local fname = vim.api.nvim_buf_get_name(buf)
                                    return vim.fn.getfsize(fname) < (1024 * 500) -- 500KB
                                end)
                                :totable()
                        end,
                    },
                },
            }),
            -- sorting = defaults.sorting,
            -- sorting = {
            --     comparators = {
            --         compare.offset,
            --         compare.exact,
            --         compare.score,
            --         compare.scopes,
            --         compare.recently_used,
            --         compare.underscore,
            --         compare.locality,
            --         compare.kind,
            --         compare.sort_text,
            --         compare.length,
            --         compare.order,
            --     },
            -- },
            window = {
                completion = cmp.config.window.bordered({
                    scrolloff = 3,
                    winhighlight = "FloatBorder:NoiceCmdlinePopupBorderCmdline,Search:None",
                    -- winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",

                    -- scrollbar = false,
                    -- col_offset = 5,
                    -- side_padding = 5,
                }),
                documentation = cmp.config.window.bordered({
                    border = "rounded",
                    winhighlight = "FloatBorder:NoiceCmdlinePopupBorderCmdline,Search:None",
                    scrolloff = 3,
                    max_height = math.floor(vim.o.lines * 0.5),
                    max_width = math.floor(vim.o.columns * 0.4),
                }),
            },
            experimental = {
                ghost_text = {
                    hl_group = "CmpGhostText",
                },
            },
            view = {
                entries = {
                    follow_cursor = true,
                },
                docs = {
                    auto_open = true,
                },
            },
            ---@see https://www.reddit.com/r/neovim/comments/1f1rxtx/share_a_tip_to_improve_your_experience_in_nvimcmp/
            --- for different keybind to different sources
            mapping = cmp.mapping.preset.insert({
                -- ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                -- ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<C-n>"] = {
                    i = function()
                        if cmp.visible() then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                        else
                            cmp.complete()
                        end
                    end,
                },
                ["<C-p>"] = {
                    i = function()
                        if cmp.visible() then
                            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                        else
                            cmp.complete()
                        end
                    end,
                },
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<M-space>"] = cmp.mapping.complete(),
                -- ["<C-e>"] = cmp.mapping.abort(),
                ["<C-e>"] = cmp.mapping({
                    i = cmp.mapping.abort(),
                    c = cmp.mapping.close(),
                }),
                -- ["<C-y>"] = cmp.mapping.confirm({
                --     select = true,
                --     behavior = cmp.ConfirmBehavior.Replace,
                -- }),
                ["<C-y>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.confirm({
                            select = true,
                            behavior = cmp.ConfirmBehavior.Replace,
                        })
                    elseif vim.fn.getreg('"') then
                        local key = vim.api.nvim_replace_termcodes('<C-r>"', true, true, true)
                        vim.api.nvim_feedkeys(key, "n", true)
                    else
                        fallback()
                    end
                end, { "i", "c", "s" }),
                ["<M-y>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.confirm({
                            behavior = cmp.ConfirmBehavior.Insert,
                            select = true,
                        })
                    else
                        fallback()
                    end
                end, { "i", "c" }),
                ["<CR>"] = function(fallback)
                    if cmp.visible() then
                        cmp.confirm()
                    else
                        fallback()
                    end
                end,
                ["<Tab>"] = cmp.mapping(function(fallback)
                    -- if copilot.is_visible() then
                    --     copilot.accept()
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif ls.expand_or_locally_jumpable() then
                        ls.expand_or_jump()
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif ls.jumpable(-1) then
                        ls.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<C-l>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        return cmp.complete_common_string()
                    end
                    fallback()
                end, { "i", "c" }),
                ["<C-o>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        if cmp.visible_docs() then
                            cmp.close_docs()
                        else
                            cmp.open_docs()
                        end
                    else
                        fallback()
                    end
                end, { "i", "c" }),
                -- only shows entries from `nvim_lsp`
                ["<M-l>"] = cmp.mapping.complete({
                    config = {
                        sources = { { name = "nvim_lsp" } },
                    },
                }),
                -- only shows entries from `path`
                ["<M-p>"] = cmp.mapping.complete({
                    config = {
                        sources = { { name = "async_path" } },
                    },
                }),
                -- only shows entries from `luasnip`
                ["<M-n>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.complete({
                            config = {
                                sources = { { name = "luasnip" } },
                            },
                        })
                    else
                        fallback()
                    end
                end),
            }),
        }
    end,
    config = function(_, opts)
        local cmp = require("cmp")
        cmp.setup(opts)
        cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = { { name = "buffer" } },
        })
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = "async_path" },
            }, {
                {
                    name = "cmdline",
                    option = {
                        ignore_cmds = { "edit", "saveas", "split", "vsplit", "write" }, -- commands to disable cmdline completions for
                    },
                },
            }, {
                { name = "buffer", keyword_length = 4 },
            }),
        })
        vim.keymap.set("s", "<BS>", "<C-o>s")
    end,
    keys = {
        { "<leader>cs", "<Cmd>CmpStatus<CR>", desc = "Cmp status" },
    },
}
