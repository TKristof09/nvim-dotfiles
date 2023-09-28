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

    use {"nvim-telescope/telescope.nvim", tag = "0.1.0"}
    use {'nvim-telescope/telescope-ui-select.nvim' }

    use "nvim-tree/nvim-tree.lua"
    use "nvim-tree/nvim-web-devicons"
    --use {"akinsho/bufferline.nvim", tag = "v3.*" }


    use "ap/vim-css-color"

    use "folke/which-key.nvim"

    use "nvim-lualine/lualine.nvim"

    use "numToStr/Comment.nvim"

    use "tikhomirov/vim-glsl"

    use "lukas-reineke/indent-blankline.nvim"

    use "zbirenbaum/copilot.lua"

    use "chrisgrieser/nvim-spider"

    --use "windwp/nvim-autopairs"

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
            {'L3MON4D3/LuaSnip'},     -- Required
            {"ray-x/lsp_signature.nvim"},
            {"onsails/lspkind.nvim"}
        }
    }

    use {'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async'}


    use "TKristof09/vim-vulkan-ref"

end
)
