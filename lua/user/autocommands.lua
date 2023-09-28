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



	autocmd BufWinEnter,WinEnter term://* startinsert


]]

-- format on save autocmd
vim.api.nvim_create_autocmd({"BufWritePre"},
{
    pattern = {"*.cpp", "*.c", "*.h", "*.hpp"},
    callback = function() vim.lsp.buf.format() end
})

-- save on focus lost
vim.api.nvim_create_autocmd({"FocusLost"},
{
    pattern = {"*"},
    command = ":wa"
})

