local last_cmd = ""
local Job = require('plenary.job')

local function run_cmd(cmd)
    -- Separate the binary (first word)
    local binary = cmd:match("^[^%s]+")
    local args = {}

    -- Extract the arguments (everything after the binary)
    for arg in cmd:gmatch("%S+") do
        if arg ~= binary then
            table.insert(args, arg)
        end
    end

    print("Running command: " .. binary .. " with args: " .. table.concat(args, " "))
    vim.fn.setqflist({}, 'r')
    Job:new({
        command = binary,
        args = args,

        on_stderr = function(err, data)
            vim.schedule(function()
                vim.fn.setqflist({}, 'a', {
                    title = cmd .. " output",
                    lines = {data}
                })
                vim.cmd("botright cwindow")
            end)
        end,
        on_stdout = function(err, data)
            vim.schedule(function()
                vim.fn.setqflist({}, 'a', {
                    title = cmd .. " output",
                    lines = {data}
                })
                vim.cmd("botright cwindow")
            end)
        end,
        on_exit = function(job, exit_code)
            vim.schedule(function()
                vim.fn.setqflist({}, 'a', {
                    lines = {"Command finished with exit code: " .. exit_code}
                })
                vim.cmd("botright cwindow")
            end)
        end
    }):start()
end

local function ask_and_run_command()
    vim.ui.input({
        prompt="Enter command to run: ",
        completion="shellcmd"
    }, function(cmd)
            if not cmd or cmd == "" then
                return
            end

            last_cmd = cmd
            if not vim.fn.empty(vim.fn.expand("%")) == 1 then
                vim.cmd("w")
                cmd = cmd:gsub("%%", vim.fn.expand("%"))
            end
            run_cmd(cmd)
        end)
end

local function recompile()
    if last_cmd == "" then
        ask_and_run_command()
    else

        local cmd = last_cmd
        if not vim.fn.empty(vim.fn.expand("%")) == 1 then
            vim.cmd("w")
            cmd = cmd:gsub("%%", vim.fn.expand("%"))
        end
        print("Running command: " .. cmd)
        run_cmd(cmd)
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
