local M = {}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

M.capabilities = vim.tbl_deep_extend(
    "force",
    capabilities,
    require("cmp_nvim_lsp").default_capabilities(),
    {
        workspace = {
            -- PERF: didChangeWatchedFiles is too slow https://github.com/neovim/neovim/issues/23291#issuecomment-1686709265
            didChangeWatchedFiles = { dynamicRegistration = false },
        },
    }
)

M.on_attach = function(client, bufnr)
    vim.api.nvim_set_hl(0, "LspInlayHInt", { link = "CmpGhostText" })

    local methods = vim.lsp.protocol.Methods
    local enabled = false -- disabling inlayhint at startup

    if vim.fn.has('nvim-0.10') ==1 then
        if client.supports_method(methods.textDocument_inlayHint) then
            local inlay_hints_group = require("utils").augroup("toggle_inalay_hints")

            -- Initial inlay hint display.
            vim.defer_fn(function()
                -- local mode = vim.api.nvim_get_mode().mode
                vim.lsp.inlay_hint.enable(bufnr, enabled)
            end, 500)

            vim.api.nvim_create_autocmd("InsertEnter", {
                group = inlay_hints_group,
                desc = "enable inlay hints",
                buffer = bufnr,
                callback = function()
                    vim.lsp.inlay_hint.enable(bufnr, false)
                end,
            })
            vim.api.nvim_create_autocmd("InsertLeave", {
                group = inlay_hints_group,
                desc = "disable inlay hints",
                buffer = bufnr,
                callback = function()
                    vim.lsp.inlay_hint.enable(bufnr, enabled)
                end,
            })
        end

    end

    -- treesitter-refactor doing the job for now
    -- if client.supports_method(methods.textDocument_documentHighlight) then
    --     local augroup = require("utils").augroup("cursor_highlights",false )
    --     vim.api.nvim_create_autocmd({ 'CursorHold', 'InsertLeave', 'BufEnter' }, {
    --         group = augroup,
    --         desc = 'highlight references under the cursor',
    --         buffer = bufnr,
    --         callback = vim.lsp.buf.document_highlight,
    --     })
    --     vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter', 'BufLeave' }, {
    --         group = augroup,
    --         desc = 'clear highlight references',
    --         buffer = bufnr,
    --         callback = vim.lsp.buf.clear_references,
    --     })
    -- end

    local mappings = {
        -- { "K", vim.lsp.buf.hover, { desc = "display hover information" } },
        { "gd", vim.lsp.buf.definition, { desc = "jump to the defination " } },
        { "gD", vim.lsp.buf.declaration, { desc = "jump to the declaration " } },
        { "gI", vim.lsp.buf.implementation, { desc = "list implementation" } },
        { "gy", vim.lsp.buf.type_definition, { desc = "goto type defination" } },
        { "gr", vim.lsp.buf.references, { desc = "show references" } },
        { "gK", vim.lsp.buf.signature_help, { desc = "signature help" } },
        { "<leader>cr", vim.lsp.buf.rename, { desc = "LSP rename" } },
        { "<leader>ca", vim.lsp.buf.code_action, { mode = { "n", "v" }, desc = "code actions" } },
        { "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "add workspace folder" } },
        { "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "remove workspace folder" } },
        {
            "<leader>wL",
            function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end,
            { desc = "list workspace folder" },
        },
        { "<leader>ws", vim.lsp.buf.workspace_symbol, { desc = "list all symbols" } },
        { "<leader>li", vim.cmd.LspInfo, { desc = "lsp info" } },
        {
            "<C-b>", -- someone help me to pick right keybind for this one
            vim.lsp.buf.signature_help,
            -- function()
            --     if not vim.lsp.buf.signature_help() then return "<C-k>" end
            -- end,
            { mode = "i", desc = "signature help" },
        },
        {
            "<leader>lt",
            function()
                local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
                if not vim.tbl_isempty(clients) then
                    vim.cmd("LspStop")
                else
                    vim.cmd("LspStart")
                end
            end,
            { desc = "toggle lsp" },
        },
        {
            "<leader>cA",
            function()
                vim.lsp.buf.code_action({
                    context = { only = { "source" }, diagnostic = {} },
                })
            end,
            { desc = "source action" },
        },
        {
            "<leader>lf",
            function()
                vim.lsp.buf.format({
                    async = true,
                    {
                        bufnr = bufnr,
                        filter = function(args)
                            return args.name == "null-ls"
                        end,
                    },
                })
                vim.api.nvim_command("write")
            end,
            { mode = { "n", "v" }, desc = "lsp formatting" },
        },
        { "<leader>cd", vim.diagnostic.open_float, { desc = "line diagnostics" } },
        { "]d", M.diagnostic_goto(true), { desc = "diagnostic" } },
        { "[d", M.diagnostic_goto(false), { desc = "diagnostic" } },
        { "]e", M.diagnostic_goto(true, "ERROR"), { desc = "error" } },
        { "[e", M.diagnostic_goto(false, "ERROR"), { desc = "error" } },
        { "]i", M.diagnostic_goto(true, "HINT"), { desc = "info/hint" } },
        { "[i", M.diagnostic_goto(false, "HINT"), { desc = "info/hint" } },
        { "]w", M.diagnostic_goto(true, "WARN"), { desc = "warning" } },
        { "[w", M.diagnostic_goto(false, "WARN"), { desc = "warning" } },
    }

    if vim.lsp.inlay_hint then
        table.insert(mappings, {
            "<leader>uh",
            function()
                -- local enabled = vim.lsp.inlay_hint.is_enabled(0) ~= true
                enabled = enabled ~= true
                vim.lsp.inlay_hint.enable(0, enabled)
            end,
            { desc = "toggle inlay hints" },
        })
    end

    for _, value in pairs(mappings) do
        local opts = value[#value]
        opts.buffer = bufnr
        local mode = "n"
        if opts.mode then
            mode = opts.mode
            opts.mode = nil
        end
        require("utils").map(mode, value[1], value[2], opts)
    end
end

M.diagnostic_goto = function(next, severity)
    local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function()
        go({ severity = severity })
    end
end

M.setup_diagnostics = function()
    vim.diagnostic.config({
        float = {
            border = "rounded",
            show_header = false, -- test
            source = "always",
        },
        -- signs = true,
        signs = { -- test
            -- With highest priority
            priority = 9999,
            -- Only for warnings and errors
            severity = { min = 'WARN', max = 'ERROR' },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        virtual_text = {
            severity = { min = 'ERROR', max = 'ERROR' }, -- show virtual text only for errors
            spacing = 4,
            source = "if_many",
            prefix = "●",
            -- prefix = "icons"
        },
    })

    -- sign column
    local signs = require("utils.icons").diagnostics
    for type, icon in pairs(signs) do
        local name = "DiagnosticSign" .. type
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = name })
    end
end

return M
