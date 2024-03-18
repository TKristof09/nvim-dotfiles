vim.cmd [[
	au BufWritePre * %s/\s\+$//e

    function! ToggleNumbersOn()
		set nu!
		set rnu
	endfunction
	function! ToggleRelativeOn()
		set rnu!
		set nu
	endfunction
    augroup line_numbers
        autocmd FocusLost   * call ToggleRelativeOn()
        autocmd FocusGained * call ToggleRelativeOn()
        autocmd InsertEnter * call ToggleRelativeOn()
        autocmd InsertLeave * call ToggleRelativeOn()
    augroup END
]]

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
