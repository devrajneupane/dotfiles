--  TODO: better if only last two parent directory are shown rather than full path
local icons = require("utils.icons")
local kinds = icons.kinds
local git_icons = vim.deepcopy(icons.git)
git_icons.deleted = git_icons.removed
return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons",
    },
    init = function()
        vim.g.neo_tree_remove_legacy_commands = true

        if vim.fn.argc() == 1 then
            local stat = vim.loop.fs_stat(vim.fn.argv(0))
            if stat and stat.type == "directory" then
                require("neo-tree")
                vim.fn.chdir(vim.fn.argv(0)) -- auto cd to the argv(0) if it's a directory.
            end
        end
    end,
    opts = {
        auto_clean_after_session_restore = true,
        popup_border_style = "rounded",
        open_files_do_not_replace_types = { "help", "terminal", "Trouble", "qf" },
        git_status_async = true,
        sources = { "filesystem", "git_status", "document_symbols", "buffers" },
        source_selector = {
            winbar = true,
            -- separator_active = "",
            separator = { left = "", right = "" },
            tabs_layout = "center", -- start, end, center, equal, focus
            sources = {
                { source = "filesystem" },
                { source = "git_status" },
                { source = "document_symbols" },
            },
            highlight_tab = "Normal", --"NeoTreeTabInactive",
            -- highlight_tab_active = "Normal", -- "NeoTreeTabActive",
            highlight_background = "Normal", -- "NeoTreeTabInactive",
            highlight_separator = "Normal", -- "NeoTreeTabSeparatorInactive",
            highlight_separator_active = "Normal", --"NeoTreeTabSeparatorActive",
        },
        filesystem = {
            bind_to_cwd = false,
            follow_current_file = { enabled = true },
            hijack_netrw_behaviour = "open_current",
            use_libuv_file_watcher = true,
            filtered_items = {
                visible = true, -- grey out dotfiles
                hide_dotfiles = false,
                hide_gitignored = false,
                hide_by_name = {
                    ".DS_Store",
                    "thumbs.db",
                    "node_modules",
                    ".git",
                },
            },
            window = {
                mappings = {
                    ["a"] = {
                        "add",
                        nowait = true,
                        config = {
                            show_path = "relative", -- "none", "relative", "absolute"
                        },
                    },
                    ["A"] = { "add_directory", config = { show_path = "relative" } },
                    ["<tab>"] = {
                        command = function(state)
                            local node = state.tree:get_node()
                            if require("neo-tree.utils").is_expandable(node) then
                                state.commands["toggle_node"](state)
                            else
                                state.commands["open"](state)
                                vim.cmd.Neotree("reveal")
                            end
                        end,
                        desc = "open without loosing focus",
                    },
                },
            },
        },
        document_symbols = {
            kinds = {
                Array = { icon = kinds.Array, hl = "Type" },
                Boolean = { icon = kinds.Boolean, hl = "Boolean" },
                Class = { icon = kinds.Class, hl = "Structure" },
                Constant = { icon = kinds.Constant, hl = "Constant" },
                Constructor = { icon = kinds.Constructor, hl = "@constructor" },
                Enum = { icon = kinds.Enum, hl = "@type" },
                EnumMember = { icon = kinds.EnumMember, hl = "Number" },
                Event = { icon = kinds.Event, hl = "Special" },
                Field = { icon = kinds.Field, hl = "@field" },
                File = { icon = "󰈙", hl = "Directory" },
                Function = { icon = kinds.Function, hl = "Function" },
                Interface = { icon = kinds.Interface, hl = "Type" },
                Key = { icon = kinds.Key, hl = "@field" },
                Keyword = { icon = kinds.Keyword, hl = "@keyword" },
                Method = { icon = kinds.Method, hl = "Function" },
                Module = { icon = kinds.Module, hl = "@namespace" },
                Namespace = { icon = kinds.Namespace, hl = "@namespace" },
                Null = { icon = kinds.Null, hl = "@symbol" },
                Number = { icon = kinds.Number, hl = "@number" },
                Object = { icon = kinds.Object, hl = "@type" },
                Operator = { icon = kinds.Operator, hl = "@operator" },
                Package = { icon = kinds.Package, hl = "@include" },
                Property = { icon = kinds.Property, hl = "@property" },
                String = { icon = kinds.String, hl = "String" },
                Struct = { icon = kinds.Struct, hl = "@structure" },
                TypeParameter = { icon = kinds.TypeParameter, hl = "Typedef" },
                Variable = { icon = kinds.Variable, hl = "@variable" },
                Root = { icon = "", hl = "NeoTreeRootName" },
                Unknown = { icon = kinds.Undefined, hl = "@symbol" },
            },
        },
        window = {
            width = 30,
            mappings = {
                ["P"] = false,
                -- TODO: focus preview
                ["K"] = { "toggle_preview", config = { use_float = true } },
                ["I"] = { command = "show_debug_info" },

                ---@see https://github.com/nvim-neo-tree/neo-tree.nvim/discussions/163#discussioncomment-2274052
                ["h"] = {
                    command = function(state)
                        local node = state.tree:get_node()
                        if (node.type == "directory" or node:has_children()) and node:is_expanded() then
                            state.commands.toggle_node(state)
                        else
                            require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
                        end
                    end,
                    desc = "navigate out",
                },
                ["l"] = {
                    command = function(state)
                        local node = state.tree:get_node()
                        if node.type == "directory" or node:has_children() then
                            if not node:is_expanded() then
                                state.commands.toggle_node(state)
                            else
                                require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
                            end
                        end
                    end,
                    desc = "navigate in",
                },
                ["O"] = {
                    "system_open",
                    desc = "system open",
                },
                ["g"] = {
                    "toggle_gitignored",
                    desc = "toggle git ignored",
                },
                ["0"] = {
                    "toggle_dotfiles",
                    desc = "toggle dotfiles",
                },
                ["Z"] = "expand_all_nodes",
            },
        },
        commands = {
            system_open = function(state)
                local node = state.tree:get_node()
                local path = node:get_id()
                vim.api.nvim_command("silent !xdg-open " .. path)
            end,
            toggle_dotfiles = function(state)
                state.filtered_items.visible = false
                state.filtered_items.hide_dotfiles = not state.filtered_items.hide_dotfiles
                require("neo-tree.sources.manager").refresh("filesystem")
            end,
            toggle_gitignored = function(state)
                state.filtered_items.visible = false
                state.filtered_items.hide_gitignored = not state.filtered_items.hide_gitignored
                require("neo-tree.sources.manager").refresh("filesystem")
            end,
        },
        nesting_rules = { -- test
            ["docker"] = {
                pattern = "^dockerfile$",
                ignore_case = true,
                files = { ".dockerignore", "docker-compose.*", "dockerfile*" },
            },
        },
        -- hide cursor in neotree-window
        -- FIX: cursor is still visible on neo-tree buffer
        event_handlers = {
            {
                event = "file_opened",
                handler = function(file_path)
                    require("neo-tree.command").execute({ action = "close" })
                    vim.cmd.wincmd("=")
                end,
            },
            {
                event = "neo_tree_buffer_enter",
                handler = function()
                    vim.api.nvim_set_hl(0, "Cursor", { blend = 100 })
                end,
            },
            {
                event = "neo_tree_popup_buffer_enter",
                handler = function()
                    vim.api.nvim_set_hl(0, "Cursor", { blend = 0 })
                end,
            },
            {
                event = "neo_tree_buffer_leave",
                handler = function()
                    vim.api.nvim_set_hl(0, "Cursor", { blend = 0 })
                end,
            },
            {
                event = "neo_tree_popup_buffer_leave",
                handler = function()
                    vim.api.nvim_set_hl(0, "Cursor", { blend = 100 })
                end,
            },
            {
                event = "neo_tree_window_after_close",
                handler = function(args)
                    vim.api.nvim_set_hl(0, "Cursor", { blend = 0 })
                    if args.position == "left" or args.position == "right" then
                        vim.cmd.wincmd("=")
                    end
                end,
            },
        },
        default_component_configs = {
            icon = {
                folder_empty = "󰜌",
                folder_empty_open = "󰜌",
            },
            modified = {
                symbol = " ", -- 󰐕  
            },
            name = {
                highlight_opened_files = true,
            },
            git_status = {
                symbols = git_icons,
            },
            indent = {
                with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
                expander_collapsed = "",
                expander_expanded = "",
                expander_highlight = "NeoTreeExpander",
            },
            created = {
                enabled = true,
                required_width = 120,
            },
            symlink_target = {
                enabled = true,
            },
        },
    },
    config = function(_, opts)
        require("neo-tree").setup(opts)

        local normal = vim.api.nvim_get_hl(0, { name = "NeoTreeNormal" })
        normal.fg = normal.bg
        vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", normal)
    end,
    keys = {
        { "<leader>e", "<Cmd>Neotree filesystem left reveal toggle<CR>", desc = "neotree toggle" },
        { "<leader>fe", "<leader>e", remap = true, desc = "file explorer" },
        { "<leader>bb", "<Cmd>Neotree toggle show buffers right<CR>", desc = "neotree buffers" },
        { "<leader>fo", "<Cmd>Neotree reveal_file=%<CR>", desc = "neotree reveal_file" },
        {
            "<leader>fS",
            "<Cmd>Neotree action=focus source=document_symbols position=right toggle<CR>",
            desc = "neotree document_symbols",
        },
        {
            "<leader>fE",
            function()
                require("neo-tree.command").execute({ dir = vim.loop.cwd(), toggle = true })
            end,
            desc = "neotree toggle (cwd)",
        },
        {
            "<leader>ge",
            function()
                require("neo-tree.command").execute({ source = "git_status", toggle = true })
            end,
            desc = "git explorer",
        },
    },
    deactivate = function()
        vim.cmd([[Neotree close]])
    end,
}
