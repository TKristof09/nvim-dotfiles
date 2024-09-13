require("telescope").setup{
    defaults = {
        path_display = {
            filename_first = {
                reverse_directories = false
            }
        },        dynamic_preview_title = true
    },
}
require("telescope").load_extension("ui-select")

local builtin = require("telescope.builtin")
vim.keymap.set('n', '<leader>fs', function ()
    builtin.find_files({no_ignore = true})
end, {})
vim.keymap.set('n', '<leader>fg', builtin.git_files, {})
vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
vim.keymap.set('n', '<leader>b', builtin.buffers, {})
vim.keymap.set('n', '<leader>j', builtin.jumplist, {})


vim.keymap.set('n', '<leader>pa', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>fr', builtin.lsp_references, {})
vim.keymap.set('n', '<leader>d', builtin.lsp_definitions, {})
vim.keymap.set('n', '<leader>ss', builtin.lsp_document_symbols, {})

vim.keymap.set('n', '<leader>sh', builtin.help_tags, {})

