return {
    {
        "mbbill/undotree",
        config = function()
            vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
            vim.g.undotree_DiffCommand = "diff"
            vim.g.undotree_ShortIndicators = 1
            vim.g.undotree_SetFocusWhenToggle = 1
        end,
        lazy = true,
        event = "VeryLazy"
    }
}