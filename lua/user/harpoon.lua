local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup({
    settings = {
        save_on_toggle = true,
    },
})
-- REQUIRED
--[[ local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
            results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
    }):find()
end

vim.keymap.set("n", "<leader>hl", function() toggle_telescope(harpoon:list()) end,
    { desc = "Open harpoon window" }) ]]
vim.keymap.set("n", "<leader>ha", function() harpoon:list():append() end)

vim.keymap.set("n", "<leader>hl", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
vim.keymap.set("n", "<leader>hq", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<leader>hw", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<leader>he", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<leader>hr", function() harpoon:list():select(4) end)

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
