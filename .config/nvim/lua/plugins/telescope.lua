---@type LazySpec
return {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            config = function() require("telescope").load_extension("fzf") end,
        },
    },
    opts = function()
        local builtin = require("telescope.builtin")
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")
        local action_layout = require("telescope.actions.layout")

        local symbols_source = function(source)
            local line = action_state.get_current_line()
            builtin.symbols({
                prompt_title = string.format("%s(%s)", "Symbols", source),
                sources = { source },
                default_text = line,
            })
        end

        return {
            defaults = {
                prompt_prefix = "󰭎 ",
                multi_icon = "¤ ",
                result_title = false,
                layout_strategy = "flex",
                sorting_strategy = "ascending",
                selection_caret = " ",
                path_display = { filename_first = { reverse_directories = false } },
                dynamic_preview_title = true,
                cache_picker = { num_pickers = 5 },
                hisotry = { cycle_wrap = true },
                cycle_layout_list = { "horizontal", "vertical", "center", "cursor", "bottom_pane" },
                preview = {
                    msg_bg_fillchar = " ", -- character to fill background of unpreviewable buffers with
                    filesize_limit = 5, -- disable preview for file greater that 5MB
                },
                set_env = { COLORTERM = "truecolor" },
                vimgrep_arguments = { "rg", "--color=never", "--vimgrep" },
                layout_config = {
                    flex = {
                        -- move to horizontal mode after 120 cols
                        flip_columns = 120,
                    },
                    horizontal = {
                        preview_width = 0.55,
                    },
                    prompt_position = "top",
                },
                mappings = {
                    i = {
                        ["<C-u>"] = false, -- disabled for backward-kill-line
                        ["<C-o>"] = function(...) require("trouble.sources.telescope").open(...) end,

                        ["<S-TAB>"] = {
                            -- https://github.com/nvim-telescope/telescope.nvim/issues/2778#issuecomment-2202572413
                            function(prompt_bufnr)
                                local picker = action_state.get_current_picker(prompt_bufnr)
                                local prompt_win = picker.prompt_win
                                local previewer = picker.previewer
                                local winid = previewer.state.winid
                                local bufnr = previewer.state.bufnr
                                vim.keymap.set(
                                    "n",
                                    "<S-TAB>",
                                    function()
                                        vim.cmd(
                                            string.format("noautocmd lua vim.api.nvim_set_current_win(%s)", prompt_win)
                                        )
                                    end,
                                    { buffer = bufnr }
                                )
                                vim.cmd(string.format("noautocmd lua vim.api.nvim_set_current_win(%s)", winid))
                            end,
                            type = "action",
                            opts = { desc = "switch focus to previewer" },
                        },
                        ["<M-u>"] = {
                            function(prompt_bufnr)
                                local current_picker =
                                    require("telescope.actions.state").get_current_picker(prompt_bufnr)
                                local cwd = tostring(current_picker.cwd or vim.uv.cwd())
                                local parent_dir = vim.fs.dirname(cwd)

                                actions.close(prompt_bufnr)
                                builtin.find_files({
                                    cwd = parent_dir,
                                    prompt_title = vim.fs.basename(parent_dir),
                                })
                            end,
                            type = "action",
                            opts = { desc = "cwd up" },
                        },
                        ["<C-y>"] = {
                            function()
                                local entry = action_state.get_selected_entry()
                                vim.fn.setreg("+", entry.ordinal)
                            end,
                            type = "action",
                            opts = { desc = "yank current entry" },
                        },
                        ["<M-o>"] = {
                            function(prompt_bufnr)
                                local path = action_state.get_selected_entry().value
                                local picker = action_state.get_current_picker(prompt_bufnr)
                                local parent = picker._selection_entry.cwd
                                vim.ui.open(parent .. "/" .. path)
                                actions.close(prompt_bufnr)
                            end,
                            type = "action",
                            opts = { desc = "open with system default handler" },
                        },

                        ["<M-p>"] = action_layout.toggle_preview,
                        ["<M-m>"] = action_layout.toggle_mirror,
                        ["<M-t>"] = action_layout.toggle_prompt_position, -- why not :)
                        ["<M-l>"] = action_layout.cycle_layout_next,
                        ["<M-h>"] = action_layout.cycle_layout_prev,

                        ["<M-j>"] = actions.move_selection_worse,
                        ["<M-k>"] = actions.move_selection_better,

                        ["<C-a>"] = actions.toggle_all,
                        ["<C-s>"] = actions.select_horizontal,

                        --- currently only works for git_commits picker
                        ["<M-s>"] = actions.cycle_previewers_next,
                        ["<M-a>"] = actions.cycle_previewers_prev,

                        -- prompt history
                        ["<C-j>"] = actions.cycle_history_next,
                        ["<C-k>"] = actions.cycle_history_prev,

                        -- scroll result window
                        ["<C-b>"] = actions.results_scrolling_up,
                        ["<C-f>"] = actions.results_scrolling_down,
                        ["<C-h>"] = actions.results_scrolling_left,
                        ["<C-l>"] = actions.results_scrolling_right,

                        -- scroll preview window
                        ["<C-e>"] = actions.preview_scrolling_up,
                        ["<M-y>"] = actions.preview_scrolling_left,
                        ["<M-e>"] = actions.preview_scrolling_right,

                        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                        ["<M-q>"] = false,
                        ["<C-c>"] = function() vim.cmd([[stopinsert]]) end,

                        ["<M-d>"] = actions.select_drop,
                        ["<esc>"] = actions.close,
                        ["<C-_>"] = require("telescope.actions.generate").which_key({
                            separator = "│",
                            keybind_width = 10,
                            line_padding = 0,
                            border_hl = "Comment",
                        }),
                    },
                    n = {
                        ["<CR>"] = actions.select_default + actions.center,
                        ["q"] = actions.close,
                        ["<C-o>"] = function(...) require("trouble.sources.telescope").open(...) end,
                        ["<M-p>"] = action_layout.toggle_preview,
                    },
                },
            },
            pickers = {
                buffers = {
                    sort_lastused = true,
                    sort_mru = true,
                    ignore_current_buffer = true,
                    theme = "dropdown",
                    previewer = false,
                    mappings = {
                        i = {
                            ["<c-d>"] = actions.delete_buffer,
                            ["<CR>"] = function(prompt_bufnr)
                                local current_picker = action_state.get_current_picker(prompt_bufnr)
                                current_picker.get_selection_window = function(_, entry)
                                    local wins = vim.iter(vim.api.nvim_tabpage_list_wins(0))
                                        :filter(function(w) return vim.api.nvim_win_get_buf(w) == entry.bufnr end)
                                        :totable()
                                    return #wins == 1 and wins[1] or 0
                                end
                                actions.select_default(prompt_bufnr)
                            end,
                        },
                        n = { ["<c-d>"] = actions.delete_buffer },
                    },
                },
                builtin = {
                    include_extension = true,
                    previewer = false,
                    theme = "dropdown",
                    use_default_opts = true,
                },
                colorscheme = {
                    prompt_prefix = "  ",
                    enable_preview = true,
                    previewer = false, -- toggle previewer for live preview
                    theme = "dropdown",
                },
                command_history = {
                    prompt_prefix = "  ",
                    theme = "dropdown",
                },
                current_buffer_fuzzy_find = {
                    -- theme = "dropdown",
                    layout_strategy = "center",
                    previewer = false,
                },
                diagnostics = {
                    previewer = false,
                    layout_strategy = "center",
                    sort_by = "severity",
                },
                find_files = {
                    hidden = true,
                    -- find_command = { "fd", "--type=file", "--type=symlink" },
                    find_command = {
                        "rg",
                        "--color=never",
                        "--follow",
                        "--files",
                        "--sortr=modified", -- costs performance as it disables multithreading
                        "--ignore-file=" .. vim.env.XDG_CONFIG_HOME .. "/ripgrep/ignore",
                    },
                    mappings = {
                        i = {
                            ["<M-i>"] = {
                                function()
                                    local line = action_state.get_current_line()
                                    builtin.find_files({ no_ignore = true, default_text = line })
                                end,
                                type = "action",
                                opts = { desc = "toggle ignored files" },
                            },
                            ["<M-.>"] = {
                                function()
                                    local line = action_state.get_current_line()
                                    builtin.find_files({ hidden = true, default_text = line })
                                end,
                                type = "action",
                                opts = { desc = "toggle hidden files" },
                            },
                        },
                    },
                },
                filetypes = {
                    prompt_prefix = " ",
                    theme = "dropdown",
                },
                git_commits = {
                    -- git_command = { "git", "log", "--pretty=format:%h %s - (%cr) <%an>" },
                    -- previewer = require("telescope.previewers").new_termopen_previewer({
                    --     get_command = function(entry)
                    --         return {
                    --             "git",
                    --             -- "-c",
                    --             -- "core.pager=delta",
                    --             -- "-c",
                    --             -- "delta.side-by-side=false",
                    --             "diff",
                    --             entry.value .. "^!",
                    --         }
                    --     end,
                    -- }),
                    mappings = {
                        i = { ["<CR>"] = false }, -- let's not checkout accidently
                        n = { ["<CR>"] = false },
                    },
                },
                git_bcommits = {
                    prompt_prefix = "󰊢 ",
                    layout_config = { horizontal = { height = 0.99 } },
                    git_command = { "git", "log", "--pretty=%h %s\t%cr" }, -- add commit time (%cr)
                    mappings = {
                        i = { ["<CR>"] = false }, -- lets not checkout accidently
                        n = { ["<CR>"] = false },
                    },
                },
                -- TODO: add shortcut to toggle untracked files in `builtin.git_files`
                git_branches = {
                    prompt_prefix = " ",
                    show_remote_tracking_branches = true,
                    previewer = false,
                    theme = "dropdown",
                    mappings = {
                        i = {
                            ["<C-e>"] = actions.git_rename_branch,
                            -- This one is mapped by default but we override it above so remapping again
                            ["<C-a>"] = actions.git_create_branch,
                        },
                    },
                },
                git_stash = {
                    prompt_prefix = "󰊢 ",
                    theme = "dropdown",
                },
                grep_string = {
                    use_regex = true,
                },
                highlights = {
                    prompt_prefix = "  ",
                    layout_config = { horizontal = { preview_width = { 0.7, min = 20 } } },
                },
                jumplist = {
                    -- previewer = false,
                    layout_strategy = "center",
                    path_display = { "filename" },
                },
                keymaps = {
                    prompt_prefix = "  ",
                    modes = { "n", "i", "c", "x", "o", "t" },
                    show_plug = false, -- do not show keympas whose lhs contains "<Plug>"
                    lhs_filter = function(lhs) return not lhs:find("Þ") end, -- remove which-key mappings
                    layout_strategy = "center",
                    mappings = {
                        i = {
                            ["<M-b>"] = function()
                                local line = action_state.get_current_line()
                                builtin.keymaps({ only_buf = true, default_text = line })
                            end,
                        },
                    },
                },
                live_grep = {
                    prompt_prefix = "  ",
                    disable_coordinates = true, -- don't show Line & row number
                    mappings = {
                        i = { ["<C-f>"] = actions.to_fuzzy_refine },
                        n = { ["<C-f>"] = actions.to_fuzzy_refine },
                    },
                },
                lsp_document_symbols = { prompt_prefix = "󰒕 " },
                lsp_references = {
                    prompt_prefix = " ",
                    include_declaration = false,
                    trim_text = true,
                    reuse_win = true, -- TODO: will `set switchbuf=useopen` affects this?
                    layout_strategy = "center",
                },
                lsp_definitions = {
                    previewer = false,
                    reuse_win = true,
                    layout_strategy = "center",
                },
                man_pages = {
                    sections = { "ALL" }, -- search in all sections
                    layout_strategy = "center",
                },
                marks = {
                    previewer = false,
                    prompt_prefix = "󱝴 ",
                    theme = "dropdown",
                    mappings = {
                        i = {
                            ["<C-d>"] = actions.delete_mark,
                        },
                    },
                },
                oldfiles = {
                    mappings = {
                        i = {
                            --- Show only files in the cwd
                            ["<C-c>"] = function()
                                local line = action_state.get_current_line()
                                builtin.oldfiles({ default_text = line, only_cwd = true })
                            end,
                        },
                    },
                },
                registers = { theme = "dropdown" },
                search_history = { theme = "dropdown" },
                symbols = {
                    prompt_prefix = " ",
                    theme = "dropdown",
                    sources = { "nerd", "misc" },
                    mappings = {
                        i = {
                            ["<M-a>"] = function() symbols_source("alt_fonts") end,
                            ["<M-e>"] = function() symbols_source("emoji") end,
                            ["<M-g>"] = function() symbols_source("gitmoji") end,
                            ["<M-j>"] = function() symbols_source("julia") end,
                            ["<M-k>"] = function() symbols_source("kaomoji") end,
                            ["<M-l>"] = function() symbols_source("latex") end,
                            ["<M-m>"] = function() symbols_source("math") end,
                            ["<M-n>"] = function() symbols_source("nerd") end,
                            ["<M-s>"] = function() symbols_source("misc") end,
                        },
                    },
                },
                vim_options = {
                    prompt_prefix = " ",
                    layout_strategy = "center",
                    mappings = {
                        i = {
                            ["<C-h>"] = {
                                function()
                                    local entry = action_state.get_selected_entry()
                                    builtin.help_tags({
                                        default_text = "'" .. entry.value.name .. "'",
                                    })
                                end,
                                type = "action",
                                opts = { desc = "show help info of current entry" },
                            },
                        },
                    },
                },
            },
            extensions = {
                fzf = {
                    fuzzy = true, -- false will only do exact matching
                    override_generic_sorter = true, -- override the generic sorter
                    override_file_sorter = true, -- override the file sorter
                    case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                },
            },
        }
    end,
    keys = {
        { "<leader>:", "<Cmd>Telescope commands<CR>", desc = "plugin/user commands" },
        { "<leader>f'", "<Cmd>Telescope marks<CR>", desc = "marks" },
        { "<leader>f;", "<Cmd>Telescope command_history<CR>", desc = "commands history" },
        { "<leader>fr", "<Cmd>Telescope resume<CR>", desc = "resume picker" },
        { '<leader>f"', "<Cmd>Telescope registers<CR>", desc = "registers" },
        { "<leader>fa", "<Cmd>Telescope autocommands<CR>", desc = "autocommands" },
        { "<leader>fb", "<Cmd>Telescope builtin<CR>", desc = "telescope builtins" },
        { "<leader>bb", "<Cmd>Telescope buffers<CR>", desc = "find buffers" },
        { "<leader>bf", "<Cmd>Telescope filetypes<CR>", desc = "filetypes" },
        { "<leader>fc", "<Cmd>Telescope colorscheme<CR>", desc = "colorschemes" },
        { "<leader>fd", "<Cmd>Telescope diagnostics<CR>", desc = "workspace diagnostics" },
        { "<leader>ff", "<Cmd>Telescope find_files<CR>", desc = "find files" },
        { "<leader>f/", "<Cmd>Telescope live_grep<CR>", desc = "live grep" },
        { "<leader>fh", "<Cmd>Telescope help_tags<CR>", desc = "help tags" },
        { "<leader>fj", "<Cmd>Telescope jumplist<CR>", desc = "jumplist" },
        { "<leader>fk", "<Cmd>Telescope keymaps<CR>", desc = "keymaps" },
        { "<leader>fm", "<Cmd>Telescope man_pages<CR>", desc = "man pages" },
        { "<leader>fq", "<Cmd>Telescope quickfixhistory<CR>", desc = "quickfix history" },
        { "<leader>fs", "<Cmd>Telescope symbols<CR>", desc = "symbols" },
        { "<M-s>", "<Cmd>Telescope symbols<CR>", mode = "i", desc = "symbols" },
        { "<leader>f.", "<Cmd>Telescope oldfiles<CR>", desc = "recent files" },
        { "<leader>fw", "<Cmd>Telescope grep_string<CR>", desc = "current word" },
        {
            "<leader>fW",
            function() require("telescope.builtin").grep_string({ search = vim.fn.expand("<cWORD>") }) end,
            desc = "current WORD",
        },
        { "<leader>/", "<Cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "search current buffer " },
        { "<leader>fo", "<Cmd>Telescope vim_options<CR>", desc = "vim options" },
        { "<leader><leader>", "<leader>ff", remap = true, desc = "find files" },
        { "<leader>sh", "<Cmd>Telescope search_history<CR>", desc = "search history" },
        { "<leader>sH", "<Cmd>Telescope highlights<CR>", desc = "highlights" },
        { "<leader>st", "<Cmd>Telescope treesitter<CR>", desc = "treesitter symbols" },
        { "<leader>sl", "<Cmd>Telescope lsp_document_symbols<CR>", desc = "lsp symbols" },
        { "<leader>sL", "<Cmd>Telescope lsp_dynamic_workspace_symbols<CR>", desc = "workspace symbols" },

        -- git
        { "<leader>gf", "<Cmd>Telescope git_files<CR>", desc = "files" },
        { "<leader>gC", "<Cmd>Telescope git_bcommits<CR>", desc = "bcommits" },
        { "<leader>gC", "<Cmd>Telescope git_bcommits_range<CR>", mode = "v", desc = "bcommits range" },
        { "<leader>gb", "<Cmd>Telescope git_branches<CR>", desc = "branches" },
        { "<leader>gc", "<Cmd>Telescope git_commits<CR>", desc = "commits" },
        { "<leader>gs", "<Cmd>Telescope git_status<CR>", desc = "status" },

        -- Misc
        {
            "<leader>s/",
            function()
                require("telescope.builtin").live_grep({
                    grep_open_files = true,
                })
            end,
            desc = "search in buffers",
        },
        {
            "<leader>s.",
            function()
                require("telescope.builtin").find_files({
                    cwd = vim.env.HOME,
                    prompt_title = "dotfiles",
                    find_command = {
                        "git",
                        "--git-dir",
                        vim.env.HOME .. "/Projects/dotfiles/",
                        "--work-tree",
                        vim.env.HOME,
                        "ls-files",
                        "--exclude-standard",
                        "--cached",
                    },
                })
            end,
            desc = "find dotfiles",
        },
        {
            "<leader>sp",
            function()
                require("telescope.builtin").find_files({
                    cwd = require("lazy.core.config").options.root,
                    prompt_title = "Plugin Files",
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
                    prompt_title = "Lazy Plugin Spec",
                    default_text = "/",
                    search_dirs = vim.tbl_values(files),
                })
            end,
            desc = "lazy plugin spec",
        },

        -- extensions
        {
            "<leader>fp",
            function() require("telescope").extensions.reload_plugin.reload_plugin() end,
            desc = "reload plugin",
        },
    },
}
