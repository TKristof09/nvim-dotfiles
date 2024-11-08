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
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' }
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

    use 'brenoprata10/nvim-highlight-colors'

    use "folke/which-key.nvim"

    use "nvim-lualine/lualine.nvim"

    use "numToStr/Comment.nvim"

    use "tikhomirov/vim-glsl"

    use "lukas-reineke/indent-blankline.nvim"

    use "zbirenbaum/copilot.lua"

    use "chrisgrieser/nvim-spider"

    use "folke/flash.nvim"

    -- LSP Support
    use 'neovim/nvim-lspconfig'

    use 'williamboman/mason.nvim'

    use 'williamboman/mason-lspconfig.nvim'


    -- Autocompletion
    use 'hrsh7th/nvim-cmp'

    use 'hrsh7th/cmp-nvim-lsp'

    use 'hrsh7th/cmp-buffer'

    use 'hrsh7th/cmp-path'

    use 'hrsh7th/cmp-nvim-lua'

    use 'hrsh7th/cmp-cmdline'


    use "onsails/lspkind.nvim"

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

    use('mrjones2014/smart-splits.nvim')

    use "TKristof09/vim-vulkan-ref"
    use "ThePrimeagen/vim-be-good"
end
)
