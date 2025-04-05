--- TODO: add keybind to toggle light bulb
--- code actions light bulb inspired from nvimdev/lspsaga.nvim

local lb_icon = require("utils.icons").diagnostics.Hint
local lb_buf = nil
local lb_name = "lsp_light_bulb"
local namespace = vim.api.nvim_create_namespace(lb_name)

--- updates the current lightbulb.
---@param bufnr number?
---@param line number?
local function update_lightbulb(bufnr, line)
    if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
        return
    end

    vim.api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)

    if not line then
        return
    end

    pcall(vim.api.nvim_buf_set_extmark, bufnr, namespace, line, -1, {
        virt_text = { { " " .. lb_icon, "DiagnosticSignHint" } },
        virt_text_pos = "eol",
        hl_mode = "combine",
    })

    lb_buf = bufnr
end

--- request LSP servers for code action and update lightbulb
---@param bufnr number
local function render(bufnr)
    local line = vim.api.nvim_win_get_cursor(0)[1] - 1

    local params = vim.lsp.util.make_range_params()
    params.context = {
        diagnostics = vim.lsp.diagnostic.from(vim.diagnostic.get(bufnr, { lnum = line })),
        triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Automatic,
    }

    vim.lsp.buf_request(bufnr, "textDocument/codeAction", params, function(_, result, _)
        if vim.api.nvim_get_current_buf() ~= bufnr then
            return
        end

        update_lightbulb(bufnr, (result and #result > 0 and line) or nil)
    end)
end

local timer = assert(vim.uv.new_timer())

--- i didn't get it but assuming it waits for code action from LSP servers for given periods
---@param bufnr number
local function update(bufnr)
    timer:stop()
    update_lightbulb(lb_buf)
    timer:start(
        100,
        0,
        vim.schedule_wrap(function()
            timer:stop()
            if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_get_current_buf() == bufnr then
                render(bufnr)
            end
        end)
    )
end

local augroup = vim.api.nvim_create_augroup(lb_name, { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup,
    desc = "setup code action lightbulb",
    callback = function(opts)
        local client = vim.lsp.get_client_by_id(opts.data.client_id)

        if not client or not client:supports_method("textDocument/codeAction") then
            return true
        end

        local buf = opts.buf
        local buf_group_name = lb_name .. tostring(buf)
        if pcall(vim.api.nvim_get_autocmds, { group = buf_group_name, buffer = buf }) then
            return
        end
        local group = vim.api.nvim_create_augroup(buf_group_name, { clear = true })
        vim.api.nvim_create_autocmd("CursorMoved", {
            group = group,
            desc = "update lightbulb when moving cursor",
            buffer = buf,
            callback = function() update(buf) end,
        })

        vim.api.nvim_create_autocmd({ "InsertEnter", "BufLeave" }, {
            group = group,
            desc = "update lightbulb when entering insert mode or leaving buffer",
            buffer = buf,
            callback = function() update_lightbulb(buf, nil) end,
        })
    end,
})

vim.api.nvim_create_autocmd("LspDetach", {
    group = augroup,
    desc = "detach code action lightbulb",
    callback = function(args)
        pcall(vim.api.nvim_del_augroup_by_name, lb_name .. tostring(args.buf))
        -- ensure extmark is cleared
        vim.api.nvim_buf_clear_namespace(args.buf, namespace, 0, -1)
    end,
})
