-- NOTE: Gelio/cmp-natdat might be useful
-- TODO: can i map keybind to lower and increase the score of each entry ??
-- TODO: may be i want only help tags completion when the prompt starts with :h
return {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    cmd = "CmpStatus",
    dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-cmdline", -- NOTE: Cmdline popup doesn't seem to cooperate with noice
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lua",
        "saadparwaiz1/cmp_luasnip",
    },
    opts = function()
        local cmp = require("cmp")
        local ls = require("luasnip")
        local neogen = require("neogen")
        local compare = cmp.config.compare
        -- local winhighlight = 'Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None'

        -- from lukas-reineke/cmp-under-comparator
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

        local has_words_before = function()
            local unpack = unpack or table.unpack
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        return {
            enabled = function()
                local context = require("cmp.config.context")
                if vim.api.nvim_get_mode().mode == "c" then
                    return true
                else
                    -- disable completion in comments
                    return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
                end
            end,
            snippet = {
                expand = function(args)
                    ls.lsp_expand(args.body)
                end,
            },
            formatting = {
                format = function(entry, vim_item)
                    local kinds = require("utils.icons").kinds
                    local max_width = { abbr = 25, menu = 30 }
                    local menu = {
                        buffer = "[BUF]",
                        cmdline = "[CMD]",
                        dap = "[DAP]",
                        luasnip = "[SNIP]",
                        nvim_lsp = "[LSP]",
                        nvim_lua = "[API]",
                        path = "[PATH]",
                        ["vim-dadbod-completion"] = "[DB]",
                    }
                    vim_item.kind = (kinds[vim_item.kind] or "") .. vim_item.kind
                    vim_item.menu = (menu[entry.source.name] == nil and "" or menu[entry.source.name])
                        .. " "
                        .. (vim_item.menu == nil and "" or vim_item.menu)

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
                    -- hide all text entries from lsp
                    entry_filter = function(entry, ctx) -- :h cmp-config.sources[n].entry_filter
                        return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
                    end,
                },
                { name = "luasnip" },
                { name = "copilot" },
            }, {
                {
                    name = "buffer",
                    keyword_length = 4,
                    options = {
                        get_bufnrs = function()
                            return vim.api.nvim_list_bufs()
                        end,
                    },
                },
                { name = "nvim_lua" },
                { name = "path" },
            }),
            sorting = {
                comparators = {
                    compare.offset,
                    compare.exact,
                    compare.score,
                    compare.recently_used,
                    compare.underscore,
                    compare.kind,
                    compare.sort_text,
                    compare.length,
                    compare.order,
                    compare.locality,
                    function(...) return require('cmp_buffer'):compare_locality(...) end, -- test
                },
            },
            window = {
                completion = cmp.config.window.bordered({
                    scrolloff = 3,
                    winhighlight = "FloatBorder:NoiceCmdlinePopupBorderCmdline,Search:None",
                    -- scrollbar = false,
                    -- col_offset = 5,
                    -- side_padding = 5,
                }),
                documentation = {
                    border = "rounded",
                    winhighlight = "FloatBorder:NoiceCmdlinePopupBorderCmdline,Search:None",
                    scrolloff = 3,
                    max_height = math.floor(vim.o.lines * 0.5),
                    max_width = math.floor(vim.o.columns * 0.4),
                },
            },
            experimental = {
                ghost_text = {
                    hl_group = "CmpGhostText",
                },
            },
            view = {
                -- entries = "native",
                docs = {
                    auto_open = true,
                },
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<M-space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<C-y>"] = cmp.mapping(
                    cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = true,
                    }),
                    { "i", "c" }
                ),
                ["<M-y>"] = cmp.mapping( -- test mapping
                    cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = false,
                    }),
                    { "i", "c" }
                ),
                ["<c-q>"] = cmp.mapping.confirm({ -- test mapping
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = false,
                }),
                -- ["<CR>"] = cmp.mapping.confirm({ select = true }),
                -- if <CR> behaves different then its because you messed here
                ["<CR>"] = cmp.mapping({
                    i = function(fallback)
                        if cmp.visible() and cmp.get_active_entry() then
                            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                        else
                            fallback()
                        end
                    end,
                    s = cmp.mapping.confirm({ select = true }),
                    c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
                }),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif ls.expand_or_locally_jumpable() then
                        ls.expand_or_jump()
                    elseif neogen.jumpable() then
                        neogen.jump_next()
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
                    elseif neogen.jumpable(true) then
                        neogen.jump_prev()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<C-l>"] = cmp.mapping(function(fallback) -- test mapping
                    if cmp.visible() then
                        cmp.complete_common_string()
                    else
                        fallback()
                    end
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
            enabled = function()
                -- Set of commands where cmp will be disabled
                local disabled = {
                    IncRename = true, -- this works
                    -- Telescope = true, -- but this doesn't ?? or maybe this is not the way for telescope
                }
                -- Get first word of cmdline
                local cmd = vim.fn.getcmdline():match("%S+")
                -- Return true if cmd isn't disabled
                -- else call/return cmp.close(), which returns false
                return not disabled[cmd] or cmp.close()
            end,
            sources = cmp.config.sources({
                {
                    name = "cmdline",
                    option = {
                        ignore_cmds = {}, -- include Man and ! completions
                    },
                },
                { name = "path" },
            }, {
                { name = "nvim_lua" },
                { name = "buffer" },
            }),
        })
    end,
    keys = {
        { "<leader>cs", "<Cmd>CmpStatus<CR>", desc = "Cmp status" },
    },
}
