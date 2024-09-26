
require("copilot").setup{
    panel = {
        auto_refresh =  true,
        keymap =
            {
                open = false,
                jump_next = "<C-D>",
                jump_prev = "<C-U>",
                refresh = "<leader>cr",
            },
    }
}

-- keymap for toggling the panel
local win =  -1
vim.keymap.set('n', '<leader>co', function()
    if not vim.api.nvim_win_is_valid(win) then
        require("copilot.panel").open()
        win = vim.api.nvim_get_current_win()
    else
        vim.api.nvim_win_close(win, false)
        win = -1
    end
end,
    {noremap = true, silent = true}
)
