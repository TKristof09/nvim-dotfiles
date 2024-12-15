return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        opts = {
            settings = {
                save_on_toggle = true,
            },
        },
        config = function(_, opts)
            local harpoon = require("harpoon")
            harpoon:setup(opts)

            vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end)

            vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
            vim.keymap.set("n", "<leader>hn", function() harpoon:list():select(1) end)
            vim.keymap.set("n", "<leader>hr", function() harpoon:list():select(2) end)
            vim.keymap.set("n", "<leader>ht", function() harpoon:list():select(3) end)
            vim.keymap.set("n", "<leader>hs", function() harpoon:list():select(4) end)

            vim.keymap.set("n", "<leader>hvn", function() harpoon:list():select(1, { vsplit = true }) end)
            vim.keymap.set("n", "<leader>hvr", function() harpoon:list():select(2, { vsplit = true }) end)
            vim.keymap.set("n", "<leader>hvt", function() harpoon:list():select(3, { vsplit = true }) end)
            vim.keymap.set("n", "<leader>hvs", function() harpoon:list():select(4, { vsplit = true }) end)
            -- add keymaps to open files in splits and tabs from the harpoon menu
            harpoon:extend({
                UI_CREATE = function(cx)
                    vim.keymap.set("n", "<C-v>", function()
                        harpoon.ui:select_menu_item({ vsplit = true })
                    end, { buffer = cx.bufnr })

                    vim.keymap.set("n", "<C-x>", function()
                        harpoon.ui:select_menu_item({ split = true })
                    end, { buffer = cx.bufnr })

                    vim.keymap.set("n", "<C-t>", function()
                        harpoon.ui:select_menu_item({ tabedit = true })
                    end, { buffer = cx.bufnr })
                end,
            })
        end,

        lazy = true,
        event = "VeryLazy"
    }
}
