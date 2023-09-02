-- TODO: replace this plugin with https://github.com/Bekaboo/dropbar.nvim after nvim>=0.10
return {
    "SmiteshP/nvim-navic",
    event = "LspAttach",
    init = function()
        vim.g.navic_silence = true
    end,
    opts = {
        icons = require("utils.icons").kinds,
        highlight = true,
        click = true,
        separator = "  ", -- "  ",
        -- depth_limit = 5,
        lazy_update_context = true
    },
}
