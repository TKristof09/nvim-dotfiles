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
map("n", "<C-J>", "<C-W><C-J>")
map("n", "<C-K>", "<C-W><C-K>")
map("n", "<C-H>", "<C-W><C-H>")
map("n", "<C-L>", "<C-W><C-L>")

-- move lines up/down
map("n", "<M-j>", ":m .+1<CR>==")
map("n", "<M-k>", ":m .-2<CR>==")
map("v", "<M-j>", ":m '>+1<CR>gv=gv")
map("v", "<M-k>", ":m '<-2<CR>gv=gv")

-- resize splits
map("n", "<C-Right>", ":vertical resize +5<CR>")
map("n", "<C-Left>", ":vertical resize -5<CR>")
map("n", "<C-Up>", ":resize +5<CR>")
map("n", "<C-Down>", ":resize -5<CR>")

-- change buffers
map("n", "<S-l>", ":bnext<CR>")
map("n", "<S-h>", ":bprev<CR>")

-- change tabs
map("n", "<S-u>", ":tabnext<CR>")
map("n", "<S-d>", ":tabprevious<CR>")
-- stay in visual mode when indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- fix indent in file
map("n", "<F7>", "gg=G")

map("n", "<leader>e", ":NvimTreeToggle<CR>")
-- My vulkan reference pages plugin
map("n", "<leader>vr", ":OpenRefPage<CR>")

map("n", "<S-*>", ":nohl<CR>")

map("n", "<S-T>", ":tag<CR>")