require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
        disable = {"c", "rust"},
        additional_vim_regex_highlighting = false,
    },
    indent = {
        disable = {"c", "cpp", "rust"},
        enable = true,
    },
}