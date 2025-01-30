return {
    {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
            file_types = { "markdown", "Avante", "codecompanion" },
            render_modes = { "n", "c", "t", "i" },
            code = {
                sign = false,
                style = "normal"
            }
        },
        ft = { "markdown", "Avante", "codecompanion" },
    },
}
