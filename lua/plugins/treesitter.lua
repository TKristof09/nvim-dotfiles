return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ":TSUpdate",
        opts = {
            ensure_installed = { "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
            highlight = {
                enable = true,
                disable = { "c", "rust" },
                additional_vim_regex_highlighting = false,
            },
            indent = {
                disable = { "c", "cpp", "rust", "ocaml", "ocaml_interface" },
                enable = true,
            },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)

            vim.treesitter.language.register("ocaml_interface", "ocaml.interface")
            vim.treesitter.language.register("menhir", "ocaml.menhir")
            vim.treesitter.language.register("cram", "ocaml.cram")
            vim.treesitter.language.register("ocamllex", "ocaml.ocamllex")
        end,

        lazy = true,
        event = "VeryLazy"
    }
}
