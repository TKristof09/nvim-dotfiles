return {
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {
            exclude = { filetypes = { "markdown" } }
        },
        lazy = true,
        event = "VeryLazy"
    }
}
