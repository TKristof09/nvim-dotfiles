return {
    -- {
    --     -- Make sure to set this up properly if you have lazy=true
    --     'MeanderingProgrammer/render-markdown.nvim',
    --     opts = {
    --         code = {
    --             sign = false,
    --             style = "normal"
    --         },
    --         anti_conceal = {
    --             enabled = false
    --         },
    --     },
    --     overrides = {
    --         buftype = {
    --             nofile = {
    --                 render_modes = { "n" },
    --                 padding = { highlight = 'NormalFloat' },
    --                 sign = { enabled = false },
    --             },
    --         },
    --     },
    --     lazy = true,
    --     ft = { "markdown" },
    -- },
    {
        "OXY2DEV/markview.nvim",
        opts = {
            preview = {
                enable = true,
                filetypes = { "md", "rmd", "markdown", "codecompanion", "blink-cmp-documentation" },
                ignore_buftypes = {},
                ignore_previews = {},
                icon_provider = "devicons", -- "mini" or "devicons"
                modes = { "n", "no", "c" },
            },
            markdown = {
                headings = {
                    heading_1 = { sign = "" },
                    heading_2 = { sign = "" }
                },
                code_blocks = {
                    sign = false,
                }
            }
        },
        lazy = false,
    },
}
