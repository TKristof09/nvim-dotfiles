local diagnostics = {
    "diagnostics",
    sources = { "nvim_lsp" },
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
return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "SmiteshP/nvim-navic"
        },
        opts = {
            icons_enabled = true,
            theme = "auto",
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { branch, diagnostics },
                lualine_c = {
                    'filename',
                    'searchcount',
                    -- {
                    -- require("noice").api.statusline.mode.get,
                    -- cond = require("noice").api.statusline.mode.has,
                    -- color = { fg = "#ff1818", gui = "bold" },
                    -- },
                },
                lualine_x = { 'encoding', 'fileformat', 'filetype' },
                lualine_y = { {
                    'tabs',
                    tabs_color = {
                        -- Same values as the general color option can be used here.
                        active = 'lualine_b_normal',     -- Color for active tab.
                        inactive = 'lualine_c_inactive', -- Color for inactive tab.
                    }
                } },
                lualine_z = { 'location' }
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { "filename" },
                lualine_x = { "location" },
                lualine_y = {},
                lualine_z = {},
            },
            winbar = {
                lualine_c = {
                    {
                        "navic",
                        color = 'lualine_b_normal',
                        color_correction = nil,
                        navic_opts = nil,
                        draw_empty = true
                    }
                }
            },
            globalstatus = true,
        }
    }
}
