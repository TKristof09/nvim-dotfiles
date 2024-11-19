require'nvim-treesitter.configs'.setup {
    ensure_installed = {  "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
    highlight = {
        enable = true,
        disable = {"c", "rust"},
        additional_vim_regex_highlighting = false,
    },
    indent = {
        disable = {"c", "cpp", "rust", "ocaml", "ocaml_interface"},
        enable = true,
    },
}

vim.treesitter.language.register("ocaml_interface", "ocaml.interface")
vim.treesitter.language.register("menhir", "ocaml.menhir")
vim.treesitter.language.register("cram", "ocaml.cram")
vim.treesitter.language.register("ocamllex", "ocaml.ocamllex")
