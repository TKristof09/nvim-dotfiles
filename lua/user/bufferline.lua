require("bufferline").setup{
    options = {
        numbers = "ordinal",
        diagnostics = "coc",

        offsets = { { filetype = "coc-explorer", text = "", padding = 1} },

        separator_style = "thin", -- | "thick" | "thin" | { 'any', 'any' },
        enforce_regular_tabs = true,
        always_show_bufferline = true,
    }
}

