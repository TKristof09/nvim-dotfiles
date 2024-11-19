require("user.monokai") -- need to be before lualine for the auto theme to work

require("user.options")
require("user.keybindings")
require("user.plugins")
require("user.autocommands")

require("user.telescope")
require("user.treesitter")
require("user.lualine")
require("user.whichkey")
require("user.comment")
require("user.indent")
require("user.copilot")
require("user.ufo")
require("user.lsp")
require("user.spider")
require("user.notify")
require("user.noice")
require("user.harpoon")
require("user.flash")
require("user.compilemode")
require("user.smart-splits")
require("user.qf")
require("user.color_highlight")
require("user.undotree")
require("user.oil")
require("user.baleia")

vim.filetype.add {
  extension = {
    mli = "ocaml.interface",
    mly = "ocaml.menhir",
    mll = "ocaml.ocamllex",
    mlx = "ocaml",
    t = "ocaml.cram",
  },
}
