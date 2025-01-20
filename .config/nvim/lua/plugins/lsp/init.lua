return {
    {
        "neovim/nvim-lspconfig",
        cmd = "LspInfo",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            -- { "folke/neoconf.nvim", cmd = "Neoconf", c"nfig = true },
            { "folke/neodev.nvim", opts = { pathStrict = true } },
            "williamboman/mason-lspconfig.nvim",
            "williamboman/mason.nvim",
        },
        opts = {
            format_notify = true,
            -- LSP Server Settings
            servers = {
                bashls = {
                    settings = {
                        bashIde = {
                            backgroundAnalysisMaxFiles = 0,
                            -- explainshellEndpoint = "http://localhost:5000", --TODO: i need to figure this out
                        },
                    },
                },
                dockerls = {},
                docker_compose_language_service = {},
                -- function()
                --     return {
                --         root_dir = require("lspconfig").util.root_pattern("docker-compose.yml"),
                --         filetypes = { "yaml", "dockerfile" },
                --     }
                -- end,
                gopls = {
                    settings = {
                        gopls = {
                            gofumpt = true,
                            usePlaceholders = true,
                            analyses = {
                                nilness = true,
                                shadow = true,
                                unusedparams = true,
                                unusewrites = true,
                            },
                            hints = {
                                assignVariableTypes = true,
                                compositeLiteralFields = true,
                                compositeLiteralTypes = true,
                                constantValues = true,
                                functionTypeParameters = true,
                                parameterNames = true,
                                rangeVariableTypes = true,
                            },
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
                                ignoreSubmodules = true, -- Don't analyze code from submodules
                            },
                            semantic = { -- test
                                annotation = false,
                            },
                            completion = {
                                callSnippet = "Replace",
                                keywordSnippet = "Replace",
                                displayContext = 4,
                            },
                            codeLense = { enable = true },
                            diagnostics = {
                                globals = { "vim" },
                                enable = false,
                            },
                            format = {
                                -- enable = false,
                                defaultConfig = {
                                    indent_style = "space",
                                    indent_size = "4",
                                    continuation_indent_size = "4",
                                    align_array_table = "none",
                                },
                            },
                            hint = {
                                enable = true,
                                setType = true,
                                paramType = true,
                                arrayIndex = "Disable",
                                -- paramName = 'Disable',
                            },
                            telemetry = { enable = false },
                        },
                    },
                },
                marksman = {},
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
                                autoSearchPaths = true,
                                diagnosticMode = "workspace",
                                indexing = true,
                                reportUnusedImport = true,
                                typeCheckingMode = "off",
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
                --[[ rust_analyzer = {
                    settings = {
                        ["rust-analyzer"] = {
                            procMacro = { enable = true },
                            cargo = { allFeatures = true },
                            -- cmd = { "rustup", "run", "stable", "rust-analyzer" },
                            checkOnSave = {
                                command = "clippy",
                                extraArgs = { "--no-deps" },
                            },
                        },
                    },
                }, ]]
                ruff_lsp = {
                    init_options = {
                        settings = {
                            args = { "--line-length=120", "--no-cache" }, -- Any extra CLI arguments for `ruff` go here.
                        },
                    },
                    -- REF: https://github.com/astral-sh/ruff-lsp/issues/119#issuecomment-1595628355
                    commands = {
                        RuffAutofix = {
                            function()
                                vim.lsp.buf.execute_command({
                                    command = "ruff.applyAutofix",
                                    arguments = {
                                        { uri = vim.uri_from_bufnr(0) },
                                    },
                                })
                            end,
                            description = "Ruff: Fix all auto-fixable problems",
                        },
                        RuffOrganizeImports = {
                            function()
                                vim.lsp.buf.execute_command({
                                    command = "ruff.applyOrganizeImports",
                                    arguments = {
                                        { uri = vim.uri_from_bufnr(0) },
                                    },
                                })
                            end,
                            description = "Ruff: Format imports",
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
                sqls ={
                    settings = {
                        sqls = {
                            connections = {
                                {
                                    driver = 'mysql',
                                    dataSourceName = 'root:root@tcp(127.0.0.1:13306)/world',
                                },
                                {
                                    driver = 'postgresql',
                                    dataSourceName = 'host=127.0.0.1 port=15432 user=postgres password=mysecretpassword1234 dbname=dvdrental sslmode=disable',
                                },
                            },
                        },
                    },
                },
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
                yamlls = {
                    on_new_config = function(new_config)
                        new_config.settings.yaml.schemas = new_config.settings.yaml.schemas or {}
                        vim.list_extend(new_config.settings.yaml.schemas, require("schemastore").yaml.schemas())
                    end,
                    settings = {
                        redhat = { telemetry = { enabled = false } },
                        yaml = {
                            hover = true,
                            completion = true,
                            customTags = {
                                -- Partial Cloudformation support
                                -- See: https://github.com/redhat-developer/yaml-language-server/issues/77#issuecomment-511768680
                                "!FindInMap mappping",
                                "!FindInMap scalar",
                                "!FindInMap sequence",
                                "!GetAtt mapping",
                                "!GetAtt scalar",
                                "!GetAtt sequence",
                                "!GetAZs scalar",
                                "!GetAZs mapping",
                                "!GetAZs sequence",
                                "!ImportValue mapping",
                                "!ImportValue scalar",
                                "!ImportValue sequence",
                                "!Ref mapping",
                                "!Ref scalar",
                                "!Select scalar",
                                "!Select mapping",
                                "!Select sequence",
                                "!Split scalar",
                                "!Ref sequence",
                                "!Sub mapping",
                                "!Sub scalar",
                                "!Sub sequence",
                            },
                            schemaStore = {
                                -- Must disable built-in schemaStore support to use
                                -- schemas from SchemaStore.nvim plugin
                                enable = false,
                                -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                                url = "",
                            },
                            keyOrdering = false,
                            format = {
                                enable = true,
                            },
                            -- schemas = require("schemastore").yaml.schemas(),
                        },
                    },
                },
            },
        },

        config = function(_, opts)
            local util = require("utils")
            local lsp_util = require("plugins.lsp.util")

            -- use rounded boarder for LspInfo command
            require("lspconfig.ui.windows").default_options = { border = "rounded" }

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
            local lsp_servers = mason and vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package) or {}

            local ensure_installed = {}
            for server, server_opts in ipairs(servers) do
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

            -- code action light bulb
            require("plugins.lsp.lightbulb")
        end,
    },
    { "b0o/SchemaStore.nvim" },
}
