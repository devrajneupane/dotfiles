-- https://gist.github.com/mactep/430449fd4f6365474bfa15df5c02d27b looks cool :)

--- Change the brightness of a color by given number
---@param color string
---@param num float
---@return string
local function tint(color, num)
    local r = tonumber(color:sub(2, 3), 16)
    local g = tonumber(color:sub(4, 5), 16)
    local b = tonumber(color:sub(6), 16)

    local blend = function(component)
        component = math.floor(component * (1 + num))
        return math.min(math.max(component, 0), 255)
    end
    return string.format("#%02x%02x%02x", blend(r), blend(g), blend(b))
end

vim.api.nvim_create_autocmd({ "ColorScheme", "UIEnter" }, {
    group = vim.api.nvim_create_augroup("DimHlGroup", { clear = true }),
    callback = function()
        local hl = vim.api.nvim_get_hl(0, { name = "Normal" })
        local color = ("#%06x"):format(hl.bg)
        vim.schedule(function()
            pcall(vim.api.nvim_set_hl, 0, "TSDim", { fg = tint(color, 0.30) })
            vim.api.nvim_set_hl(0, "TreesitterContextSeparator", { link = "TSDim" })
            vim.api.nvim_set_hl(0, "TreesitterContext", { link = "Normal" })
        end)
    end,
})
