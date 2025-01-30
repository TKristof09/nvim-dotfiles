return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
        keywords = {
            TODO = { icon = " ", color = "warning" },
        },
        highlight = {
            keyword = "fg",
            after = "",
            pattern = [[<(KEYWORDS)]]
        },
        search = {
            pattern = "\\b(KEYWORDS)[: ]"
        }
    }
}
