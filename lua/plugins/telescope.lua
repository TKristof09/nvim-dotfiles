return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-ui-select.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build =
                'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release'
            },
            "nvim-tree/nvim-web-devicons"
        },
        opts = {
            defaults = {
                path_display = {
                    filename_first = {
                        reverse_directories = false
                    }
                },
                dynamic_preview_title = true
            },
            extensions = {
                fzf = {
                    fuzzy = true,                   -- false will only do exact matching
                    override_generic_sorter = true, -- override the generic sorter
                    override_file_sorter = true,    -- override the file sorter
                    case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
                    -- the default case_mode is "smart_case"
                }
            }
        },

        config = function(_, opts)
            require("telescope").setup(opts)
            require("telescope").load_extension("ui-select")
            require('telescope').load_extension('fzf')

            local builtin = require("telescope.builtin")
            vim.keymap.set('n', '<leader>fs', function() builtin.find_files({ no_ignore = true }) end,
                { desc = "Telescope: Find files" })
            vim.keymap.set('n', '<leader>fg', builtin.git_files, { desc = "Telescope: Git files" })
            vim.keymap.set('n', '<leader>g', builtin.live_grep, { desc = "Telescope: Live grep" })
            vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = "Telescope: Buffers" })
            vim.keymap.set('n', '<leader>j', builtin.jumplist, { desc = "Telescope: Jumplist" })


            vim.keymap.set('n', '<leader>pa', builtin.diagnostics, { desc = "Telescope: Diagnostics" })
            vim.keymap.set('n', '<leader>fr', builtin.lsp_references, { desc = "Telescope: Find references" })
            vim.keymap.set('n', '<leader>ss', builtin.lsp_document_symbols, { desc = "Telescope: Document symbols" })

            vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = "Telescope: Help tags" })
            vim.keymap.set('n', '<leader>tr', builtin.resume, { desc = "Telescope: Resume" })
        end,

        lazy = true,
        event = "VeryLazy"

    }
}
