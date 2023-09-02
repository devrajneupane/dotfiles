-- TODO: i can do better with keymapse
return {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-live-grep-args.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    opts = function()
        local actions = require("telescope.actions")
        local action_layout = require("telescope.actions.layout")
        local lga_actions = require("telescope-live-grep-args.actions")
        local trouble = require("trouble.providers.telescope")
        return {
            defaults = {
                vimgrep_arguments = {
                    "rg",
                    "--follow",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                },
                prompt_prefix = "󰭎  ", -- 
                -- initial_mode = "normal",
                layout_strategy = "flex",
                sorting_strategy = "ascending",
                selection_caret = ' ',
                path_display = { "truncate" }, -- truncate
                -- file_ignore_patterns = { "^%.git/", "^node_modules/" }, -- :h telescope.defaults.file_ignore_patterns*
                file_ignore_patterns = {
                    ".*%.png$",
                    ".*%.jpe?g$",
                    ".*%.gif$",
                    ".*%.wav$",
                    ".*%.aiff$",
                    ".*%.dll$",
                    ".*%.pdf$",
                    ".*%.pdb$",
                    ".*%.mdb$",
                    ".*%.so$",
                    ".*%.swp$",
                    ".*%.zip$",
                    ".*%.gz$",
                    ".*%.bz2$",
                    ".*%.meta",
                    ".*%.cache",
                    ".*/%.git/",
                },
                dynamic_preview_title = true,
                cycle_layout_list = { "horizontal", "vertical", "center", "cursor", "bottom_pane" },
                layout_config = {
                    horizontal = {
                        preview_width = 0.55,
                        preview_cutoff = 120,
                        prompt_position = "top",
                    },
                },
                mappings = {
                    i = {
                        ["<C-u>"] = false,
                        ["<C-o>"] = trouble.open_with_trouble,
                        ["<M-p>"] = action_layout.toggle_preview,
                        ["<M-m>"] = action_layout.toggle_mirror,
                        ["<M-k>"] = action_layout.cycle_layout_next,
                        ["<M-j>"] = action_layout.cycle_layout_prev,
                        ["<c-g>s"] = actions.select_all,
                        ["<c-g>a"] = actions.add_selection,
                    },
                    n = {
                        ["q"] = actions.close,
                        ["<C-o>"] = trouble.open_with_trouble,
                        ["<M-p>"] = action_layout.toggle_preview,
                    },
                },
            },
            pickers = {
                buffers = {
                    sort_lastused = true,
                    sort_mru = true,
                },
                builtin = {
                    include_extension = true,
                },
                colorscheme = {
                    prompt_prefix = "  ",
                    enable_preview = true,
                },
                find_files = { hidden = true },
                keymaps = {
                    prompt_prefix = "  ",
                },
                highlights = {
                    prompt_prefix = "  ",
                },
                live_grep = {
                    mappings = {
                        i = { ["<C-f>"] = actions.to_fuzzy_refine },
                        n = { ["<C-f>"] = actions.to_fuzzy_refine },
                    },
                },
            },
            extensions = {
                fzf = {
                    fuzzy = true,    -- false will only do exact matching
                    override_generic_sorter = true, -- override the generic sorter
                    override_file_sorter = true, -- override the file sorter
                    case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                },
                live_grep_args = {
                    mappings = {
                        i = {
                            ["<C-f>"] = actions.to_fuzzy_refine,
                            ["<C-k>"] = lga_actions.quote_prompt(),
                            ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                        },
                    },
                },
                noice = {},
                notify = {},
            },
        }
    end,
    keys = {
        { "<leader>:", "<Cmd>Telescope commands<CR>", desc = "plugin/user commands" },
        { "<leader>f'", "<Cmd>Telescope marks<CR>", desc = "marks" },
        { "<leader>f;", "<Cmd>Telescope command_history<CR>", desc = "commands history" },
        { "<leader>f ", "<Cmd>Telescope resume<CR>", desc = "resume picker" },
        { "<leader>f\"", "<Cmd>Telescope registers<CR>", desc = "registers" },
        { "<leader>fa", "<Cmd>Telescope autocommands<CR>", desc = "autocommands" },
        { "<leader>fb", "<Cmd>Telescope buffers theme=dropdown previewer=false<CR>", desc = "find buffers" },
        { "<leader>fc", "<Cmd>Telescope colorscheme<CR>", desc = "colorschemes" },
        { "<leader>fd", "<Cmd>Telescope diagnostics<CR>", desc = "workspace diagnostics" },
        { "<leader>ff", "<Cmd>Telescope find_files<CR>", desc = "find files" },
        { "<leader>f/", "<Cmd>Telescope live_grep<CR>", desc = "find in files (grep)" },
        { "<leader>fh", "<Cmd>Telescope help_tags<CR>", desc = "help tags" },
        { "<leader>fk", "<Cmd>Telescope keymaps<CR>", desc = "keymaps" },
        { "<leader>fl", "<Cmd>Telescope live_grep_args<CR>", desc = "find in files (grep with args)" },
        { "<leader>fm", "<Cmd>Telescope man_pages<CR>", desc = "man pages" },
        { "<leader>fq", "<Cmd>Telescope quickfixhistory<CR>", desc = "quickfix history" },
        { "<leader>fr", "<Cmd>Telescope oldfiles<CR>", desc = "recent files" },
        { "<leader>fs", "<Cmd>Telescope grep_string<CR>", desc = "grep string" },
        { "<leader>ft", "<Cmd>Telescope treesitter<CR>", desc = "treesitter" },
        { "<leader>fz", "<Cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "fuzzy search" },
        { "<leader>fH", "<Cmd>Telescope search_history<CR>", desc = "search history" },
        { "<leader>fO", "<Cmd>Telescope vim_options<CR>", desc = "vim options" },
        { "<leader><leader>", "<Cmd>Telescope fd<CR>", desc = "find files" },

        { "<leader>sh", "<Cmd>Telescope highlights<CR>", desc = "highlights" },

        -- git
        { "<leader>gf", "<Cmd>Telescope git_files<CR>", desc = "files 🔭" },
        { "<leader>gC", "<Cmd>Telescope git_bcommits<CR>", desc = "buffer's git commits 🔭" },
        { "<leader>gb", "<Cmd>Telescope git_branches<CR>", desc = "branches 🔭" },
        { "<leader>gc", "<Cmd>Telescope git_commits<CR>", desc = "commits 🔭" },
        { "<leader>gs", "<Cmd>Telescope git_status<CR>", desc = "status 🔭" },

        -- Misc
        { "<leader>fB", "<Cmd>Telescope builtin theme=dropdown<CR>", desc = "builtins 🔭" },
        {
            "<leader>f.",
            function()
                require("telescope.builtin").live_grep({
                    prompt_title = "dotfiles",
                    -- i couldn't do better on getting parent directory of a given directory
                    search_dirs = { table.concat({(vim.fn.stdpath("config")):match("(.*/).-")}, "") },
                })
            end,
            desc = "find in dotfiles",
        },
        {
            "<leader>fp",
            function()
                require("telescope.builtin").find_files({
                    cwd = require("lazy.core.config").options.root,
                })
            end,
            desc = "plugin files",
        },
        {
            "<leader>fl",
            function() -- thanks folke
                local files = {} ---@type table<string, string>
                for _, plugin in pairs(require("lazy.core.config").plugins) do
                    repeat
                        if plugin._.module then
                            local info = vim.loader.find(plugin._.module)[1]
                            if info then
                                files[info.modpath] = info.modpath
                            end
                        end
                        plugin = plugin._.super
                    until not plugin
                end
                require("telescope.builtin").live_grep({
                    default_text = "/",
                    search_dirs = vim.tbl_values(files),
                })
            end,
            desc = "lazy plugin spec",
        },
        {
            "<leader>ss",
            function()
                require("telescope.builtin").lsp_document_symbols({
                    -- FIX: still no symbol icons
                    symbols = require('utils').get_table_keys(require('utils.icons').kinds)
                })
            end,
            desc = "lsp symbols",
        },
        {
            "<leader>sS",
            function()
                require("telescope.builtin").lsp_dynamic_workspace_symbols({
                    symbols = require('utils').get_table_keys(require('utils.icons').kinds)
                })
            end,
            desc = "workspace symbols",
        },
    }
}
