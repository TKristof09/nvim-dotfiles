-- Import plenary job
local Job = require('plenary.job')

-- Define the main plugin module
local CompilationPlugin = {}

local buf = -1 
local highlight_ns = vim.api.nvim_create_namespace("compilemode/highlight")
local last_cmd = ""
local job = nil


local find_buffer_by_name = function(name)
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        local buf_name = vim.api.nvim_buf_get_name(buf)
        if buf_name == name then
            return buf
        end
    end
    return -1
end

-- Create a buffer with the name #compilation# in a new split window at the bottom
local function create_compilation_buffer()
    if vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
        local wins = vim.fn.win_findbuf(buf)
        if #wins == 0 then
            vim.cmd('botright split')
            vim.api.nvim_win_set_buf(0, buf)
        else
            vim.api.nvim_set_current_win(wins[1])
        end
        return buf
    end

    -- Create a new scratch buffer
    buf = vim.api.nvim_create_buf(false, true) -- unlisted, scratch buffer

    vim.cmd('botright split')
    vim.api.nvim_win_set_buf(0, buf)

    return buf
end
local function add_output(output)
	if output ~= nil then
		vim.schedule(function()
			local n = vim.api.nvim_buf_line_count(buf)
			local lines = {}
			for line in output:gmatch("[^\r\n]+") do
				table.insert(lines, line)
			end
			vim.api.nvim_buf_set_lines(buf, n, n + #lines + 1, false, lines)
			vim.api.nvim_buf_call(buf, function()
				vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), {vim.api.nvim_buf_line_count(buf), 0})
			end)
		end)
	end
end

local function highlight_buffer()
    for i, line in ipairs(vim.api.nvim_buf_get_lines(buf, 2, -1, false)) do
        local start_pos, end_pos = string.find(line, "[%s?:?%w_%-/\\%.~]+%.[%w_]+[%(:]%d+[%):]")
        if start_pos and end_pos then
            vim.highlight.range(buf, highlight_ns, "Underlined", {i + 2 -1, start_pos-1}, {i + 2-1, end_pos}, {})
        end
    end

end

-- Function to execute a command asynchronously using plenary.job
local function run_command(command)
    buf = create_compilation_buffer()

    local first = command:match("^[^%s]+")
    local binary = vim.fn.exepath(first)
    local args = {}

    -- Extract the arguments (everything after the binary)
    command = command:sub(#first + 1)
    for arg in command:gmatch("%S+") do
        if arg ~= binary then
            table.insert(args, arg)
        end
    end

    vim.api.nvim_buf_set_lines(buf, 0, 2, false, {"Running command: " .. binary .. " " .. table.concat(args, " ") .. " (CWD: " .. vim.fn.getcwd() .." )", ""})
    vim.highlight.range(buf, highlight_ns, "Italic", {0, 0}, {0, vim.fn.col("$")}, {})

    job = Job:new({
        command = binary,
        args = args,
        cwd = vim.fn.getcwd(),

        on_stdout = function(err, output)
            -- Parse and write errors to the buffer
            add_output(output)
        end,
        on_stderr = function(err, output)
            add_output(output)
        end,
        on_exit = function(j, return_val)
            if return_val == 0 then
                vim.schedule(function()
                    vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "", "Compilation finished" })
                    local start_pos, end_pos = string.find(vim.api.nvim_buf_get_lines(buf, -2, -1, false)[1], "finished")
                    local line_num = vim.api.nvim_buf_line_count(buf)
                    vim.highlight.range(buf, highlight_ns, "DiagnosticHint", {line_num - 1, start_pos-1}, {line_num - 1, end_pos}, {})

					vim.api.nvim_buf_call(buf, function()
						vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), {vim.api.nvim_buf_line_count(buf), 0})
					end)
                end)
            else 
                vim.schedule(function()
                    vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "", "Compilation exited abnormally with code " .. return_val })
                    local start_pos, end_pos = string.find(vim.api.nvim_buf_get_lines(buf, -2, -1, false)[1], "exited abnormally")
                    local line_num = vim.api.nvim_buf_line_count(buf)
                    vim.highlight.range(buf, highlight_ns, "DiagnosticError", {line_num - 1, start_pos - 1}, {line_num - 1, end_pos}, {})
                    vim.highlight.range(buf, highlight_ns, "DiagnosticError", {line_num - 1, end_pos + 11}, {line_num - 1, end_pos + 11 + tostring(return_val):len()}, {})

					vim.api.nvim_buf_call(buf, function()
						vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), {vim.api.nvim_buf_line_count(buf), 0})
					end)
                end)
            end
            vim.schedule(highlight_buffer)
        end
    })
	job:start()
end

local function stop_job()
	if job ~= nil then
		job:shutdown(-69, 15)

		vim.schedule(function()
			vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "Compilation terminated forcefully"})
			local start_pos, end_pos = string.find(vim.api.nvim_buf_get_lines(buf, -2, -1, false)[1], "terminated forcefully")
			local line_num = vim.api.nvim_buf_line_count(buf)
			vim.highlight.range(buf, highlight_ns, "DiagnosticError", {line_num - 1, start_pos - 1}, {line_num - 1, end_pos}, {})

			vim.api.nvim_buf_call(buf, function()
				vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), {vim.api.nvim_buf_line_count(buf), 0})
			end)
		end)
	else
		vim.print("Job isn't running")
	end
end

local function goto_error()
    local line = vim.api.nvim_get_current_line()
    local file, line_num, col = string.match(line, "([%s?:?%w_%-/\\%.~]+%.[%w_]+)[%(:](%d+)[%):(%d+)]")
    if file and line then
        local target_buf = find_buffer_by_name(file)
        if target_buf == -1 then
            target_buf = vim.fn.bufadd(file)
        end
        local win = vim.fn.win_getid(1)
        local wins = vim.fn.win_findbuf(target_buf)
        if #wins > 0 then
            if vim.api.nvim_win_get_tabpage(wins[1]) == vim.api.nvim_get_current_tabpage() then
                win = wins[1]
            end
        end
        vim.api.nvim_win_set_buf(win, target_buf)
        vim.api.nvim_set_current_win(win)
        vim.api.nvim_win_set_cursor(win, {tonumber(line_num), tonumber(col) or 0})

    end
end

local function next_error()
    if not vim.api.nvim_buf_is_valid(buf) then
        return
    end

    local wins = vim.fn.win_findbuf(buf)
    local compile_win = 0
    if #wins == 0 then
        vim.cmd('botright split')
        vim.api.nvim_win_set_buf(0, buf)
        compile_win = vim.api.nvim_get_current_win()
    else
        compile_win = wins[1]
    end

    local current_line = vim.api.nvim__buf_stats(buf).current_lnum
    local lines = vim.api.nvim_buf_get_lines(buf, current_line, -1, false)
    vim.list_extend(lines, vim.api.nvim_buf_get_lines(buf, 0, current_line, false))
    for i, line in ipairs(lines) do
        local item = vim.fn.getqflist({lines = {line}}).items[1]
        if item.type ~= "" then 
            local win = vim.fn.win_getid(1)
            wins = vim.fn.win_findbuf(item.bufnr)
            if #wins > 0 then
                if vim.api.nvim_win_get_tabpage(wins[1]) == vim.api.nvim_get_current_tabpage() then
                    win = wins[1]
                end
            end
            vim.api.nvim_win_set_buf(win, item.bufnr)
            vim.api.nvim_set_current_win(win)
            vim.api.nvim_win_set_cursor(win, {item.lnum, item.col})
            vim.api.nvim_win_set_cursor(compile_win, {math.fmod(i + current_line, vim.api.nvim_buf_line_count(buf)), 0})
            break
        end
    end
end
function CompilationPlugin.toggle_window()
    local wins = vim.fn.win_findbuf(buf)
    if #wins == 0 then
        vim.cmd('botright split')
        vim.api.nvim_win_set_buf(0, buf)
    else
        vim.api.nvim_win_close(wins[1], true)
    end
end

function CompilationPlugin.compile()
    vim.ui.input({ prompt = 'Enter compilation command: ' }, function(input)
        if input then

            local cmd = input
            if not (vim.fn.empty(vim.fn.expand("%")) == 1) then
                vim.cmd("w")
                cmd = cmd:gsub("%%", vim.fn.expand("%"))
            end
            run_command(cmd)
            last_cmd = cmd
        end
    end)
end

function CompilationPlugin.recompile()
     if last_cmd == "" then
        CompilationPlugin.compile()
    else
        local cmd = last_cmd
        if not (vim.fn.empty(vim.fn.expand("%")) == 1) then
            vim.cmd("w")
            cmd = cmd:gsub("%%", vim.fn.expand("%"))
        end
        run_command(cmd)
    end
end

function CompilationPlugin:stop()
	stop_job()
end

function CompilationPlugin.next_error()
    next_error()
end

function CompilationPlugin.goto_error()
    goto_error()
end

-- Autocommand to close if the compile window is the last one open
vim.api.nvim_create_autocmd("QuitPre", {
    callback = function()
        local compile_wins = {}
        local floating_wins = {}
        local wins = vim.api.nvim_list_wins()
        for _, w in ipairs(wins) do
            if vim.api.nvim_win_get_buf(w) == buf then
                table.insert(compile_wins, w)
            end
            if vim.api.nvim_win_get_config(w).relative ~= '' then
                table.insert(floating_wins, w)
            end
        end
        if 1 == #wins - #floating_wins - #compile_wins then
            -- Should quit, so we close all invalid windows.
            for _, w in ipairs(compile_wins) do
                vim.api.nvim_win_close(w, true)
            end
        end
    end
})

vim.api.nvim_buf_set_keymap(buf, 'n', '<2-LeftMouse>', '', {
    noremap = true,
    callback = function()
        CompilationPlugin.goto_error()
    end
})

vim.keymap.set('n', '<leader>ct', function()
    CompilationPlugin.toggle_window()
end, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>cc', function()
    CompilationPlugin.compile()
end, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>cr', function()
    CompilationPlugin.recompile()
end, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>ce', function()
    CompilationPlugin.next_error()
end, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>cg', function()
    CompilationPlugin.goto_error()
end, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>ck', function()
	CompilationPlugin.stop()
end, { noremap = true, silent = true })

-- glslangValidator errorformat
vim.opt.errorformat:prepend("%EERROR: %f:%l: %m")
vim.opt.errorformat:prepend("%WWARNING: %f:%l: %m")
-- glslc errorformat
vim.opt.errorformat:prepend("%E%f:%l: error: %m")
vim.opt.errorformat:prepend("%W%f:%l: warning: %m")
return CompilationPlugin
