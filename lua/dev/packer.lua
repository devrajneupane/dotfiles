-- Bootstrap packer.
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

-- Setup before plugins are loaded.
vim.g.ale_disable_lsp = 1

-- Load different plugins.
return require 'packer'.startup({ function(use)

    -- Package manager.
    use 'wbthomason/packer.nvim'

    -- Lua packages.
    use_rocks 'lua-cjson'
    use_rocks 'luasocket'
    use_rocks 'luasec'

    -- Telecope.
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            'nvim-lua/popup.nvim',
            'nvim-lua/plenary.nvim',
        }
    }

    -- General UI.
    use 'nvim-tree/nvim-web-devicons'
    use 'j-hui/fidget.nvim'
    use 'akinsho/toggleterm.nvim'
    use 'rcarriga/nvim-notify'
    use {
        'nvim-lualine/lualine.nvim',
        requires = {
            'kyazdani42/nvim-web-devicons',
            opt = true
        }
    }
    use 'glepnir/dashboard-nvim'
    use {
        'romgrk/barbar.nvim',
        requires = "nvim-tree/nvim-web-devicons",
    }
    use {
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
    }
    use {
        "folke/noice.nvim",
        requires = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify"
        }
    }
    use({
        "Pocco81/true-zen.nvim",
        config = function()
            require("true-zen").setup {
            }
        end,
    })

    -- todo comments
    use {
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
    }

    -- Programming experience.
    use 'lukas-reineke/indent-blankline.nvim'
    use 'mg979/vim-visual-multi'
    use 'RRethy/vim-illuminate'
    use 'windwp/nvim-autopairs'
    use 'preservim/nerdcommenter'
    use 'tpope/vim-commentary'
    use 'tpope/vim-surround'
    use 'mbbill/undotree'
    use 'brooth/far.vim'
    use {
        'ggandor/leap.nvim',
        requires = {
            'tpope/vim-repeat'
        }
    }

    -- Git.
    use 'tpope/vim-fugitive'
    use 'lewis6991/gitsigns.nvim'
    use 'sindrets/diffview.nvim'
    use 'akinsho/git-conflict.nvim'
    use 'ThePrimeagen/git-worktree.nvim'

    -- Neovim helpers.
    use 'folke/which-key.nvim'
    use 'sudormrfbin/cheatsheet.nvim'
    use { 'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async' }

    -- File Explorer.
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons'
        },
    }

    -- General language.
    use {
        'nvim-treesitter/nvim-treesitter',
        requires = {
            'nvim-treesitter/nvim-treesitter-textobjects',
            'nvim-treesitter/playground'
        },
        run = ':TSUpdate'
    }
    use('nvim-treesitter/playground')

    -- LSP
    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            -- Snippet Collection (Optional)
            { 'rafamadriz/friendly-snippets' },

            -- Linter (Optional)
            "jose-elias-alvarez/null-ls.nvim",
            "jay-babu/mason-null-ls.nvim",
        }
    }

    -- Language specific.
    use 'lervag/vimtex'
    use({ "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    })

    -- Theme
    use 'AlexvZyl/nordic.nvim'

    -- Misc
    use 'eandrju/cellular-automaton.nvim'
    use 'kwakzalver/duckytype.nvim'


    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end

end,

    config = {
        display = {
            -- Display packer window as floating.
            open_fn = function()
                return require 'packer.util'.float { border = 'rounded' }
            end
        }
    }
})
