--- @type LazySpec
return {
    {
        "echasnovski/mini.icons",
        init = function()
            package.preload["nvim-web-devicons"] = function()
                require("mini.icons").mock_nvim_web_devicons()
                return package.loaded["nvim-web-devicons"]
            end
        end,
        opts = {
            file = {
                ["%.keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
                ["devcontainer%.json"] = { glyph = "", hl = "MiniIconsAzure" },
                ["docker-compose%.*.y[a]ml"] = { glyph = "󰡨", hl = "MiniIconsAzure" },
                ["%.env%.example"] = { glyph = "", hl = "MiniIconsYellow" },
            },
            filetype = {
                dotenv = { glyph = "", hl = "MiniIconsYellow" },
            },
        },
    },
}
