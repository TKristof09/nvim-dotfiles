vim.cmd("colorscheme monokai")
require("config.options")
require("config.keybindings")
require("config.autocommands")
require("config.qf")
require("config.lazy")

vim.filetype.add {
    extension = {
        mli = "ocaml.interface",
        mly = "ocaml.menhir",
        mll = "ocaml.ocamllex",
        mlx = "ocaml",
        t = "ocaml.cram",
    },
}

-- workaround https://github.com/neovim/neovim/issues/31675
vim.hl = vim.highlight
