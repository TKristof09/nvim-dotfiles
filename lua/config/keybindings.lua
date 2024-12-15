local opts = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = " "


vim.keymap.set("v", "p", '"_dP', opts) -- make pasting not yank the text under selection in virtual mode

-- better navigation between split windows
vim.keymap.set("n", "<C-Down>", "<C-W><C-J>", opts)
vim.keymap.set("n", "<C-Up>", "<C-W><C-K>", opts)
vim.keymap.set("n", "<C-Left>", "<C-W><C-H>", opts)
vim.keymap.set("n", "<C-Right>", "<C-W><C-L>", opts)

-- move lines up/down
vim.keymap.set("n", "<M-Down>", ":m .+1<CR>==", opts)
vim.keymap.set("n", "<M-Up>", ":m .-2<CR>==", opts)
vim.keymap.set("v", "<M-Down>", ":m '>+1<CR>gv=gv", opts)
vim.keymap.set("v", "<M-Up>", ":m '<-2<CR>gv=gv", opts)

-- change buffers
vim.keymap.set("n", "<S-Right>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-Left>", ":bprev<CR>", opts)

-- change tabs
vim.keymap.set("n", "<S-u>", ":tabnext<CR>", opts)
vim.keymap.set("n", "<S-d>", ":tabprevious<CR>", opts)
-- stay in visual mode when indenting
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- fix indent in file
vim.keymap.set("n", "<F7>", "gg=G", opts)

vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", opts)
-- My vulkan reference pages plugin
vim.keymap.set("n", "<leader>vr", ":OpenRefPage<CR>", opts)

vim.keymap.set("n", "<S-*>", ":nohl<CR>", opts)

vim.keymap.set("n", "<S-T>", ":tag<CR>", opts)

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", opts)
vim.keymap.set("n", "<leader>ts", ":split | term<CR>", opts)
vim.keymap.set("n", "<leader>tv", ":vsplit | term<CR>", opts)

vim.keymap.set("n", "n", ":set hlsearch<CR>n", opts)
vim.keymap.set("n", "N", ":set hlsearch<CR>N", opts)
vim.keymap.set("n", "#", ":set hlsearch<CR>#", opts)
vim.keymap.set("n", "*", ":set hlsearch<CR>*", opts)

vim.keymap.set("n", "<leader>qq", function()
    local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
    local action = qf_winid > 0 and 'cclose' or 'copen'
    vim.cmd('botright ' .. action)
end, opts)
vim.keymap.set("n", "<leader>qa", ":cnext<CR>", opts)
vim.keymap.set("n", "<leader>qp", ":cprev<CR>", opts)

vim.keymap.set("n", "<leader>m", "`", opts)

vim.keymap.set("n", "<C-j>", "<C-O>", opts)
-- vim.keymap.set("n", "<C-i>", "<C-I>", opts)

-- Bind 'gd' to follow links in help files
vim.api.nvim_create_autocmd("FileType", {
    pattern = "help",
    callback = function()
        vim.keymap.set('n', 'gd', '<C-]>', { buffer = true, silent = true }, opts)
    end,
})
