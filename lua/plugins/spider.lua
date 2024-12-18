return {
    {
        "chrisgrieser/nvim-spider",
        opts = {
            skipInsignificantPunctuation = true
        },
        config = function(_, opts)
            local spider = require("spider")
            spider.setup(opts)
            vim.keymap.set({ "n", "o", "x" }, "w", function() spider.motion('w') end, { desc = "Spider-w" })
            vim.keymap.set({ "n", "o", "x" }, "e", function() spider.motion('e') end, { desc = "Spider-e" })
            vim.keymap.set({ "n", "o", "x" }, "b", function() spider.motion('b') end, { desc = "Spider-b" })
            vim.keymap.set({ "n", "o", "x" }, "ge", function() spider.motion('ge') end, { desc = "Spider-ge" })
        end,
        lazy = true,
        event = "VeryLazy"
    }
}
