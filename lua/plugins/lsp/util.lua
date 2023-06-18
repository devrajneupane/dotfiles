local M = {}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = false

M.capabilities = vim.tbl_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

M.on_attach = function(_, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	local mappings = {
		-- { "K", vim.lsp.buf.hover, { desc = "display hover information" } },
		{ "gd", vim.lsp.buf.definition, { desc = "jump to the defination " } },
		{ "gD", vim.lsp.buf.declaration, { desc = "jump to the declaration " } },
		{ "gI", vim.lsp.buf.implementation, { desc = "list implementation" } },
		{ "gy", vim.lsp.buf.type_definition, { desc = "goto type defination" } },
		{ "gr", vim.lsp.buf.references, { desc = "show references" } },
		{ "gK", vim.lsp.buf.signature_help, { desc = "show signature info" } },
		{ "<leader>rn", vim.lsp.buf.rename, { desc = "lsp rename" } },
		{ "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "add workspace folder" } },
		{ "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "remove workspace folder" } },
		{ "<leader>wl", vim.lsp.buf.list_workspace_folders, { desc = "list workspace folder" } },
		{ "<leader>ws", vim.lsp.buf.workspace_symbol, { desc = "list all symbols" } },
		{ "<leader>ca", vim.lsp.buf.code_action, { mode = { "n", "v" }, desc = "code action" } },
		{ "<leader>li", vim.cmd.LspInfo, { desc = "lsp info" } },
		{
			"<leader>cA",
			function()
				vim.lsp.buf.code_action({
					context = { only = { "source" }, diagnostic = { } },
				})
			end,
			{ desc = "Source action" },
		},
		{
			"<leader>lf",
			function()
				vim.lsp.buf.format({
                    async = true,
                    {
                        bufnr = bufnr,
                        filter = function(client)
                            return client.name == "null-ls"
                        end
                    }
                })
				vim.api.nvim_command("write")
			end,
			{ mode = { "n", "v" }, desc = "Lsp formatting" },
		},
        { "gld", vim.diagnostic.open_float, { desc = "show line diagnostics" } },
		{ "]d", M.diagnostic_goto(true), { desc = "Next Diagnostic" } },
		{ "[d", M.diagnostic_goto(false), { desc = "Prev Diagnostic" } },
		{ "]e", M.diagnostic_goto(true, "ERROR"), { desc = "Next Error" } },
		{ "[e", M.diagnostic_goto(false, "ERROR"), { desc = "Prev Error" } },
		{ "]w", M.diagnostic_goto(true, "WARN"), { desc = "Next Warning" } },
		{ "[w", M.diagnostic_goto(false, "WARN"), { desc = "Prev Warning" } },
	}

	for _, value in pairs(mappings) do
		local opts = value[#value]
		opts.buffer = bufnr
		local mode = "n"
		if opts.mode then
			mode = opts.mode
			opts.mode = nil
		end
		require('utils').map(mode, value[1], value[2], opts)
	end
end

M.diagnostic_goto = function(next, severity)
    local goto = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function()
        goto({severity = severity})
    end
end

M.setup_diagnostics = function()
	vim.diagnostic.config({
        signs = true,
        underline = true,
        update_in_insert = true,
        severity_sort = true,
        virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = "●",
        },
	})

	-- sign column
	local signs = require("utils").lsp_signs
	for type, icon in pairs(signs) do
		local name = "DiagnosticSign" .. type
		vim.fn.sign_define(name, { text = icon, texthl = name, numhl = name })
	end
end

return M
