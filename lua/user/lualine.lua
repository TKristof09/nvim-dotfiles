local diagnostics = {
    "diagnostics",
    sources = { "coc" },
    sections = { "error", "warn" },
    symbols = { error = " ", warn = " " },
    update_in_insert = false,
    always_visible = true,
}
local branch = {
    "branch",
    icons_enabled = true,
    icon = "",
}

require("lualine").setup{
    icons_enabled = true,
    theme = "auto",
    disabled_filetypes = {"coc-explorer"},

    sections = {
        lualine_a = {'mode'},
        lualine_b = {branch, diagnostics},
        lualine_c = {'filename', 'searchcount'},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {{'tabs',
            tabs_color = {
            -- Same values as the general color option can be used here.
                active = 'lualine_b_normal',     -- Color for active tab.
                inactive = 'lualine_c_inactive', -- Color for inactive tab.
            }}},
        lualine_z = {'location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
    },
    globalstatus = true,

}
