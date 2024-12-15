-- save on focus lost
vim.api.nvim_create_autocmd({ "FocusLost" },
    {
        pattern = { "*" },
        command = "wa"
    })

vim.api.nvim_create_autocmd({ "TermOpen" },
    {
        pattern = { "*" },
        callback = function()
            vim.opt_local.number = false
            vim.opt_local.modified = false
        end
    })

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" },
    {
        pattern = { "*.eos" },
        callback = function()
            vim.bo.filetype = "eos"
        end
    })

vim.api.nvim_create_autocmd("FileType", {
    pattern = "help",
    callback = function()
        vim.opt_local.conceallevel = 0
    end,
})
