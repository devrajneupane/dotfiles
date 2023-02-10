local lsp = require('lsp-zero')
lsp.preset('recommended')

lsp.ensure_installed({
    'ruff_lsp',
    'rust_analyzer',
    'tsserver',
    'eslint',
    'sumneko_lua',
    "jsonls", -- for json
    "yamlls",
    "bashls",
    "dockerls",
    'marksman',
    'html',
    'cssls',
    "texlab",
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.select }

lsp.setup_nvim_cmp({
    mapping = lsp.defaults.cmp_mappings({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
    })

})

lsp.set_preferences({
    suggest_lsp_servers = true,
    sign_icons = {
        error = '✗', --' ',
        warn = '', --'',
        hint = '󰌶', --'',
        info = '', --''
    }
})

lsp.configure(
    'tsserver', {
        on_attach = function(client, bufnr)
            print('hello' .. client .. 'tsserver attach for' .. bufnr)
        end,
        settings = {
            completions = {
                completeFunctionCalls = true
            }
        }
    },
    'texlab', {
        on_attach = function(client, bufnr)
            -- code
        end,

        settings = {
            auxDirectory = "build/pdf",
            chktex = {
                onEdit = true
            },
            build = {
                executable = "latexmk",
                forwardSearchAfter = false,
                onSave = false
            }
        }
    }
)

lsp.setup()

local null_ls = require('null-ls')
local null_opts = lsp.build_options('null-ls', {})

null_ls.setup({
    on_attach = function(client, bufnr)
        null_opts.on_attach(client, bufnr)
        ---
        -- you can add other stuff here....
        ---
    end,
    sources = {
        -- Replace these with the tools you want to install
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.formatting.stylua,
    }
})

-- See mason-null-ls.nvim's documentation for more details:
-- https://github.com/jay-babu/mason-null-ls.nvim#setup
require('mason-null-ls').setup({
    ensure_installed = nil,
    automatic_installation = true,
    automatic_setup = false,
})
