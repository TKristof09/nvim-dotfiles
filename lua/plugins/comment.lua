return {
    {
        "numToStr/Comment.nvim",
        opts =
        {
            padding = true,

        },
        config = function(_, opts)
            require("Comment").setup(opts)
            local ft = require('Comment.ft')
            ft({ 'hlsl' }, ft.get('c'))
        end,
        lazy = true,
        event = "VeryLazy"
    }
}
