require("config.monokai") -- need to be before lualine for the auto theme to work
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
