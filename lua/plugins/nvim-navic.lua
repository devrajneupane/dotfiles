return {
    "SmiteshP/nvim-navic",
    init = function()
        vim.g.navic_silence = true
        require("utils").on_attach(function(client, buffer)
            if client.server_capabilities.documentSymbolProvider then
                require("nvim-navic").attach(client, buffer)
            end
        end)
    end,
    opts = {
        icons = require("utils").lsp_kinds,
        highlight = true,
        click = true,
        lsp = {
            auto_attach = true,
            preference = nil,
        },
    },
}
