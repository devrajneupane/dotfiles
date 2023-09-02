-- Compile lua to bytecode
if vim.loader then
    vim.loader.enable()
end

---@see https://github.com/gbprod/yanky.nvim/issues/46#issuecomment-1227369275
vim.g.clipboard = {
    name = "xsel_override",
    copy = {
        ["+"] = "xsel --input --clipboard",
        ["*"] = "xsel --input --primary",
    },
    paste = {
        ["+"] = "xsel --output --clipboard",
        ["*"] = "xsel --output --primary",
    },
    cache_enabled = 1,
}

require("config.options")
require("config.lazy")

vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        require("config.autocmds")
        require("config.keymaps")
    end,
})
