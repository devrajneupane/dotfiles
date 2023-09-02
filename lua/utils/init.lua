local M = {}

function M.map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false
    opts.noremap = opts.noremap ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
end

function M.augroup(name, clear)
    return vim.api.nvim_create_augroup(name, { clear = clear or true })
end

function M.is_git_repo(path)
    local cmd = { "git", "-C", path, "rev-parse", "--is-inside-work-tree" }
    local status, output = pcall(vim.fn.system, cmd, true)
    if status and output:match("true") then
        return true
    else
        return false
    end
end

--- converts string into titlecase
---@param str str
---@return str
function M.title_case(str)
   local result = str:gsub("(%l)(%l*)", function(first, rest)
       return first:upper()..rest:lower()
   end)
   return result
end

--- extract keys form table
---@param opts table
---@return table
function M.get_table_keys(opts)
    local keyset = {}
    for k, _ in pairs(opts) do
        keyset[#keyset+1] = k
    end
    return keyset
end

function M.dump(...)
    local msg = vim.inspect(...)
    vim.notify(msg, vim.log.levels.INFO, {
        title = "Debug",
        on_open = function(win)
            vim.wo[win].conceallevel = 3
            vim.wo[win].concealcursor = ""
            vim.wo[win].spell = false
            local buf = vim.api.nvim_win_get_buf(win)
            vim.treesitter.start(buf, "lua")
        end,
    })
end

function M.on_attach(on_attach)
    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(args)
            local buf = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client.server_capabilities.documentSymbolProvider then
                require("nvim-navic").attach(client, buf)
            end
            if client.name == "ruff_lsp" then
                client.server_capabilities.hoverProvider = false
            end
            on_attach(client, buf)
        end,
    })
end

-- create scratch buffer and focus on it
M.new_scratch_buffer = function()
  local buf_id = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_win_set_buf(0, buf_id)
  return buf_id
end

-- execute current line with `lua`
M.execute_lua_line = function()
  local line = 'lua ' .. vim.api.nvim_get_current_line()
  vim.api.nvim_command(line)
  M.dump(line)
  vim.api.nvim_input('<Down>')
end

function M.notify(msg, label, notify_opts)
    vim.notify(msg, vim.log.levels[label], notify_opts)
end

--- toggle option
---@param opt str
---@param silent boolean?
function M.option(opt, silent)
    vim.opt_local[opt] = not vim.opt_local[opt]:get()
    if not silent then
        if vim.opt_local[opt]:get() then
            M.notify("Enabled " .. opt, "INFO", { title = "Option" })
        else
            M.notify("Disabled " .. opt, "WARN", { title = "Option" })
        end
    end
end

function M.toggle_diagnostics()
    if vim.diagnostic.is_disabled() then
        vim.diagnostic.enable()
        -- vim.diagnostic.show()
        M.notify("Enabled Diagnostics", "INFO", { title = "Diagnostic" })
    else
        -- vim.diagnostic.hide()
        vim.diagnostic.disable()
        M.notify("Disabled Diagnostics", "WARN", { title = "Diagnostic" })
    end
end

M.quickfix_active = false
function M.toggle_quickfix()
    M.quickfix_active = not M.quickfix_active
    if M.quickfix_active then
        vim.cmd.copen()
        M.notify("Enabled quickfix", "INFO", { title = "Quickfix" })
    else
        vim.cmd.cclose()
        M.notify("disabled quickfix", "WARN", { title = "Quickfix" })
    end
end

return M
