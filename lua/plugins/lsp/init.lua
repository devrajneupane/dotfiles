--TODO: simrat39/symbols-outline.nvim
return {
    {
        "neovim/nvim-lspconfig",
        cmd = "LspInfo",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
            {
                "folke/neodev.nvim",
                opts = {
                    library = { plugins = {"nvim-dap-ui", "neotest"}, types = true }
                },
            },
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "lvimuser/lsp-inlayhints.nvim",
        },

        opts = {
            format_notify = true,
            -- LSP Server Settings
            servers = {
                bashls = {
                    settings = {
                        bashIde = {
                            backgroundAnalysisMaxFiles = 0,
                        },
                    },
                },
                jsonls = {
                    -- lazy-load schemastore
                    on_new_config = function(new_config)
                        new_config.settings.json.schemas = new_config.settings.json.schemas or {}
                        vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
                    end,
                    settings = {
                        json = {
                            -- schemas = require('schemastore').json.schemas(),
                            format = { enable = true },
                            validate = { enable = true },
                        },
                    },
                },
                lua_ls = {
                    -- single_file_support = true,
                    settings = {
                        Lua = {
                            runtime = { version = "LuaJIT" },
                            workspace = {
                                checkThirdParty = false,
                                library = vim.api.nvim_get_runtime_file("", true),
                            },
                            completion = {
                                workspaceWord = true,
                                callSnippet = "Both",
                            },
                            codeLense = { enable = true },
                            diagnostics = { globals = { "vim" } },
                            format = {
                                -- enable = false,
                                defaultConfig = {
                                    indent_style = "space",
                                    indent_size = "2",
                                    continuation_indent_size = "2",
                                    align_array_table = "none",
                                },
                            },
                            telemetry = { enable = false },
                        },
                    },
                },
                marksman = {},
                tsserver = {
                    root_dir = function(...)
                        return require("lspconfig.util").root_pattern(".git")(...)
                    end,
                    single_file_support = false,
                    settings = {
                        typescript = {
                            inlayHints = {
                                includeInlayParameterNameHints = "literal",
                                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                                includeInlayFunctionParameterTypeHints = true,
                                includeInlayVariableTypeHints = false,
                                includeInlayPropertyDeclarationTypeHints = true,
                                includeInlayFunctionLikeReturnTypeHints = true,
                                includeInlayEnumMemberValueHints = true,
                            },
                        },
                        javascript = {
                            inlayHints = {
                                includeInlayParameterNameHints = "all",
                                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                                includeInlayFunctionParameterTypeHints = true,
                                includeInlayVariableTypeHints = true,
                                includeInlayPropertyDeclarationTypeHints = true,
                                includeInlayFunctionLikeReturnTypeHints = true,
                                includeInlayEnumMemberValueHints = true,
                            },
                        },
                        completions = { CompleteFunctionCalls = true },
                    },
                },
                rust_analyzer = {
                    settings = {
                        ["rust-analyzer"] = {
                            cargo = { allFeatures = true },
                            cmd = { "rustup", "run", "stable", "rust-analyzer" },
                        },
                    },
                },
                --[[ ruff_lsp = {
                on_attach = function(client, _)
                    -- Disable hover in favor of Pyright
                    client.server_capabilities.hover = false
                end,
                init_options = {
                    settings = {
                        args = {}, -- Any extra CLI arguments for `ruff` go here.
                        path = { "python" },
                    },
                },
            }, ]]
                pyright = {
                    settings = {
                        pyright = {
                            disableOrganizeImports = true,
                            reportMissingImports = false,
                            reportGeneralTypeIssues = false,
                            reportMissingTypeStubs = false,
                        },
                        python = {
                            analysis = {
                                typeCheckingMode = "off",
                                autoSearchPaths = true,
                                useLibraryCodeForTypes = true,
                            },
                            telemetry = {
                                enable = false,
                            },
                        },
                        telemetry = {
                            telemetryLevel = "off",
                        },
                    },
                },
                solargraph = {
                    settings = {
                        ruby = {
                            autoformat = true,
                            formatting = true,
                            diagnostics = true,
                        },
                    },
                },
                yamlls = {
                    settings = {
                        yaml = {
                            hover = true,
                            completion = true,
                            validate = true,
                            keyOrdering = false,
                            -- schemas = require("schemastore").yaml.schemas(),
                        },
                    },
                },
            },
        },

        config = function(_, opts)
            local util = require("utils")
            local lsp_util = require("plugins.lsp.util")

            -- setup keymaps
            util.on_attach(function(client, buffer)
                lsp_util.on_attach(client, buffer)
            end)

            -- diagnostics
            lsp_util.setup_diagnostics()

            local servers = opts.servers

            local function setup(server)
                local server_opts = vim.tbl_deep_extend("force", {
                    capabilities = vim.deepcopy(lsp_util.capabilities),
                }, servers[server] or {})
                require("lspconfig")[server].setup(server_opts)
            end

            -- get all the servers that are available thourgh mason-lspconfig
            local mason, mlsp = pcall(require, "mason-lspconfig")
            local lsp_servers = {}
            if mason then
                lsp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
            end

            local ensure_installed = {}
            for server, server_opts in pairs(servers) do
                if server_opts then
                    -- run manual setup  for a server that cannot be installed with mason-lspconfig
                    if server_opts.mason == false or not vim.tbl_contains(lsp_servers, server) then
                        setup(server)
                    else
                        ensure_installed[#ensure_installed + 1] = server
                    end
                end
            end

            if mason then
                mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup } })
            end
        end,
    },
    { "b0o/SchemaStore.nvim" },
}
