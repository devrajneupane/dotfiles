-- TODO: add component to show battery status when the battery drops below threshold
return {
    "nvim-lualine/lualine.nvim",
    event = {"BufReadPost"},
    dependencies = {
        { "echasnovski/mini.icons" },
    },
    opts = function()
        -- local colors = require("tokyonight.colors").setup()
        local icons = require('utils.icons')

        local lualine_require = require("lualine_require")
        lualine_require.require = require

        -- Override location component
        -- TODO: make it bold and italic
        package.loaded["lualine.components.location"] = function()
            local line = vim.fn.line(".")
            local line_count = vim.api.nvim_buf_line_count(0)
            local col = vim.fn.virtcol(".")

            return string.format("l:%d/%d c:%d", line, line_count, col)
        end

        -- Disable progress
        package.loaded["lualine.components.progress"] = function() return "" end

        return {
            options = {
                theme = 'auto',
                section_separators = "",
                component_separators = "",
                always_divide_middle = true,
                globalstatus = true,
                disabled_filetypes = {
                    statusline = {},
                    winbar = { "dap-repl", "dbout", "dbui", "diff", "help", "man", "neo-tree", "nofile", "noice", "qf", "toggleterm", "Trouble", "undotree", "" },
                },
            },
            extensions = { "lazy", "man", "mason", "neo-tree", "nvim-dap-ui", "quickfix", "toggleterm", "trouble" },
            sections = {
                lualine_a = {
                    {
                        "mode",
                        padding = {left = 1, right = 1},
                        icon = ""
                    },
                    {
                        function()
                            local spinners = { "󱑋", "󱑌", "󱑍", "󱑎", "󱑏", "󱑐", "󱑑", "󱑒", "󱑓", "󱑔", "󱑕", "󱑖" }
                            return spinners[os.date("%S") % #spinners + 1]
                        end,
                        cond = function()
                            return vim.api.nvim_get_mode()["mode"] ~= "i"
                        end,
                        on_click = function()
                            vim.print(os.date())
                        end,
                        padding = { left = 0, right = 1}
                    },
                },
                lualine_b = {
                    {
                        "branch",
                        on_click = function()
                            vim.defer_fn(function()
                                require("telescope.builtin").git_branches()
                            end, 100)
                        end,
                        icon = icons.git.branch,
                        padding = { left = 1, right = 1 }
                    },
                },
                lualine_c = {
                    {
                        "diff",
                        symbols = {
                            added = icons.git.added,
                            modified = icons.git.modified,
                            removed = icons.git.removed,
                        },
                        source = function ()
                            local gitsigns = vim.b.gitsigns_status_dict
                            if gitsigns then
                                return {
                                    added = gitsigns.added,
                                    modified = gitsigns.changed,
                                    removed = gitsigns.removed,
                                }
                            end
                        end,
                    },
                    {
                        "diagnostics",
                        symbols = {
                            error = icons.diagnostics.Error,
                            warn = icons.diagnostics.Warn,
                            info = icons.diagnostics.Info,
                            hint = icons.diagnostics.Hint,
                        },
                    },
                    { "searchcount" }, -- color = { fg = colors.fg } },
                    {
                        function()
                            return require("noice").api.status.mode.get_hl()
                        end,
                        cond = function()
                            return package.loaded["noice"] and require("noice").api.status.mode.has()
                        end,
                        -- color = { fg = "#ff9e71" },
                    },
                },
                lualine_x = {
                    {
                        function()
                            local wpm = require('wpm')
                            return wpm.wpm() .. " " .. wpm.historic_graph()
                        end,
                        cond = function() return package.loaded["wpm"] and vim.api.nvim_get_mode()["mode"] == "i" end,
                        color = { fg = "#008080" },
                    },
                    {
                        function() return require("dap").status() end,
                        cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
                        icon = icons.misc.Debug,
                    },
                    {
                        function()
                            local status = require("copilot.api").status.data
                            return status.message or ""
                        end,
                        icon = icons.kinds.Copilot,
                        cond = function()
                            local ok, clients = pcall(vim.lsp.get_active_clients, { name = "copilot", bufnr = 0 })
                            return ok and #clients > 0
                        end,
                    },
                    -- Lsp server name .
                    {
                        function()
                            if rawget(vim, "lsp") then
                                for _, client in ipairs(vim.lsp.get_active_clients()) do
                                    if
                                        client.attached_buffers[vim.api.nvim_get_current_buf()]
                                        and client.name ~= "null-ls"
                                    then
                                        return client.name
                                    end
                                end
                            end
                        end,
                        cond = function() return #(vim.lsp.get_active_clients({ bufnr = 0 })) >0 end,
                        icon = " ",
                        color = { fg = "#009999", gui = "bold" },
                        on_click = function()
                            vim.defer_fn(function() vim.cmd.LspInfo() end, 100)
                        end,
                    },
                },
                lualine_y = {
                    "filetype",
                    {
                        "encoding",
                        fmt = string.upper,
                        icon = ""
                    },
                },
                lualine_z = {
                    -- TODO: make it fixwidth so that my statusline won't wiggle
                    {
                        function()
                            local line = vim.fn.line(".")
                            local line_count = vim.api.nvim_buf_line_count(0)
                            local col = vim.fn.virtcol(".")

                            return string.format(':%d/%d :%d', line, line_count, col)
                        end,
                        padding = { left = 1, right = 0 },
                    },
                },
            },
            winbar = {
                lualine_c = {
                    {
                        "filename",
                        path = 1,
                        -- shorting_target = 80,
                        -- color = { bg = colors.bg },
                    },
                    {
                        function() return require("nvim-navic").get_location() end,
                        cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
                    },
                },
            },
            inactive_winbar = {
                lualine_c = {
                    {
                        "filename",
                        path = 1,
                        shorting_target = 80,
                        -- color = { bg = colors.bg },
                    }
                },
            },
        }
    end,
    keys = function()
        local hide = require("lualine").hide
        local function toggle_lualine(place)
            if vim.g["lualine_" .. place] == nil then
                hide({ place = { place } })
                vim.g["lualine_" .. place] = 1
            else
                hide({ place = { place }, unhide = true })
                vim.g["lualine_" .. place] = nil
            end
        end
        return {
            {
                "<leader>ul",
                function() toggle_lualine("statusline") end,
                desc = "toggle statusline",
            },
            {
                "<leader>ub",
                function() toggle_lualine("winbar") end,
                desc = "toggle winbar",
            },
        }
    end,
}
