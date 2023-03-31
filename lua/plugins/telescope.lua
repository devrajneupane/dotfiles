return {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-ui-select.nvim",
        "nvim-telescope/telescope-live-grep-args.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    opts = function()
        local actions = require("telescope.actions")
        local theme = require("telescope.themes")
        local lga_actions = require("telescope-live-grep-args.actions")
        local trouble = require("trouble.providers.telescope")
        return {
            defaults = {
                prompt_prefix = " ",
                initial_mode = "normal",
                layout_strategy = "horizontal",
                sorting_strategy = "ascending",
                layout_config = {
                    horizontal = {
                        preview_width = 0.55,
                        preview_cutoff = 0,
                        prompt_position = "top",
                    },
                },
                mappings = {
                    i = {
                        ["<C-o>"] = trouble.open_with_trouble,
                    },
                    n = {
                        ["q"] = actions.close,
                        ["<C-o>"] = trouble.open_with_trouble,
                    },
                },
            },
            pickers = {
                find_files = { hidden = true },
                live_grep = {
                    mappings = {
                        i = { ["<C-f>"] = actions.to_fuzzy_refine },
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
                            i = {
                                ["<C-k>"] = lga_actions.quote_prompt(),
                                ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                            },
                        },
                    },
                    ["ui-select"] = {
                        theme.get_dropdown({
                            -- even more opts
                        }),
                    },
                },
            },
        }
    end,
    config = function(_, opts)
        local telescope = require("telescope")
        telescope.setup(opts)
        telescope.load_extension("fzf")
        telescope.load_extension("live_grep_args")
        telescope.load_extension("ui-select")
        telescope.load_extension("noice")
    end,
    keys = function()
        local cmd = require("utils").cmd
        return {
            { "<leader>ff", cmd("Telescope find_files"),                desc = "find files" },
            { "<leader>fb", cmd("Telescope buffers"),                   desc = "find buffers" },
            { "<leader>fr", cmd("Telescope oldfiles"),                  desc = "find recent files" },
            { "<leader>fg", cmd("Telescope live_grep"),                 desc = "find in files (grep)" },
            { "<leader>fs", cmd("Telescope grep_string"),               desc = "grep string in cwd" },
            { "<leader>fl", cmd("Telescope live_grep_args"),            desc = "find in files (grep with args)" },
            { "<leader>fh", cmd("Telescope help_tags"),                 desc = "help tags" },
            { "<leader>fz", cmd("Telescope current_buffer_fuzzy_find"), desc = "fuzzy search (current buffer)" },
            { "<leader>:",  cmd("Telescope commands"),                  desc = "plugin/user commands" },
            { "<leader>f:", cmd("Telescope commands_history"),          desc = "commands history" },
            { "<leader>fH", cmd("Telescope search_history"),            desc = "search history" },
            { "<leader>fd", cmd("Telescope diagnostics"),               desc = "search history" },
            { "<leader>fa", cmd("Telescope autocommands"),              desc = "Autocommands" },
            { "<leader>fv", cmd("Telescope vim_options"),               desc = "Options" },
            { "<leader>fm", cmd("Telescope marks"),                     desc = "marks and their value" },
            { "<leader>fM", cmd("Telescope man_pages"),                 desc = "man pages" },
            { "<leader>fR", cmd("Telescope registers"),                 desc = "Registers" },
            { "<leader>fT", cmd("Telescope tags"),                      desc = "tags (cwd)" },
            { "<leader>ft", cmd("Telescope current_buffer_tags"),       desc = "tags (current buf)" },

            -- git
            { "<leader>gf", cmd("Telescope git_files"),                 desc = "git files 🔭" },
            { "<leader>gC", cmd("Telescope git_files"),                 desc = "git commits 🔭" },
            { "<leader>gb", cmd("Telescope git_branches"),              desc = "git branches 🔭" },
            { "<leader>gs", cmd("Telescope git_status"),                desc = "git status 🔭" },

            -- Misc
            { "<leader>fB", cmd("Telescope builtin theme=dropdown"),    desc = "builtins 🔭" },
            {
                "<leader>f.",
                function()
                    require("telescope.builtin").find_files({
                        prompt_title = "Neovim Config",
                        search_dirs = { vim.fn.stdpath("config") },
                    })
                end,
                desc = "Find Files (Neovim Config)",
            },
        }
    end,
}
