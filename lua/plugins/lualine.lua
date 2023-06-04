return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
        { "nvim-tree/nvim-web-devicons" },
        { "jcdickinson/wpm.nvim", event = "VeryLazy", config = true },
    },
    opts = function()
        local colors = require("tokyonight.colors").setup()

        local function diff_source()
            ---@diagnostic disable-next-line: undefined-field
            local gitsigns = vim.b.gitsigns_status_dict
            if gitsigns then
                return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                }
            end
        end

        local location = { "location", padding = 0 }
        local filename = { "filename", path = 1, shorting_target = 80, color = { bg = colors.bg } }
        return {
            options = {
                icons_enabled = true,
                theme = "auto",
                section_separators = "",
                component_separators = "",
                always_divide_middle = true,
                globalstatus = true,
                disabled_filetypes = {
                    statusline = {},
                    winbar = {
                        "diff",
                        "neo-tree",
                        "nofile",
                        "noice",
                        "qf",
                        "toggleterm",
                        "undotree",
                    },
                },
            },
            extensions = {
                "lazy",
                "man",
                "toggleterm",
                "trouble",
                "neo-tree",
                "quickfix",
            },
            sections = {
                lualine_a = {
                    {
                        "branch",
                        on_click = function()
                            vim.defer_fn(function()
                                require("telescope.builtin").git_branches()
                            end, 100)
                        end,
                    },
                    {
                        function()
                            local sp_icons = { "🌑", "🌒", "🌓", "🌔", "🌕", "🌖", "🌗", "🌘" }
                            return sp_icons[os.date("%S") % #sp_icons + 1]
                        end,
                        cond = function()
                            return vim.api.nvim_get_mode()["mode"] ~= "i"
                        end,
                    },
                },
                lualine_b = {
                    { "diff", source = diff_source },
                    "diagnostics",
                },
                lualine_c = {
                    {
                        require("noice").api.status.search.get,
                        cond = require("noice").api.status.search.has,
                        color = { fg = "#ff9e71" },
                    },
                    {
                        function()
                            local key = require("grapple").key()
                            return "  [" .. key .. "]"
                        end,
                        cond = function()
                            return require("grapple").exists()
                        end,
                    },
                },
                lualine_x = {
                    {
                        require("wpm").wpm,
                        cond = function()
                            return vim.api.nvim_get_mode()["mode"] == "i"
                        end,
                        color = { fg = "#008080" },
                    },
                    {
                        require("wpm").historic_graph,
                        cond = function()
                            return vim.api.nvim_get_mode()["mode"] == "i"
                        end,
                        color = { fg = "#008080" },
                    },
                    -- Lsp server name .
                    {
                        function()
                            local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
                            local clients = vim.lsp.get_active_clients()
                            for _, client in ipairs(clients) do
                                local filetypes = client.config.filetypes
                                if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 and client.name ~= "null-ls" then
                                    return client.name
                                end
                            end
                        end,
                        cond = function()
                            return next(vim.lsp.get_active_clients()) ~= nil
                        end,
                        icon = " ", -- 
                        color = { fg = "009999", gui = "bold" },
                        on_click = function()
                            vim.defer_fn(function()
                                vim.cmd.LspInfo()
                            end, 100)
                        end,
                    },
                },
                lualine_y = {
                    {
                        "encoding",
                        fmt = string.upper,
                    },
                    "filetype",
                },
                lualine_z = { location, "progress" },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = { location },
            },
            winbar = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {
                    filename,
                    {
                        function() return require("nvim-navic").get_location() end,
                        cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
                    },
                },
                lualine_x = {},
                lualine_y = {},
                lualine_z = {},
            },
            inactive_winbar = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {
                },
                lualine_x = {},
                lualine_y = {},
                lualine_z = {},
            },
        }
    end,
    keys = function()
        local toggle = require("lualine").hide
        local function toggle_lualine(place)
            if vim.g["lualine_" .. place] == nil then
                toggle({
                    place = { place },
                })
                vim.g["lualine_" .. place] = 1
            else
                toggle({
                    place = { place },
                    unhide = true,
                })
                vim.g["lualine_" .. place] = nil
            end
        end
        return {
            {
                "<leader>ll",
                function()
                    toggle_lualine("statusline")
                end,
                desc = "toggle statusline",
            },
            {
                "<leader>lw",
                function()
                    toggle_lualine("winbar")
                end,
                desc = "toggle winbar",
            },
        }
    end,
}
