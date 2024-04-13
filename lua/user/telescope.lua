require("telescope").setup{
    defaults = {
        path_display = {"shorten"},
        dynamic_preview_title = true
    },
}
require("telescope").load_extension("ui-select")

local builtin = require("telescope.builtin")
vim.keymap.set('n', '<leader>fs', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.git_files, {})
vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
vim.keymap.set('n', '<leader>b', builtin.buffers, {})
vim.keymap.set('n', '<leader>j', builtin.jumplist, {})


vim.keymap.set('n', '<leader>p', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>r', builtin.lsp_references, {})
vim.keymap.set('n', '<leader>d', builtin.lsp_definitions, {})
vim.keymap.set('n', '<leader>s', builtin.lsp_document_symbols, {})

vim.keymap.set('n', '<leader>sh', builtin.help_tags, {})

