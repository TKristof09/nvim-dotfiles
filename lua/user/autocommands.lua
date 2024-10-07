-- format on save autocmd
vim.api.nvim_create_autocmd({"BufWritePre"},
{
    pattern = {"*.cpp", "*.c", "*.h", "*.hpp", "*.rs"},
    callback = function() vim.lsp.buf.format() end
})

-- save on focus lost
vim.api.nvim_create_autocmd({"FocusLost"},
{
    pattern = {"*"},
    command = "wa"
})

vim.api.nvim_create_autocmd({"TermOpen"},
{
    pattern = {"*"},
    callback = function()
        vim.opt_local.number = false
vim.opt_local.modified = false
    end
})

vim.api.nvim_create_autocmd({"InsertEnter"},
{
    pattern = {"*"},
    callback = function()
            vim.opt.hlsearch = false
    end
})
vim.api.nvim_create_autocmd({"CmdlineEnter"},
{
    pattern = {"/"},
    callback = function()
            vim.opt.hlsearch = true
    end
})
vim.api.nvim_create_autocmd({"CmdlineEnter"},
{
    pattern = {"?"},
    callback = function()
            vim.opt.hlsearch = true
    end
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"},
{
    pattern = {"*.eos"},
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
