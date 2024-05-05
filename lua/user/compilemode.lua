local last_cmd = ""
local function ask_and_run_command()
    local cmd = vim.ui.input({
        prompt="Enter command to run: ",
        completion="shellcmd"
    }, function(cmd)
            if not cmd or cmd == "" then
                return
            end

            vim.cmd("w")
            last_cmd = cmd
            cmd = cmd:gsub("%%", vim.fn.expand("%"))
            print("Running command: " .. cmd)
            vim.fn.setqflist({}, ' ', {
                lines = vim.fn.systemlist(cmd)
            })
            vim.cmd("cwindow")
        end)
end

local function recompile()
    if last_cmd == "" then
        ask_and_run_command()
    else

        vim.cmd("w")
        local cmd = last_cmd:gsub("%%", vim.fn.expand("%"))
        print("Running command: " .. cmd)
        vim.fn.setqflist({}, ' ', {
            lines = vim.fn.systemlist(cmd)
        })
        vim.cmd("cwindow")
    end
end

vim.api.nvim_create_user_command("Compile", function()
    ask_and_run_command()
end, {
        nargs = 0
    })
vim.api.nvim_create_user_command("Recompile", function()
    recompile()
end, {
        nargs = 0
    })

-- keybind
vim.keymap.set('n', '<leader>cc', function()
    ask_and_run_command()
end, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>cr', function()
    recompile()
end, { noremap = true, silent = true })
