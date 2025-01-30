vim.g.mapleader = " "
vim.g.maplocalleader = " "


local function get_opts(overrides)
    local opts = { noremap = true, silent = true }
    local overrides = overrides or {}
    return vim.tbl_extend("force", opts, overrides)
end

vim.keymap.set("v", "p", '"_dP', get_opts()) -- make pasting not yank the text under selection in virtual mode

-- better navigation between split windows
vim.keymap.set("n", "<C-Down>", "<C-W><C-J>", get_opts())
vim.keymap.set("n", "<C-Up>", "<C-W><C-K>", get_opts())
vim.keymap.set("n", "<C-Left>", "<C-W><C-H>", get_opts())
vim.keymap.set("n", "<C-Right>", "<C-W><C-L>", get_opts())

-- move lines up/down
vim.keymap.set("n", "<M-Down>", ":m .+1<CR>==", get_opts())
vim.keymap.set("n", "<M-Up>", ":m .-2<CR>==", get_opts())
vim.keymap.set("v", "<M-Down>", ":m '>+1<CR>gv=gv", get_opts())
vim.keymap.set("v", "<M-Up>", ":m '<-2<CR>gv=gv", get_opts())

-- change buffers
vim.keymap.set("n", "<S-Right>", ":bnext<CR>", get_opts())
vim.keymap.set("n", "<S-Left>", ":bprev<CR>", get_opts())

-- change tabs
vim.keymap.set("n", "<S-u>", ":tabnext<CR>", get_opts())
vim.keymap.set("n", "<S-d>", ":tabprevious<CR>", get_opts())
-- stay in visual mode when indenting
vim.keymap.set("v", "<", "<gv", get_opts())
vim.keymap.set("v", ">", ">gv", get_opts())

-- fix indent in file
vim.keymap.set("n", "<F7>", "gg=G", get_opts())

-- My vulkan reference pages plugin
vim.keymap.set("n", "<leader>vr", ":OpenRefPage<CR>", get_opts({ desc = "Open vulkan reference page" }))

vim.keymap.set("n", "<S-*>", ":nohl<CR>", get_opts())

vim.keymap.set("n", "<S-T>", ":tag<CR>", get_opts())

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", get_opts())
vim.keymap.set("n", "<leader>ts", ":split | term<CR>", get_opts({ desc = "Open split terminal" }))
vim.keymap.set("n", "<leader>tv", ":vsplit | term<CR>", get_opts({ desc = "Open vertical split terminal" }))

vim.keymap.set("n", "n", ":set hlsearch<CR>n", get_opts())
vim.keymap.set("n", "N", ":set hlsearch<CR>N", get_opts())
vim.keymap.set("n", "#", ":set hlsearch<CR>#", get_opts())
vim.keymap.set("n", "*", ":set hlsearch<CR>*", get_opts())

vim.keymap.set("n", "<leader>qq", function()
    local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
    local action = qf_winid > 0 and 'cclose' or 'copen'
    vim.cmd('botright ' .. action)
end, get_opts({ desc = "Quickfix: Toggle" }))
vim.keymap.set("n", "<leader>qa", ":cnext<CR>", get_opts({ desc = "Quickfix: Next" }))
vim.keymap.set("n", "<leader>qp", ":cprev<CR>", get_opts({ desc = "Quickfix: Previous" }))

vim.keymap.set("n", "<leader>m", "`", get_opts({ desc = "Go to mark" }))

vim.keymap.set("n", "<C-j>", "<C-O>", get_opts())
-- vim.keymap.set("n", "<C-i>", "<C-I>", get_opts())

-- Bind 'gd' to follow links in help files
vim.api.nvim_create_autocmd("FileType", {
    pattern = "help",
    callback = function()
        vim.keymap.set('n', 'gd', '<C-]>', get_opts({ buffer = true, silent = true, desc = "Go to definition" }))
    end,
})

vim.keymap.set("n", "<leader>xf", "<cmd>luafile %<CR>", get_opts({ desc = "Execute lua file" }))
vim.keymap.set("v", "<leader>x", ":lua<CR>", get_opts({ desc = "Execute lua" }))

--
-- Remap Ctrl-d for next completion item
vim.api.nvim_set_keymap('i', '<C-d>', '<C-n>', { noremap = true, silent = true })

-- Remap Ctrl-l for previous completion item
vim.api.nvim_set_keymap('i', '<C-l>', '<C-p>', { noremap = true, silent = true })
