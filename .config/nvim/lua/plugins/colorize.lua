return {

    -- Color highlighter
    {
        "NvChad/nvim-colorizer.lua",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            filetypes = { "*" },
            user_default_options = {
                names = false,
                RRGGBBAA = true, -- #RRGGBBAA hex codes
                css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
                css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                mode = "background", -- Available modes for `mode`: foreground, background,  virtualtext
                tailwind = true,
                sass = { enable = true, parsers = { "css" } }, -- Enable sass colors
                virtualtext = "■",
                -- cmp_docs = { always_update = true },
                always_update = true,
            },
            -- buftypes = { "!nofile", "!prompt", "!popup" },
            buftypes = { "!nofile", "!popup" },
        },
    }
}
