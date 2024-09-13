function map(m, k, v)
	vim.keymap.set(m, k, v, {noremap = true, silent = true})
end
function map_expr(m, k, v)
	api.nvim_set_keymap(m, k, v, {noremap = true, silent = true, expr = true})
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "


map("n", "<tab>", "%")
map("v", "p", '"_dP') -- make pasting not yank the text under selection in virtual mode

-- better navigation between split windows
map("n", "<C-Down>", "<C-W><C-J>")
map("n", "<C-Up>", "<C-W><C-K>")
map("n", "<C-Left>", "<C-W><C-H>")
map("n", "<C-Right>", "<C-W><C-L>")

-- move lines up/down
map("n", "<M-Down>", ":m .+1<CR>==")
map("n", "<M-Up>", ":m .-2<CR>==")
map("v", "<M-Down>", ":m '>+1<CR>gv=gv")
map("v", "<M-Up>", ":m '<-2<CR>gv=gv")

-- resize splits
-- map("n", "<C-Right>", ":vertical resize +5<CR>")
-- map("n", "<C-Left>", ":vertical resize -5<CR>")
-- map("n", "<C-Up>", ":resize +5<CR>")
-- map("n", "<C-Down>", ":resize -5<CR>")

-- change buffers
map("n", "<S-Right>", ":bnext<CR>")
map("n", "<S-Left>", ":bprev<CR>")

-- change tabs
map("n", "<S-u>", ":tabnext<CR>")
map("n", "<S-d>", ":tabprevious<CR>")
-- stay in visual mode when indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- fix indent in file
map("n", "<F7>", "gg=G")

map("n", "<leader>e", ":NvimTreeToggle<CR>")
map('n', '<leader>u', vim.cmd.UndotreeToggle)
-- My vulkan reference pages plugin
map("n", "<leader>vr", ":OpenRefPage<CR>")

map("n", "<S-*>", ":nohl<CR>")

map("n", "<S-T>", ":tag<CR>")

map("t", "<Esc>", "<C-\\><C-n>")
map("n", "<leader>ts", ":split | term<CR>")
map("n", "<leader>tv", ":vsplit | term<CR>")

map("n", "n", ":set hlsearch<CR>n")
map("n", "N", ":set hlsearch<CR>N")
map("n", "#", ":set hlsearch<CR>#")
map("n", "*", ":set hlsearch<CR>*")

map("n", "<leader>qq", function()
    local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
    local action = qf_winid > 0 and 'cclose' or 'copen'
    vim.cmd('botright '..action)
end)
map("n", "<leader>qa", ":cnext<CR>")
map("n", "<leader>qp", ":cprev<CR>")
