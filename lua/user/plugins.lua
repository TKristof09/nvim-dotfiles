local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()
-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
augroup packer_user_config
autocmd!
autocmd BufWritePost plugins.lua source <afile> | PackerSync
augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init({
    display = {
        open_fn = function()
            return require("packer.util").float({ border = "rounded" })
        end,
    },
})
return packer.startup(function(use)
    use "wbthomason/packer.nvim" -- have packer update itself
    use "nvim-lua/plenary.nvim"

    use {"nvim-telescope/telescope.nvim"}
    use {'nvim-telescope/telescope-ui-select.nvim' }

    use "nvim-tree/nvim-tree.lua"
    use "nvim-tree/nvim-web-devicons"
-- lazy.nvim
    use {
        "folke/noice.nvim",

        requires = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            "rcarriga/nvim-notify",
        }
    }
    use {
        'mrded/nvim-lsp-notify',
        requires = { 'rcarriga/nvim-notify' },
    }
    use "ap/vim-css-color"

    use "folke/which-key.nvim"

    use "nvim-lualine/lualine.nvim"

    use "numToStr/Comment.nvim"

    use "tikhomirov/vim-glsl"

    use "lukas-reineke/indent-blankline.nvim"

    use "zbirenbaum/copilot.lua"

    use "chrisgrieser/nvim-spider"

    use "folke/flash.nvim"

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},             -- Required
            {'williamboman/mason.nvim'},           -- Optional
            {'williamboman/mason-lspconfig.nvim'}, -- Optional

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},     -- Required
            {'hrsh7th/cmp-nvim-lsp'}, -- Required
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'hrsh7th/cmp-nvim-lua'},
            {'hrsh7th/cmp-cmdline'},
            {'L3MON4D3/LuaSnip'},     -- Required
            {"ray-x/lsp_signature.nvim"},
            {"onsails/lspkind.nvim"}
        }
    }
    use {
        "SmiteshP/nvim-navic",
        requires = "neovim/nvim-lspconfig"
    }

    use {'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async'}

    use {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        requires = { {"nvim-lua/plenary.nvim"} }
    }

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        commit="9d39f00a9559cf3505d73b486c0b8055a6db4215",
        lock = true,
    }
    use "HiPhish/rainbow-delimiters.nvim"
    use "mbbill/undotree"

    use "TKristof09/vim-vulkan-ref"
    use "ThePrimeagen/vim-be-good"
end
)
